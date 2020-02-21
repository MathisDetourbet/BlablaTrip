//
//  AuthTokenRegistry.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

final class AuthTokenRegistry {
    
    private(set) var authToken: AuthToken?
    
    public var isTokenExist: Bool {
        return authToken != nil
    }
    
    public var isTokenValid: Bool {
        return false
    }
    
    public func updateToken(authToken: AuthToken) {
        self.authToken = authToken
    }
}
