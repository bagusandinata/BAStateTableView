//
//  RoundButton.swift
//  BAStateTableViewExample
//
//  Created by Bagus Andinata on 18/08/20.
//  Copyright © 2020 Bagus Andinata. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}

