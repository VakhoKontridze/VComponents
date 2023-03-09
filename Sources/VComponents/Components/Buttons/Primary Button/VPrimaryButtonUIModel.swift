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
        public var height: CGFloat = GlobalUIModel.Buttons.dimensionLarge
        
        /// Corner radius. Defaults to `16`.
        public var cornerRadius: CGFloat = GlobalUIModel.Buttons.cornerRadiusSmall
        
        /// Border width. Defaults to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Defaults to `15` horizontal and `3` vertical.
        public var labelMargins: LabelMargins = .init(
            horizontal: GlobalUIModel.Buttons.labelMargins.horizontal + 5,
            vertical: GlobalUIModel.Buttons.labelMargins.vertical
        )
        
        /// Icon size. Defaults to `20` by `20`.
        public var iconSize: CGSize = .init(dimension: GlobalUIModel.Buttons.iconDimensionMedium)
        
        /// Title minimum scale factor. Defaults to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Spacing between icon and title. Defaults to `8`.
        ///
        /// Applicable only if icon `init` with icon and title is used.
        public var iconTitleSpacing: CGFloat = GlobalUIModel.Buttons.iconTitleSpacing
        
        /// Model for customizing spinner layout.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Layout = .init()
        
        /// Spacing between label and spinner. Defaults to `20`.
        ///
        /// Only visible when state is set to `loading`.
        public var labelSpinnerSpacing: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes UI model with default values.
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
            enabled: ColorBook.controlLayerBlue,
            pressed: ColorBook.controlLayerBluePressed,
            loading: ColorBook.controlLayerBlueDisabled,
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
        
        /// Icon opacities. Defaults to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        /// Custom label opacities. Defaults to `1` enabled, `0.3` pressed, `0.3` loading, and `0.3` disabled.
        ///
        /// Applicable only when `init` with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: GlobalUIModel.Buttons.customLabelOpacityPressedLoadingDisabled,
            loading: GlobalUIModel.Buttons.customLabelOpacityPressedLoadingDisabled,
            disabled: GlobalUIModel.Buttons.customLabelOpacityPressedLoadingDisabled
        )
        
        /// Model for customizing spinner colors.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Colors = {
            var uiModel: VContinuousSpinnerUIModel.Colors = .init()
            
            uiModel.spinner = ColorBook.primaryWhite
            
            return uiModel
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
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
        public var title: Font = .system(size: GlobalUIModel.Buttons.fontSizeLarge, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Model for customizing spinner animations.
        public var spinnerSubUIModel: VContinuousSpinnerUIModel.Animations = .init()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
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
