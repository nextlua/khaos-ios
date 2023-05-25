//
//  KhaosUIViewControllerExtension.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import UIKit

extension UIViewController {
    @objc func _track_viewWillAppear(_ animated: Bool) {
        print("\n\n\n\n\nTracked: \(self.description)\n\n\n\n\n")
        NXKhaos.shared.viewControllers.append(self.description)
        _track_viewWillAppear(animated)
    }
    
    static func swizzle() {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzleSelector = #selector(UIViewController._track_viewWillAppear(_:))
        
        if let originalMethod = class_getInstanceMethod(self, originalSelector),
           let swizzleMethod = class_getInstanceMethod(self, swizzleSelector) {
            method_exchangeImplementations(originalMethod, swizzleMethod)
        }
    }
}
