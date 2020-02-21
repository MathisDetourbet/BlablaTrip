//
//  AccessToken.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

struct AuthToken {
    let accessToken: String
    let issuedAt: Int32
    let expiresIn: Int
}

extension AuthToken: Decodable {}
