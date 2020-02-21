//
//  TripTableViewCell.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 20/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import UIKit
import Kingfisher

protocol TripTableViewCellPresentable {
    var departureTime: String { get }
    var driverPictureImage: URL? { get }
    var departureCity: String { get }
    var arrivalCity: String { get }
    var driverName: String { get }
    var priceWithCommission: String { get }
}

class TripTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "idTripTableViewCell"

    @IBOutlet private weak var departureTimeLabel: UILabel!
    @IBOutlet private weak var driverPictureImageView: UIImageView! {
        didSet {
            self.driverPictureImageView.layer.cornerRadius = self.driverPictureImageView.frame.size.width / 2
        }
    }
    @IBOutlet private weak var departureCityLabel: UILabel!
    @IBOutlet private weak var arrivalCityLabel: UILabel!
    @IBOutlet private weak var driverNameLabel: UILabel!
    @IBOutlet private weak var priceWithCommissionLabel: UILabel!
    
    func fill(with presenter: TripTableViewCellPresentable) {
        departureTimeLabel.text = presenter.departureTime
        departureCityLabel.text = presenter.departureCity
        arrivalCityLabel.text = presenter.arrivalCity
        driverNameLabel.text = presenter.driverName
        priceWithCommissionLabel.text = presenter.priceWithCommission
        
        if let imageUrl = presenter.driverPictureImage {
            driverPictureImageView.kf.setImage(with: imageUrl)
        }
    }
}
