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
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VCloseButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Button dimension. Default to `32`.
        public var dimension: CGFloat = chevronButtonReference.layout.dimension
        
        /// Icon dimension. Default to `11`.
        public var iconDimension: CGFloat = 11
        
        /// Hit box. Defaults to `0` horizontally and `0` vertically.
        public var hitBox: HitBox = chevronButtonReference.layout.hitBox
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VCloseButtonModel.Layout {
    /// Sub-model containing horizontal and vertical hit boxes
    public typealias HitBox = LayoutGroupHV
}

// MARK:- Colors
extension VCloseButtonModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Content colors
        public var content: StateColorsAndOpacities = chevronButtonReference.colors.content
        
        /// Background colors
        public var background: StateColors = chevronButtonReference.colors.background
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VCloseButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsEPD
    
    /// Sub-model containing colors and opacities for component states
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
}

// MARK:- References
extension VCloseButtonModel {
    /// Reference to VChevronButtonModel
    public static let chevronButtonReference: VChevronButtonModel = .init()
}
