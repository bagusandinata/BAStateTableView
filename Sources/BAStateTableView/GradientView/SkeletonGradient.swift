//
//  SkeletonGradient.swift
//  
//
//  Created by Bagus Andinata on 18/08/20.
//

import UIKit

public struct SkeletonGradient {
    private let gradientColors: [CGColor]
    
    public var colors: [CGColor] {
        return gradientColors
    }
    
    public init(baseColor: UIColor, secondaryColor: UIColor? = nil) {
        if let secondary = secondaryColor {
            self.gradientColors = [baseColor.cgColor, secondary.cgColor, baseColor.cgColor]
        } else {
            self.gradientColors = baseColor.makeGradient()
        }
    }
}
