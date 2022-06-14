//
//  DataModel.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import Foundation

struct PlacesModelData: Decodable {
    let image: String
    let name: String
    let id: String
    let latitide: Double
    let longitude: Double
    let desc: String
}


struct MenuModelData: Decodable {
    let image: String
    let price: Double
    let name: String
    let weight: Double
    let desc: String
}
