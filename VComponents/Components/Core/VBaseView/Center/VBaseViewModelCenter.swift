//
//  VBaseViewModelCenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base View Model Center
/// Model that describes UI
public struct VBaseViewModelCenter {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var titleColor: Color = ColorBook.primary
    public var font: Font = .system(size: 17, weight: .semibold, design: .default)
    
    var backButtonModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.backButtonDimension
        model.layout.iconDimension = layout.backButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = colors.closeButtonBackground
        model.colors.content = colors.closeButtonIcon
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VBaseViewModelCenter {
    public struct Layout {
        public static let chevronButtonLayout: VChevronButtonModel.Layout = .init()
        
        public var margin: CGFloat = 15
        public var spacing: CGFloat = 10
        var width: CGFloat { UIScreen.main.bounds.width - 2 * margin }
        
        public var backButtonDimension: CGFloat = chevronButtonLayout.dimension
        public var backButtonIconDimension: CGFloat = chevronButtonLayout.iconDimension

        public init() {}
    }
}

// MARK:- Colors
extension VBaseViewModelCenter {
    public struct Colors {
        public static let chevronButtonColors: VChevronButtonModel.Colors = .init()
        
        public var closeButtonBackground: StateColors = chevronButtonColors.background
        
        public var closeButtonIcon: StateColorsAndOpacity = chevronButtonColors.content
        
        public init() {}
    }
}

extension VBaseViewModelCenter.Colors {
    public typealias StateColors = VChevronButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}
