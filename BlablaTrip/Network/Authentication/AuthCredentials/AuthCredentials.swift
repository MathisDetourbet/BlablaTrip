//
//  AuthCredentials.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation
import Alamofire

struct AuthCredentials {
    let clientId: String = "ios-technical-tests"
    let clientSecret: String = "rVSUYoebg6zbZxYNxGOGAxv09oSi3gGg"
    let grantType: String = "client_credentials"
    let scopes: [String] = [
        "SCOPE_TRIP_DRIVER",
        "DEFAULT",
        "SCOPE_INTERNAL_CLIENT"
    ]
}

extension AuthCredentials: Encodable {}
