//
//  GradientView.swift
//  
//
//  Created by Bagus Andinata on 18/08/20.
//

import UIKit

public class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

extension GradientView {
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    func startSkeletonAnimation(config: SkeletonConfig) {
        return gradientLayer.startSkeletonAnimation(config: config)
    }
    
    func stopSkeletonAnimation() {
        return gradientLayer.stopSkeletonAnimation()
    }
}
