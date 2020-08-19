//
//  CAGradientLayer.swift
//  
//
//  Created by Bagus Andinata on 18/08/20.
//

import UIKit

public extension CAGradientLayer {

    fileprivate static let KSlideAnimationKey = "SlideAnimation"

    func startSkeletonAnimation(config: SkeletonConfig) {
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(startPoint))
        startPointAnim.fromValue = config.gradientDirection.startPoint.from
        startPointAnim.toValue = config.gradientDirection.startPoint.to
        
        let endPointAnim = CABasicAnimation(keyPath: #keyPath(endPoint))
        endPointAnim.fromValue = config.gradientDirection.endPoint.from
        endPointAnim.toValue = config.gradientDirection.endPoint.to
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim]
        animGroup.duration = config.animationDuration
        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animGroup.repeatCount = .infinity
        animGroup.isRemovedOnCompletion = false
        
        add(animGroup, forKey: CAGradientLayer.KSlideAnimationKey)
    }

    func stopSkeletonAnimation() {
        removeAnimation(forKey: CAGradientLayer.KSlideAnimationKey)
    }
}
