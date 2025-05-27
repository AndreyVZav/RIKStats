//
//  Fonts.swift
//  RIKStats
//
//  Created by Андрей Завадский on 27.05.2025.
//

import SwiftUI

extension Font {
    enum Gilroy {
        case medium
        case bold
        case semibold
        
        var name: String {
            switch self {
            case .medium: return "Gilroy-Medium"
            case .bold: return "Gilroy-Bold"
            case .semibold: return "Gilroy-SemiBold"
            }
        }
    }
    
    static func gilroy(_ type: Gilroy, size: CGFloat) -> Font {
        return .custom(type.name, size: size)
    }
}
