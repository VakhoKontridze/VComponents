//
//  VChevronButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Model
/// Model that describes UI
public struct VChevronButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VChevronButtonModel {
    public struct Layout {
        public var dimension: CGFloat = 32
        
        public var iconDimension: CGFloat = 12
        
        public var hitBoxHor: CGFloat = 0
        public var hitBoxVer: CGFloat = 0
        
        public init() {}
    }
}

// MARK:- Colors
extension VChevronButtonModel {
    public struct Colors {
        public var content: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "ChevronButton.Background.enabled"),
            pressed: .init(componentAsset: "ChevronButton.Background.pressed"),
            disabled: .init(componentAsset: "ChevronButton.Background.disabled")
        )
        
        public init() {}
    }
}

extension VChevronButtonModel.Colors {
    public typealias StateColors = StateColorsEPD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}
