//
//  File.swift
//  
//
//  Created by Bagus Andinata on 18/08/20.
//

import UIKit

public struct SkeletonConfig {
    let colors: [CGColor]
    
    let gradientDirection: GradientDirection
    
    let animationDuration: Double
    
    var transition: SkeletonTransitionStyle
    
    init(
        colors: [CGColor],
        gradientDirection: GradientDirection,
        animationDuration: Double,
        transition: SkeletonTransitionStyle = .crossDissolve(0.25)
    ) {
        self.colors = colors
        self.gradientDirection = gradientDirection
        self.animationDuration = animationDuration
        self.transition = transition
    }
}

