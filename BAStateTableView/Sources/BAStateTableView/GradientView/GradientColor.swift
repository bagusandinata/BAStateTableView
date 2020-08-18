//
//  GradientColor.swift
//  
//
//  Created by Bagus Andinata on 17/08/20.
//

import UIKit

public enum GradientColor: Int {
    case gray
    case blueGray
    case blue
    case lightBlue
    
    public func colors() -> [UIColor] {
        switch self {
        case .gray:
            return [#colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)]
        case .blueGray:
            return [#colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4705882353, green: 0.5647058824, blue: 0.6117647059, alpha: 1), #colorLiteral(red: 0.5647058824, green: 0.6431372549, blue: 0.6823529412, alpha: 1)]
        case .blue:
            return [#colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.2588235294, green: 0.6470588235, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.3921568627, green: 0.7098039216, blue: 0.9647058824, alpha: 1)]
        case .lightBlue:
            return [#colorLiteral(red: 0.01176470588, green: 0.662745098, blue: 0.9568627451, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.7137254902, blue: 0.9647058824, alpha: 1), #colorLiteral(red: 0.3098039216, green: 0.7647058824, blue: 0.968627451, alpha: 1)]
        }
    }
}

