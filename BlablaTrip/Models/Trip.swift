//
//  Trip.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

struct Trip {
    let user: Driver
    let departureDate: String
    let departurePlace: Place
    let arrivalPlace: Place
    let priceWithCommission: PriceWithCommission
}

extension Trip: Decodable {}
