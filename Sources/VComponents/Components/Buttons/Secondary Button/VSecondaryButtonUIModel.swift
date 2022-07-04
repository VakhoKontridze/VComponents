//
//  VSecondaryButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Secondary Button UI Model
/// Model that describes UI.
public struct VSecondaryButtonUIModel {
    // MARK: Properties
    fileprivate static let primaryButtonReference: VPrimaryButtonUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button height. Defaults to `32`.
        public var height: CGFloat = 32
        
        var cornerRadius: CGFloat { height / 2 }
        
        /// Button border width. Defaults to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Defaults to `10` horizontal and `3` vertical.
        public var labelMargins: LabelMargins = .init(
            horizontal: 10,
            vertical: 3
        )
        
        /// Icon size. Defaults to `16` by `16`.
        public var iconSize: CGSize = .init(dimension: 16)
        
        /// Spacing between icon and title. Defaults to `8`.
        ///
        /// Applicable only if icon `init`with icon and title is used.
        public var iconTitleSpacing: CGFloat = 8
        
        /// Hit box. Defaults to `zero`.
        public var hitBox: HitBox = .zero
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Label Margins
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias LabelMargins = EdgeInsets_HorizontalVertical
        
        // MARK: Hit Box
        /// Sub-model containing `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HorizontalVertical
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
        /// Can be used for bitmap images. Defaults to `1`s.
        public var iconOpacities: StateOpacities = .init(primaryButtonReference.colors.iconOpacities)
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init`with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(primaryButtonReference.colors.customLabelOpacities)
        
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
        /// Only applicable when using `init`with title.
        public var title: Font = primaryButtonReference.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
