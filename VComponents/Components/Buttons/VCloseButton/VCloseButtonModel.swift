//
//  VCloseButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Close Button Model
/// Model that describes UI
public struct VCloseButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VCloseButtonModel {
    public struct Layout {
        public static let chevronLayout: VChevronButtonModel.Layout = .init()
        
        public var dimension: CGFloat = chevronLayout.dimension
        
        public var iconDimension: CGFloat = 11
        
        public var hitBoxHor: CGFloat = chevronLayout.hitBoxHor
        public var hitBoxVer: CGFloat = chevronLayout.hitBoxVer
        
        public init() {}
    }
}

// MARK:- Colors
extension VCloseButtonModel {
    public struct Colors {
        public static let chevronColors: VChevronButtonModel.Colors = .init()
        
        public var content: StateColorsAndOpacity = chevronColors.content
        
        public var background: StateColors = chevronColors.background
        
        public init() {}
    }
}

extension VCloseButtonModel.Colors {
    public typealias StateColors = VChevronButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}
