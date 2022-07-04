//
//  VPrimaryButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Primary Button UI Model
/// Model that describes UI.
public struct VPrimaryButtonUIModel {
    // MARK: Properties
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button height. Defaults to `56`.
        public var height: CGFloat = 56
        
        /// Button corner radius. Defaults to `20`.
        public var cornerRadius: CGFloat = 20
        
        /// Button border width. Defaults to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Defaults to `15` horizontal and `3` vertical.
        public var labelMargins: LabelMargins = .init(
            horizontal: 15,
            vertical: 3
        )
        
        /// Icon size. Defaults to `20` by `20`.
        public var iconSize: CGSize = .init(dimension: 20)
        
        /// Spacing between icon and title. Defaults to `10`.
        ///
        /// Applicable only if icon `init`with icon and title is used.
        public var iconTitleSpacing: CGFloat = 10
        
        /// Loader dimension. Defaults to `15`.
        public var loaderDimension: CGFloat = 15
        
        /// Spacing between label and spinner. Defaults to `20`.
        ///
        /// Only visible when state is set to `loading`.
        public var labelLoaderSpacing: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Label Margin
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias LabelMargins = EdgeInsets_HorizontalVertical
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "PrimaryButton.Background.enabled"),
            pressed: .init(componentAsset: "PrimaryButton.Background.pressed"),
            loading: .init(componentAsset: "PrimaryButton.Background.disabled"),
            disabled: .init(componentAsset: "PrimaryButton.Background.disabled")
        )
        
        /// Border colors.
        public var border: StateColors = .clearColors
        
        /// Title colors.
        public var title: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon colors.
        ///
        /// Can be used for vector images.
        public var icon: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon opacities.
        ///
        /// Can be used for bitmap images. Defaults to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init`with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: 0.75,
            loading: 0.75,
            disabled: 0.75
        )
        
        /// Loader color.
        public var loader: Color = ColorBook.primaryWhite
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EnabledPressedLoadingDisabled<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledPressedLoadingDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using `init`with title.
        public var title: Font = .system(size: 16, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
    var spinnerSubUIModel: VSpinnerContinuousUIModel {
        var uiModel: VSpinnerContinuousUIModel = .init()
        uiModel.layout.dimension = layout.loaderDimension
        uiModel.colors.spinner = colors.loader
        return uiModel
    }
}
