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
