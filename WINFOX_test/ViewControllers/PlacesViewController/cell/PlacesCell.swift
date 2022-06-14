//
//  PlacesCell.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit

class PlacesCell: UICollectionViewCell {
    
    // MARK: - Propirties
    static let reuseId = "PlacesCell"
    
    // MARK: - Outlets
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var namePlace: UILabel!
    
    // MARK: - func
    func setCell(with model: PlacesModelData) {
        namePlace.text = model.name
        NetworkServices.shared.getImage(image: model.image) { image in
            self.imagePlace.image = image
        }
    }
}

