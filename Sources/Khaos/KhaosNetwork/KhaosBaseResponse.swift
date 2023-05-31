//
//  KhaosBaseResponse.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation

enum KhaosStatus {
    case success
    case failed
}

struct KhaosBaseResponse: Codable {
    let IsSucceed: Bool?
    let Message: String?
}
