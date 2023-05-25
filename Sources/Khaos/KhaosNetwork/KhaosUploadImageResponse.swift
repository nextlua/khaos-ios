//
//  KhaosUploadImageResponse.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation

struct KhaosUploadImageResponse: Codable {
    var isSucceed: Bool?
    var message: String?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case isSucceed, message, data
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        isSucceed = try? values?.decodeIfPresent(Bool?.self, forKey: .isSucceed) as? Bool
        message = try? values?.decodeIfPresent(String?.self, forKey: .message) as? String
        data = try? values?.decodeIfPresent(String?.self, forKey: .data) as? String
    }
    
    var status: KhaosStatus {
        if isSucceed ?? false {
            return .success
        }
        return .failed
    }
}
