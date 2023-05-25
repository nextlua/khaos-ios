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

    let isSucceed: Bool?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case isSucceed = "IsSucceed"
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        isSucceed = try? values?.decodeIfPresent(Bool?.self, forKey: .isSucceed) as? Bool
        message = try? values?.decodeIfPresent(String?.self, forKey: .message) as? String
    }
    
    var status: KhaosStatus {
        if isSucceed ?? false {
            return .success
        }
        return .failed
    }
}
