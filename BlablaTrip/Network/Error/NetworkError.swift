//
//  NetworkError.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case badUrl
    case noResponseData
    case decodingError
    case unknown
    case authenticationRequired
    case invalidRequest
    case internalServerError
    
    enum CodingError {
        case encodingError
        case decodingError
    }
    
    enum AuthTokenError: Error {
        case expiredToken
    }
    
    static func createFrom(alamofireError afError: AFError) -> Self {
        guard let statusCode = afError.responseCode else {
            return .unknown
        }
        
        switch statusCode {
        case 400:
            return .invalidRequest
        case 401:
            return .authenticationRequired
        case 500..<600:
            return .internalServerError
        default:
            return unknown
        }
    }
}
