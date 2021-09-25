//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Plain Model Button
/// Model that describes UI
public struct VPlainButtonModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Layout
extension VPlainButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Hit box. Defaults to `5` horizontally and `5` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 5,
            vertical: 5
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VPlainButtonModel.Layout {
    /// Sub-model containing `horizontal` and `vertical` hit boxes
    public typealias HitBox = LayoutGroup_HV
}

// MARK: - Colors
extension VPlainButtonModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Content opacities
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        /// Text content colors
        ///
        /// Only applicable when using init with title
        public var textContent: StateColors = .init(
            enabled: ColorBook.accent,
            pressed: ColorBook.accent,
            disabled: ColorBook.accent
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VPlainButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_EPD
    
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacities_PD
}

// MARK: - Fonts
extension VPlainButtonModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `14` with `semibold` weight.
        ///
        /// Only applicable when using init with title
        public var title: Font = squareButtonReference.fonts.title
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - References
extension VPlainButtonModel {
    /// Reference to `VSquareButtonModel`
    public static let squareButtonReference: VSquareButtonModel = .init()
}
