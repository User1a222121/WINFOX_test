//
//  PhoneMask.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import Foundation

class HelperPhoneMask {
    
    public static func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else if ch == "Y" {
                result.append("7")
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    public static func reverseFormat(phone: String) -> String {
        
        let words = phone.lowercased()
                   .split(separator: "\n")
                   .flatMap{$0.split(separator: " ")}
        let result = words.reduce ("",+).filter { "0123456789".contains($0)}
        return result
    }
}
