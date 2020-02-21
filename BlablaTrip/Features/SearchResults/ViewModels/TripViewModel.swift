//
//  TripViewModel.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 21/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import Foundation

struct TripViewModel: TripTableViewCellPresentable {
    
    private let tripModel: Trip
    
    var departureTime: String {
        return getTimeStringFrom(tripModel.departureDate)
    }
    var driverPictureImage: URL? {
        return URL(string: tripModel.user.picture)
    }
    var departureCity: String {
        return tripModel.departurePlace.cityName
    }
    var arrivalCity: String {
        return tripModel.arrivalPlace.cityName
    }
    var driverName: String {
        return tripModel.user.displayName
    }
    var priceWithCommission: String {
        return tripModel.priceWithCommission.stringValue
    }
    
    init(tripModel: Trip) {
        self.tripModel = tripModel
    }
    
    private func getTimeStringFrom(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
        let hours = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        return "\(hours):\(minutes)"
    }
}
