//
//  Extention + UIColor.swift
//  ChatInstance
//
//  Created by Fuhrer_SS on 23.06.2021.
//

import UIKit

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        // enter hex number without #
        let chars = Array(hexaString)
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}

