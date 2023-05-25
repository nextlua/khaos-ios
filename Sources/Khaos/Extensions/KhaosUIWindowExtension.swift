//
//  KhaosUIWindowExtension.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import UIKit

extension UIWindow {
    
    private static var _isShaked = [String:Bool]()
    
    var isShaked:Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIWindow._isShaked[tmpAddress] ?? false
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIWindow._isShaked[tmpAddress] = Khaos.shared.isShakeActive ? newValue : false
        }
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        self.isShaked = true
        
        if motion == .motionShake {
            Khaos.showKhaos()
        }
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        if self.isShaked == true {
            self.isShaked = false
            return
        }
        
        if motion == .motionShake {
            print("end shake")
        }
    }
}
