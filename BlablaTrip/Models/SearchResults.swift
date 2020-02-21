//
//  SearchTripApiResponse.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

struct SearchResults {
    let trips: [Trip]
}

extension SearchResults: Decodable {}
