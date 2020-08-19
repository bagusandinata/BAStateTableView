//
//  SkeletonView+IBInspectable.swift
//  
//
//  Created by Bagus Andinata on 17/08/20.
//

import UIKit

public extension UIView {
    @IBInspectable
    var isSkeletonable: Bool {
        get { return skeletonable }
        set { skeletonable = newValue }
    }

    @IBInspectable
    var skeletonCornerRadius: Float {
        get { return skeletonableCornerRadius }
        set { skeletonableCornerRadius = newValue }
    }
    
    var isSkeletonActive: Bool {
        return skeletonStatus == .on
    }
    
    var defaultCornerRadius: CGFloat {
        get { return ao_get(pkey: &ViewAssociatedKeys.defaultCornerRadius) as? CGFloat ?? self.layer.cornerRadius}
        set { ao_set(self.layer.cornerRadius, pkey: &ViewAssociatedKeys.defaultCornerRadius) }
    }

    private var skeletonable: Bool! {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonable) as? Bool ?? false }
        set { ao_set(newValue ?? false, pkey: &ViewAssociatedKeys.skeletonable) }
    }

    private var skeletonableCornerRadius: Float! {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonCornerRadius) as? Float ?? 0.0 }
        set { ao_set(newValue ?? 0.0, pkey: &ViewAssociatedKeys.skeletonCornerRadius) }
    }
}

