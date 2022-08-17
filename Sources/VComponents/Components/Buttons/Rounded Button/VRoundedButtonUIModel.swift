//
//  VRoundedButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rounded Button UI Model
/// Model that describes UI.
public struct VRoundedButtonUIModel {
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
        /// Button dimension. Defaults to `56`.
        public var dimension: CGFloat = 56
        
        /// Button corner radius. Defaults to `16`.
        public var cornerRadius: CGFloat = 16
        
        /// Button border width. Defaults to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Defaults to `3`s.
        public var labelMargins: LabelMargins = .init(3)
        
        /// Title minimum scale factor. Defaults to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = primaryButtonReference.layout.titleMinimumScaleFactor
        
        /// Icon size. Defaults to `20` by `20`.
        public var iconSize: CGSize = primaryButtonReference.layout.iconSize
        
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
        /// Applied to all images. But should be used for vector images.
        /// In order to use bitmap images, set this to `clear`.
        public var icon: StateColors = .init(primaryButtonReference.colors.icon)
        
        /// Icon opacities. Defaults to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
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
        public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15` with `semibold` weight.
        ///
        /// Only applicable when using `init`with title.
        public var title: Font = .system(size: 15, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
