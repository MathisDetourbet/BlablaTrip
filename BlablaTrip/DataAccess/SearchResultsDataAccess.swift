//
//  SearchResultsDataAccess.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchResultsDataAccessInterface {
    func fetchSearchTrips(departureCity: String, arrivalCity: String) -> Single<SearchResults>
}

struct SearchResultsDataAccess: SearchResultsDataAccessInterface {
    
    let configuration: Configuration
    let networkLayer: NetworkLayer
    
    func fetchSearchTrips(departureCity: String, arrivalCity: String) -> Single<SearchResults> {
        let requestProperties = RequestProperties(baseUrl: configuration.baseApiUrl,
                                                  endPoint: .trips,
                                                  method: .get,
                                                  headers: nil,
                                                  parameters: nil)
        return networkLayer.sendRequest(with: requestProperties).asSingle()
    }
}
