//
//  EndPoint.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case token = "/token"
    case trips = "/trips?_format=json&locale=fr_FR&cur=EUR&fn=Paris&tn=Rennes"
    
    var isPublic: Bool {
        return self == .token
    }
}
