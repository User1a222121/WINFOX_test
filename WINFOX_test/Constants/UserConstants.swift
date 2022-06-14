//
//  UserConstants.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import Foundation

final class UserConstants {
    
    static let shared = UserConstants()
    
    let defaults = UserDefaults.standard
    
    var phoneNumber: String? {
        get {
            return defaults.value(forKey: "phoneNumber") as? String
        }
        set {
            defaults.set(newValue, forKey: "phoneNumber")
        }
    }
}
