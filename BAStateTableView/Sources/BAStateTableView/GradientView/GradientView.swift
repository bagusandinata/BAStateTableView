//
//  GradientView.swift
//  
//
//  Created by Bagus Andinata on 17/08/20.
//

//  Partially copy/pasted from https://github.com/cruisediary/Pastel

import UIKit

open class GradientView: UIView {

    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    //MARK: - Custom Direction
    private var startPoint: CGPoint = GradientPoint.right.point
    private var endPoint: CGPoint = GradientPoint.left.point
    
    open var startGradientPoint = GradientPoint.right {
        didSet {
            startPoint = startGradientPoint.point
        }
    }
    
    open var endGradientPoint = GradientPoint.left {
        didSet {
            endPoint = endGradientPoint.point
        }
    }
    
    //MARK: - Custom Duration
    open var animationDuration: TimeInterval = 1.0
    
    fileprivate let gradient = CAGradientLayer()
    private var currentGradient: Int = 0
    private var colors: [UIColor] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
    
    //MARK: - SETUP ANIMATED GRADIENT
    public func startAnimation() {
        gradient.removeAllAnimations()
        setup()
        animateGradient()
    }
    
    fileprivate func setup() {
        gradient.frame = bounds
        gradient.colors = currentGradientSet()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func animateGradient() {
        currentGradient += 1
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.toValue = currentGradientSet()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        gradient.add(animation, forKey: Animation.key)
    }

    //MARK: - SETUP COLOR
    fileprivate func currentGradientSet() -> [CGColor] {
        guard colors.count > 0 else { return [] }
        return [colors[currentGradient % colors.count].cgColor,
                colors[(currentGradient + 1) % colors.count].cgColor]
    }
    
    public func setColors(_ colors: [UIColor]) {
        guard colors.count > 0 else { return }
        self.colors = colors
    }
    
    public func setGradientColors(_ gradient: GradientColor) {
        setColors(gradient.colors())
    }
    
    public func addcolor(_ color: UIColor) {
        self.colors.append(color)
    }
}

extension GradientView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = currentGradientSet()
            animateGradient()
        }
    }
}

