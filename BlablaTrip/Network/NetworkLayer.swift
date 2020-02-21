//
//  NetworkLayer.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

typealias RequestCompletionHandler<Data: Decodable> = (Result<Data, NetworkError>) -> Void

protocol NetworkLayer {
    var configuration: Configuration { get }
    func sendRequest<T: Decodable>(with properties: RequestProperties, completion: @escaping RequestCompletionHandler<T>)
    func sendRequest<T: Decodable>(with properties: RequestProperties) -> Observable<T>
}

final class NetworkService: NetworkLayer {
    
    private let disposeBag = DisposeBag()
    
    func sendRequest<T>(with properties: RequestProperties) -> Observable<T> where T: Decodable {
        let obs = Observable<T>.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            
            self.sendAuthTokenRequestIfNeeded().subscribe(onCompleted: {
                guard let url = properties.url else {
                    observer.onError(NetworkError.badUrl); return
                }
                let headers = self.buildRequestHTTPHeaders(isPublicRequest: properties.endPoint.isPublic)
                
                AF
                    .request(url, method: properties.method, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self, decoder: NetworkService.jsonDecoder) { (dataResponse: DataResponse<T, AFError>) in
                        switch dataResponse.result {
                        case .success(let decodedData):
                            observer.onNext(decodedData)
                            observer.onCompleted()
                            break
                            
                        case .failure(let afError):
                            observer.onError(NetworkError.createFrom(alamofireError: afError)); break
                        }
                }
            }) { error in
                observer.onError(error)
            }.disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        return obs
    }
    
    private func sendAuthTokenRequestIfNeeded() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                return Disposables.create()
            }
            
            if self.authTokenRegistry.isTokenValid {
                completable(.completed)
            }
            
            let requestProperties = self.buildAuthRequestProperties()
            
            guard let url = requestProperties.url else {
                completable(.error(NetworkError.badUrl))
                return Disposables.create()
            }

            AF
                .request(url,
                         method: requestProperties.method,
                         parameters: requestProperties.parameters as? AuthCredentials,
                         encoder: NetworkService.jsonParameterEncoder,
                         headers: requestProperties.headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AuthToken.self, decoder: NetworkService.jsonDecoder) { [weak self] (dataResponse: DataResponse<AuthToken, AFError>) in
                    switch dataResponse.result {
                    
                    case .success(let authToken):
                        self?.authTokenRegistry.updateToken(authToken: authToken)
                        completable(.completed)
                        
                    case .failure(let afError):
                        completable(.error(NetworkError.createFrom(alamofireError: afError)))
                    }
                }
            return Disposables.create()
        }
    }
    
    
    internal let configuration: Configuration
    internal let authTokenRegistry: AuthTokenRegistry
    
    init(configuration: Configuration, authTokenRegistry: AuthTokenRegistry = AuthTokenRegistry()) {
        self.configuration = configuration
        self.authTokenRegistry = authTokenRegistry
    }
}

// MARK: - Request Implementations
extension NetworkService {
    
    func sendRequest<T: Decodable>(with properties: RequestProperties, completion: @escaping RequestCompletionHandler<T>) {
        sendAuthTokenRequestIfNeeded(completion: { [weak self] (result: Result<AuthToken, NetworkError>) in
            switch result {
            case .success(_):
                
                guard let url = properties.url else {
                    completion(.failure(.badUrl)); return
                }
                let headers = self?.buildRequestHTTPHeaders(isPublicRequest: properties.endPoint.isPublic)
                
                AF
                    .request(url, method: properties.method, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self, decoder: NetworkService.jsonDecoder) { (dataResponse: DataResponse<T, AFError>) in
                        switch dataResponse.result {
                        case .success(let decodedData):
                            completion(.success(decodedData))
                            break
                            
                        case .failure(let afError):
                            completion(.failure(NetworkError.createFrom(alamofireError: afError))); break
                        }
                }
                break
                
            case .failure(let networkError):
                completion(.failure(networkError)); break
            }
        })
    }
    
    
    private func sendAuthTokenRequestIfNeeded(completion: @escaping RequestCompletionHandler<AuthToken>) {
        if let authToken = authTokenRegistry.authToken, authTokenRegistry.isTokenValid {
            completion(.success(authToken)); return
        }
        
        let requestProperties = buildAuthRequestProperties()
        
        guard let url = requestProperties.url else {
            completion(.failure(NetworkError.badUrl)); return
        }

        AF
            .request(url,
                     method: requestProperties.method,
                     parameters: requestProperties.parameters as? AuthCredentials,
                     encoder: NetworkService.jsonParameterEncoder,
                     headers: requestProperties.headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AuthToken.self, decoder: NetworkService.jsonDecoder) { [weak self] (dataResponse: DataResponse<AuthToken, AFError>) in
                switch dataResponse.result {
                
                case .success(let authToken):
                    self?.authTokenRegistry.updateToken(authToken: authToken)
                    completion(.success(authToken)); break
                    
                case .failure(let afError):
                    completion(.failure(NetworkError.createFrom(alamofireError: afError))); break
                }
            }
    }
}

// MARK: - Auth Request Properties Builder
extension NetworkService {
    
    private func buildAuthRequestProperties() -> RequestProperties {
        let endPoint = EndPoint.token
        let authCredentials = AuthCredentials()
        let headers = buildRequestHTTPHeaders(isPublicRequest: endPoint.isPublic)
        let requestProperties = RequestProperties(baseUrl: configuration.baseUrl,
                                                  endPoint: endPoint,
                                                  method: .post,
                                                  headers: headers,
                                                  parameters: authCredentials)
        return requestProperties
    }
}

// MARK: - HTTP Headers Configuration
extension NetworkService {
    
    enum HTTPHeaderName {
        static let cacheControl = "cache-control"
    }
    
    enum HTTPHeaderValue {
        static let applicationJson = "application/json"
        static let fr = "fr"
        static let noCache = "no-cache"
    }
    
    private func buildRequestHTTPHeaders(isPublicRequest isPublic: Bool) -> HTTPHeaders {
        return isPublic ? buildPublicRequestHTTPHeaders() : buildPrivateRequestHTTPHeaders()
    }
    
    // Public request: no access token
    private func buildPublicRequestHTTPHeaders() -> HTTPHeaders {
        return [
            .contentType(HTTPHeaderValue.applicationJson),
            .accept(HTTPHeaderValue.applicationJson)
        ]
    }
    
    // Private request: access token must be valid
    private func buildPrivateRequestHTTPHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            .accept(HTTPHeaderValue.applicationJson),
            .acceptLanguage(HTTPHeaderValue.fr)
        ]
        
        // Inject manually cache control header
        headers.add(name: HTTPHeaderName.cacheControl, value: HTTPHeaderValue.noCache)
        
        // Inject auth token if exists
        if let authToken = authTokenRegistry.authToken {
            headers.add(.authorization(bearerToken: authToken.accessToken))
        }
        
        return headers
    }
}

// MARK: - JSON Parameter Encoder & Decoder Configuration
extension NetworkService {
    
    private static var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    private static var jsonParameterEncoder: JSONParameterEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return JSONParameterEncoder(encoder: jsonEncoder)
    }
}
