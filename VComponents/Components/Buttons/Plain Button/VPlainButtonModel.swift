//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Plain Button Model
/// Model that describes UI.
public struct VPlainButtonModel {
    // MARK: Properties
    /// Reference to `VPrimaryButtonModel`.
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    
    /// Reference to `VSecondaryButtonModel`.
    public static let secondaryButtonReference: VSecondaryButtonModel = .init()
    
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
        /// Icon size. Defaults to `20` by `20`.
        public var iconSize: CGSize = squareButtonReference.layout.iconSize
        
        /// Spacing between icon and title. Defaults to `8`.
        ///
        /// Applicable only if icon init with icon and title is used.
        public var iconTitleSpacing: CGFloat = secondaryButtonReference.layout.iconTitleSpacing
        
        
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
        /// Title colors.
        public var title: StateColors = .init(
            enabled: .init(componentAsset: "PlainButton.Text.enabled"),
            pressed: primaryButtonReference.colors.background.pressed,
            disabled: primaryButtonReference.colors.background.disabled
        )
        
        /// Icon opacities.
        ///
        /// Can be used for vector images.
        public var icon: StateColors = .init(
            enabled: .init(componentAsset: "PlainButton.Text.enabled"),
            pressed: primaryButtonReference.colors.background.pressed,
            disabled: primaryButtonReference.colors.background.disabled
        )
        
        /// Icon opacities.
        ///
        /// Can be used for bitmap images. Defaults to `1`'s.
        public var iconOpacities: StateOpacities = .init(primaryButtonReference.colors.iconOpacities)
        
        /// Custom label opacities.
        ///
        /// Applicable only when init with label is used.
        /// When using a custom label, it's subviews cannot be configured with indivudual colors,
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
        /// Title font. Defaults to system font of size `15` with `medium` weight.
        ///
        /// Only applicable when using init with title.
        public var title: Font = .system(size: 15, weight: .medium)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
