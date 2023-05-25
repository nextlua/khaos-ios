//
//  KhaosUIViewExtension.swift
//  
//
//  Created by Furkan Yıldırım on 10.04.2023.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(_ radius: CGFloat? = nil) {
        layer.masksToBounds = true
        if radius == nil {
            layer.cornerRadius = frame.height / 2
        } else {
            layer.cornerRadius = radius ?? 0
        }
    }
}
