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
    public static let chevronButtonModel: VChevronButtonModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VCloseButtonModel {
    public struct Layout {
        public var dimension: CGFloat = VCloseButtonModel.chevronButtonModel.layout.dimension
        
        public var iconDimension: CGFloat = 11
        
        public var hitBoxHor: CGFloat = VCloseButtonModel.chevronButtonModel.layout.hitBoxHor
        public var hitBoxVer: CGFloat = VCloseButtonModel.chevronButtonModel.layout.hitBoxVer
        
        public init() {}
    }
}

// MARK:- Colors
extension VCloseButtonModel {
    public struct Colors {
        public var content: StateColorsAndOpacity = VCloseButtonModel.chevronButtonModel.colors.content
        
        public var background: StateColors = VCloseButtonModel.chevronButtonModel.colors.background
        
        public init() {}
    }
}

extension VCloseButtonModel.Colors {
    public typealias StateColors = VChevronButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}
