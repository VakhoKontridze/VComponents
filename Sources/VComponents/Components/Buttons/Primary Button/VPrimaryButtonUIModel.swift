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
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button height. Defaults to `56`.
        public var height: CGFloat = 56
        
        /// Corner radius. Defaults to `16`.
        public var cornerRadius: CGFloat = 16
        
        /// Border width. Defaults to `0`.
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
        
        /// Title minimum scale factor. Defaults to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = 0.75
        
        /// Spacing between icon and title. Defaults to `10`.
        ///
        /// Applicable only if icon `init` with icon and title is used.
        public var iconTitleSpacing: CGFloat = 10
        
        /// Model for customizing spinner layout.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Layout = .init()
        
        /// Spacing between label and spinner. Defaults to `20`.
        ///
        /// Only visible when state is set to `loading`.
        public var labelSpinnerSpacing: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: Label Margins
        /// Model that contains `horizontal` and `vertical` margins.
        public typealias LabelMargins = EdgeInsets_HorizontalVertical
    }

    // MARK: Colors
    /// Model that contains color properties.
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
        /// Applied to all images. But should be used for vector images.
        /// In order to use bitmap images, set this to `clear`.
        public var icon: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon opacities. Defaults to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init` with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: 0.3,
            loading: 0.3,
            disabled: 0.3
        )
        
        /// Model for customizing spinner colors.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Colors = {
            var uiModel: VContinuousSpinnerUIModel.Colors = .init()
            uiModel.spinner = ColorBook.primaryWhite
            return uiModel
        }()
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledPressedLoadingDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledPressedLoadingDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using `init` with title.
        public var title: Font = .system(size: 16, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Model for customizing spinner animations.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Animations = .init()
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
    
    // MARK: Sub UI Models
    var spinnerSubUIModel: VContinuousSpinnerUIModel {
        var uiModel: VContinuousSpinnerUIModel = .init()
        
        uiModel.layout = layout.spinnerSubUIModel
        
        uiModel.colors = colors.spinnerSubUIModel
        
        uiModel.animations = animations.spinnerSubUIModel
        
        return uiModel
    }
}
