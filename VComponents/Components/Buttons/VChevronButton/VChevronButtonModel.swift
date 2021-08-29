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
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VChevronButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Button dimension. Default to `32`.
        public var dimension: CGFloat = 32
        
        /// Icon dimension. Default to `12`.
        public var iconDimension: CGFloat = 12
        
        /// Hit box. Defaults to `0` horizontally and `0` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 0,
            vertical: 0
        )
        
        var navigationBarBackButtonOffsetX: CGFloat?
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VChevronButtonModel.Layout {
    /// Sub-model containing `horizontal` and `vertical` hit boxes
    public typealias HitBox = LayoutGroup_HV
}

// MARK:- Colors
extension VChevronButtonModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Content colors and opacities
        public var content: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        /// Background colors
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "ChevronButton.Background.enabled"),
            pressed: .init(componentAsset: "ChevronButton.Background.pressed"),
            disabled: .init(componentAsset: "ChevronButton.Background.disabled")
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VChevronButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_EPD
    
    /// Sub-model containing colors and opacities for component states
    public typealias StateColorsAndOpacities = StateColorsAndOpacities_EPD_PD
}
