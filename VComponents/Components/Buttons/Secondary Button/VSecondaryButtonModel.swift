//
//  VSecondaryButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Secondary Button Model
/// Model that describes UI.
public struct VSecondaryButtonModel {
    // MARK: Properties
    /// Reference to `VPrimaryButtonModel`.
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    
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
        
        /// Icon size. Defaults to `16` by `16`.
        public var iconSize: CGSize = .init(dimension: 16)
        
        /// Spacing between icon and title. Defaults to `8`.
        ///
        /// Applicable only if icon init with icon and title is used.
        public var iconTitleSpacing: CGFloat = 8
        
        /// Hit box. Defaults to `0` horizontally and `0` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 0,
            vertical: 0
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Content Margin
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias ContentMargin = EdgeInsets_HV
        
        // MARK: Hit Box
        /// Sub-model containing `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HV
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(primaryButtonReference.colors.background)
        
        /// Border colors.
        public var border: StateColors = .init(primaryButtonReference.colors.border)
        
        /// Title colors.
        public var title: StateColors = .init(primaryButtonReference.colors.title)
        
        /// Icon colors.
        ///
        /// Can be used for vector images.
        public var icon: StateColors = .init(primaryButtonReference.colors.icon)
        
        /// Icon opacities.
        ///
        /// Can be used for bitmap images. Defaults to `1`'s.
        public var iconOpacities: StateOpacities = .init(primaryButtonReference.colors.iconOpacities)
        
        /// Custom content opacities.
        ///
        /// Applicable only when init with content is used.
        public var customContentOpacities: StateOpacities = .init(primaryButtonReference.colors.customContentOpacities)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPD<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_EPD<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using init with title.
        public var title: Font = primaryButtonReference.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
