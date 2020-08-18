//
//  File.swift
//  
//
//  Created by Bagus Andinata on 17/08/20.
//

import UIKit

enum ViewAssociatedKeys {
    static var skeletonable = "skeletonable"
    static var skeletonStatus = "skeletonStatus"
    static var skeletonCornerRadius = "skeletonCornerRadius"
    static var defaultCornerRadius = "defaultCornerRadius"
}

public extension UIView {
    static func nib<T: UIView>(withType type: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil)?.first as! T
    }
    
    enum SkeletonStatus {
        case on
        case off
    }
    
    var skeletonStatus: SkeletonStatus! {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonStatus) as? SkeletonStatus ?? .off }
        set { ao_set(newValue ?? .off, pkey: &ViewAssociatedKeys.skeletonStatus) }
    }
    
    fileprivate class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
        return parentView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
    
    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
}


extension UIColor {
    public var complementaryColor: UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return UIColor { traitCollection in
                return self.isLight() ? self.darker : self.lighter
            }
        } else {
            return isLight() ? darker : lighter
        }
    }
    
    public var lighter: UIColor {
        return adjust(by: 1.35)
    }
    
    public var darker: UIColor {
        return adjust(by: 0.94)
    }
    
    func isLight() -> Bool {
        guard let components = cgColor.components,
            components.count >= 3 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return !(brightness < 0.5)
    }
    
    func adjust(by percent: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
    }
    
    func makeGradient() -> [CGColor] {
        return [self.cgColor, self.complementaryColor.cgColor, self.cgColor]
    }
}

