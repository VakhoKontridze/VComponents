//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Plain Model Button
/// Model that describes UI.
public struct VPlainButtonModel {
    // MARK: Properties
    /// Reference to `VSquareButtonModel`.
    public static let squareButtonReference: VSquareButtonModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Hit box. Defaults to `5` horizontally and `5` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 5,
            vertical: 5
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Hit Box
        /// Sub-model containing `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HV
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Content opacities.
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        /// Text content colors.
        ///
        /// Only applicable when using init with title.
        public var textContent: StateColors = .init(
            enabled: ColorBook.accent,
            pressed: ColorBook.accent,
            disabled: ColorBook.accent
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_EPD
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = StateOpacities_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `14` with `semibold` weight.
        ///
        /// Only applicable when using init with title.
        public var title: Font = squareButtonReference.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
