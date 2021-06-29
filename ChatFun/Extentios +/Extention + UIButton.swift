//
//  Extention + UIButton.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 28.06.2021.
//

import UIKit

extension UIButton {
    func animation() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        
        animation.duration = 1
        animation.fromValue = 0.9
        animation.toValue = 1
        animation.repeatCount = 1
        animation.damping = 1
        
        layer.add(animation, forKey: nil)
    }
}


