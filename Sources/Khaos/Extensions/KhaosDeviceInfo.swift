//
//  KhaosDeviceInfo.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation
import DeviceKit
import UIKit

class KhaosDeviceInfo {
    
    let device = Device.current
    
    public static let shared = KhaosDeviceInfo()
    
    public var systemName: String {
        return device.systemName ?? ""
    }
    
    public var deviceModel: String {
        return device.safeDescription
    }
    
    public var iOSVersion: String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    public var appName: String {
        return Bundle.main.appName
    }
    
    public var appNameID: String {
        return Bundle.main.appNameIdentifier
    }
    
    public var appID: String {
        return Bundle.main.bundleId
    }

    public var appVersion: String {
        return Bundle.main.versionNumber
    }
    
    public var appVersionLong: String {
        return Bundle.main.fullVersionString
    }
    
    public var buildVersion: String {
        return Bundle.main.buildNumber
    }
    
    public var enviroment: String {
        return Bundle.main.enviroment
    }
    
    public var lang: String {
        return Locale.current.languageCode ?? ""
    }

    public var deviceUUID: String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        return uuid ?? "null_device_id"
    }
    
    public var devicetype: String {
        if device.isSimulator {
            return "Simulator"
        } else {
            return "Device"
        }
    }
    
    public var appLanguage: String {
        return Locale.preferredLanguages[0]
    }
}

