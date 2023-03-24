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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VRoundedButtonUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button dimension. Set to `56` for `iOS`, and `28` for `macOS`.
        public var dimension: CGFloat = {
#if os(iOS)
            return GlobalUIModel.Buttons.dimensionLarge
#elseif canImport(AppKit)
            return 28
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Corner radius. Set to `16` for `iOS`, and `6` for `macOS`.
        public var cornerRadius: CGFloat = {
#if os(iOS)
            return GlobalUIModel.Buttons.cornerRadiusSmall
#elseif canImport(AppKit)
            return 6
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Border width. Set to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Set to `3`s.
        public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMarginsRounded
        
        /// Title minimum scale factor. Set to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Icon size. Set to `20x20` for `iOS`, and `14x14` for `macOS`.
        public var iconSize: CGSize = {
#if os(iOS)
            return .init(dimension: GlobalUIModel.Buttons.iconDimensionMedium)
#elseif canImport(AppKit)
            return .init(dimension: 14)
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Hit box. Set to `zero`.
        public var hitBox: HitBox = .zero
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Label Margins
        /// Model that contains `horizontal` and `vertical` margins.
        public typealias LabelMargins = EdgeInsets_HorizontalVertical
        
        // MARK: Hit Box
        /// Model that contains `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HorizontalVertical
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            pressed: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.controlLayerBlueDisabled
        )
        
        /// Border colors.
        public var border: StateColors = .clearColors
        
        /// Title colors.
        public var title: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon colors.
        ///
        /// Applied to all images. But should be used for vector images.
        /// In order to use bitmap images, set this to `clear`.
        public var icon: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon opacities. Set to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        /// Custom label opacities. Set to `1` enabled, `0.3` pressed, and `0.3` disabled.
        ///
        /// Applicable only when `init` with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: GlobalUIModel.Buttons.customLabelOpacityPressedLoadingDisabled,
            disabled: GlobalUIModel.Buttons.customLabelOpacityPressedLoadingDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Set to `system` `semibold`-`15`.
        ///
        /// Only applicable when using `init` with title.
        public var title: Font = .system(size: 15, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
