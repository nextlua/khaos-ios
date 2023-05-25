//
//  KhaosBundleExtension.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation

extension Bundle {
    
    public static var projectBundle: Bundle = .main
    
    var appName: String {
        Bundle.projectBundle.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    
    var bundleId: String {
        Bundle.projectBundle.bundleIdentifier ?? ""
    }
    
    var versionNumber: String {
        Bundle.projectBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var buildNumber: String {
        Bundle.projectBundle.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    var fullVersionString: String  {
        versionNumber + "(" + buildNumber + ")"
    }
    
    var appNameIdentifier: String {
        appName + "(" + bundleId + ")"
    }
    
    var enviroment: String {
        Bundle.projectBundle.infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
