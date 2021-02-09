//
//  VSecondaryButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button Model
/// Model that describes UI
public struct VSecondaryButtonModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VSecondaryButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Button height. Defaults to `32`.
        public var height: CGFloat = 32
        
        var cornerRadius: CGFloat { height / 2 }
        
        /// Button border width. Defaults to `0`.
        public var borderWidth: CGFloat = 0
        
        var hasBorder: Bool { borderWidth > 0 }
        
        /// Content margin. Defaults to `10` horizontally and `3` vertically.
        public var contentMargins: ContentMargin = .init(
            horizontal: 10,
            vertical: 3
        )
        
        /// Hit box. Defaults to `0` horizontally and `0` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 0,
            vertical: 0
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSecondaryButtonModel.Layout {
    /// Sub-model containing `horizontal` and `vertical` margins
    public typealias ContentMargin = LayoutGroupHV
    
    /// Sub-model containing `horizontal` and `vertical` hit boxes
    public typealias HitBox = LayoutGroupHV
}

// MARK:- Colors
extension VSecondaryButtonModel {
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
            enabled: primaryButtonReference.colors.textContent.enabled,
            pressed: primaryButtonReference.colors.textContent.pressed,
            disabled: primaryButtonReference.colors.textContent.disabled
        )
        
        /// Background colors
        public var background: StateColors = .init(
            enabled: primaryButtonReference.colors.background.enabled,
            pressed: primaryButtonReference.colors.background.pressed,
            disabled: primaryButtonReference.colors.background.disabled
        )
        
        /// Border colors
        public var border: StateColors = .init(
            enabled: primaryButtonReference.colors.border.enabled,
            pressed: primaryButtonReference.colors.border.pressed,
            disabled: primaryButtonReference.colors.border.disabled
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSecondaryButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsEPD
    
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VSecondaryButtonModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using init with title
        public var title: Font = primaryButtonReference.fonts.title
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VSecondaryButtonModel {
    /// Reference to `VPrimaryButtonModel`
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
}
