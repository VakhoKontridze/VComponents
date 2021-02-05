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
        public var dimension: CGFloat = chevronButtonReference.layout.dimension
        
        public var iconDimension: CGFloat = 11
        
        public var hitBoxHor: CGFloat = chevronButtonReference.layout.hitBoxHor
        public var hitBoxVer: CGFloat = chevronButtonReference.layout.hitBoxVer
        
        public init() {}
    }
}

// MARK:- Colors
extension VCloseButtonModel {
    public struct Colors {
        public var content: StateColorsAndOpacities = chevronButtonReference.colors.content
        
        public var background: StateColors = chevronButtonReference.colors.background
        
        public init() {}
    }
}

extension VCloseButtonModel.Colors {
    public typealias StateColors = StateColorsEPD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- References
extension VCloseButtonModel {
    public static let chevronButtonReference: VChevronButtonModel = .init()
}
