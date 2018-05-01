//
//  Double+roundTo.swift
//  Snacktacular
//
//  Created by Juan Suarez on 4/15/18.
//  Copyright © 2018 Juan Suarez. All rights reserved.



import Foundation

extension Double {
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double(places))
        let rounded = (self * tenToPower).rounded() / tenToPower
        return rounded
    }
}
