//
//  VPrimaryButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Primary Button Model
/// Model that describes UI.
public struct VPrimaryButtonModel {
    // MARK: Properties
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Initializes model with default values.
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
        public var borderWidth: CGFloat = 0
        
        var hasBorder: Bool { borderWidth > 0 }
        
        /// Content margin. Defaults to `15` horizontally and `3` vertically.
        public var contentMargins: ContentMargin = .init(
            horizontal: 15,
            vertical: 3
        )
        
        /// Icon size. Defaults to `20` by `20`.
        public var iconSize: CGSize = .init(dimension: 20)
        
        /// Spacing between icon and title. Defaults to `10`.
        ///
        /// Applicable only if icon init with icon and title is used.
        public var iconTitleSpacing: CGFloat = 10
        
        /// Spacing between content and spinner. Defaults to `20`.
        ///
        /// Only visible when state is set to `loading`.
        public var loaderSpacing: CGFloat = 20
        
        let loaderWidth: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Content Margin
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias ContentMargin = EdgeInsets_HV
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "PrimaryButton.Background.enabled"),
            pressed: .init(componentAsset: "PrimaryButton.Background.pressed"),
            disabled: .init(componentAsset: "PrimaryButton.Background.loading"),
            loading: .init(componentAsset: "PrimaryButton.Background.disabled")
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            enabled: .clear,
            pressed: .clear,
            disabled: .clear,
            loading: .clear
        )
        
        /// Title colors.
        public var title: StateColors = .init(
            enabled: ColorBook.primaryWhite,
            pressed: ColorBook.primaryWhite,
            disabled: ColorBook.primaryWhite,
            loading: ColorBook.primaryWhite
        )
        
        /// Icon colors.
        ///
        /// Can be used for vector images.
        public var icon: StateColors = .init(
            enabled: ColorBook.primaryWhite,
            pressed: ColorBook.primaryWhite,
            disabled: ColorBook.primaryWhite,
            loading: ColorBook.primaryWhite
        )
        
        /// Icon opacities.
        ///
        /// Can be used for bitmap images. Defaults to `1`'s.
        public var iconOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: 1,
            disabled: 1,
            loading: 1
        )
        
        /// Custom content opacities.
        ///
        /// Applicable only when init with content is used.
        public var customContentOpacities: StateOpacities = .init(
            enabled: 1,
            pressed: 0.75,
            disabled: 0.75,
            loading: 0.75
        )
        
        /// Loader color.
        public var loader: Color = ColorBook.primaryWhite
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPDL<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_EPDL<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using init with title.
        public var title: Font = .system(size: 16, weight: .semibold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
    var spinnerSubModel: VSpinnerModelContinous {
        var model: VSpinnerModelContinous = .init()
        model.colors.spinner = colors.loader
        return model
    }
}
