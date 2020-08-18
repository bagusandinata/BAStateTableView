//
//  GradientPoint.swift
//  
//
//  Created by Bagus Andinata on 17/08/20.
//

import UIKit

public enum GradientPoint: Int {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var point: CGPoint {
        switch self {
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .left: return CGPoint(x: 0.0, y: 0.5)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

