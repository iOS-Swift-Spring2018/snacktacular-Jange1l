//
//  SpotPhotosCollectionViewCell.swift
//  Snacktacular
//
//  Created by Juan Suarez on 4/15/18.
//  Copyright © 2018 Juan Suarez. All rights reserved.
//

import UIKit

class SpotPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            photoImageView.image = photo.image
        }
    }
}
