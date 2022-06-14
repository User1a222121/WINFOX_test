//
//  MenuPlaceCell.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 12.06.2022.
//

import UIKit

class MenuPlaceCell: UITableViewCell {
    
    // MARK: - Propirties
    static let reuseId = "MenuPlaceCell"
    
    // MARK: - Outlets
    @IBOutlet weak var imageDish: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(with model: MenuModelData) {
        NetworkServices.shared.getImage(image: model.image) { image in
            self.imageDish.image = image
        }
        nameLbl.text = model.name
        descLbl.text = model.desc
        weightLbl.text = "\(String(model.weight))гр."
        priceLbl.text = "Цена- \(String(format: "%.2f",model.price))руб."
    }
}
