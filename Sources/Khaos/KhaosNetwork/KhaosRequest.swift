//
//  KhaosRequest.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation

struct KhaosModel: Codable {
    // Device Info
    // ===============================================================
    var systemName: String?         // iOS, iPadOS, MacOS
    var systemVersion: String?      // 16.1.5
    var deviceName: String?         // iPhone 13 Pro
    var deviceModel: String?        // Device / Simulator
    var deviceId: String?           // AB123-ED412-ASD21-ASD123
    var deviceLanguage: String?     // tr-TR

    // App Info
    // ===============================================================
    var buildVersion: String?       // 12
    var appVersion: String?         // 3.0.2
    var appVersionBuild: String?    // 3.0.2(12)
    var appName: String?            // NextText
    var appId: String?              // com.nextlua.khaos
    var appNameId: String?          // Khaos (com.nextlua.khaos)
    var enviorment: String?         // Dev, Stage, Uat, Prod
    var appLanguage: String?        // en-TR
    
    // Network Info
    // ===============================================================
    var connectionType: String?     // Wi-Fi, Edge, 3G, 4G, 5G, Offline - Pref Enums
    var ip: String?                 // 192.168.02.255
    
    // KhaosAPI Info
    // ===============================================================
    var baseApiUrl: String?         // https://nextlua.com/nextest/api/v2 // ?
    var lastApiRequests: [KhaosRequestModel]?

    // User Activity Info
    // ===============================================================
    var currentPage: String?        // HomeViewController
    var lastVisitedPages: [String]? // [HomeViewController, PaymentViewController, PurchaseVC]
    var screenShotURL: String?      // https://s3.amazon.com/nextest/file
    
    // Bug Info
    // ===============================================================
    var bugTitle: String?           // Foto cekilemiyor
    var bugDescription: String?     // Ihale ekraninda foto cekemedik.
    
    /*
     
    // IF Firebase Remote Config
    // ===============================================================
    let remoteConfigUrl: String?    // https://nextlua.com/nextest/api/v2
    let lastRemoteConfigs: String?  // {JSON Object}

    */
    
    
    /*
     
    // Future Common Features
    // ===============================================================
    let pushToken: String?         // Firebase FCM Token
    let idfa: String?              // Adverstivemnet ID

     */
}

struct KhaosRequestModel: Codable {
    var urlString: String?
    var status: Int?
    var type: String?
    var requestHeader: [String: String]?
    var responseHeader: [String: String]?
    var requestBody: String?
    var responseBody: String?
}

extension Array<KhaosRequestModel> {
    func toDictionary() -> [[String : Any]] {
        var params: [[String : Any]] = []
        
        for request in self {
            let requestDict: [String : Any] = [
                "urlString": request.urlString ?? "",
                "status": request.status ?? 0,
                "type": request.type ?? "",
                "requestHeader": request.requestHeader ?? ["" : ""],
                "responseHeader": request.responseHeader ?? ["" : ""],
                "requestBody": request.requestBody ?? "",
                "responseBody": request.responseBody ?? ""
                ]
            params.append(requestDict)
        }
        
        return params
    }
}
