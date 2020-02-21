//
//  SearchResultsBusinessService.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import RxSwift

class SearchResultsBusinessService {
    
    private let dataAccess: SearchResultsDataAccessInterface
    
    init(dataAccess: SearchResultsDataAccessInterface) {
        self.dataAccess = dataAccess
    }
    
    func fetchSearchTrips(departureCity: String, arrivalCity: String) -> Single<[Trip]> {
        return
            dataAccess
                .fetchSearchTrips(departureCity: departureCity, arrivalCity: arrivalCity)
                .map { return $0.trips }
    }
}
