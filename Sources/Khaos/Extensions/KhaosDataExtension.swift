//
//  KhaosDataExtension.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation

extension Data {
    func dataToString() -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
    
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as? String
        }
    }
}

