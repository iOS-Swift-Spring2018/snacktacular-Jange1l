//
//  SpotsTableViewCell.swift
//  Snacktacular
//
//  Created by Juan Suarez on 4/15/18.
//  Copyright © 2018 Juan Suarez. All rights reserved.
//

import UIKit
import CoreLocation

class SpotsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var currentLocation: CLLocation!
    var spot: Spot! {
        didSet {
            nameLabel.text = spot.name
            if spot.averageRating == 0 {
                ratingLabel.text = "Avg. Rating: -.-"
            } else {
                let rating = spot.averageRating.roundTo(places: 1)
                ratingLabel.text = "Avg. Rating: \(rating)"
            }
            var distanceString = ""
            if currentLocation != nil {
                let distanceInMeters = spot.location.distance(from: currentLocation)
                distanceString = "Distance: \((distanceInMeters * 0.00062137).roundTo(places: 2)) miles"
            }
            distanceLabel.text = distanceString
        }
    }
}
