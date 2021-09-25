//
//  VPrimaryButtonModelBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Primary Button Model
/// Model that describes UI
public struct VPrimaryButtonModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Layout
extension VPrimaryButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Button height. Defaults to `50`.
        public var height: CGFloat = 50
        
        /// Button corner radius. Defaults to `20`.
        public var cornerRadius: CGFloat = 20
        
        /// Button border width. Defaults to `0`.
        public var borderWidth: CGFloat = 0
        
        var hasBorder: Bool { borderWidth > 0 }
        
        /// Content margin. Defaults to `15` horizontally and `3` vertically.
        public var contentMargin: ContentMargin = .init(
            horizontal: 15,
            vertical: 3
        )
        
        /// Spacing between content and spinner. Defaults to `20`.
        ///
        /// Only visible when state is set to `loading`.
        public var loaderSpacing: CGFloat = 20
        
        let loaderWidth: CGFloat = 10
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VPrimaryButtonModel.Layout {
    /// Sub-model containing `horizontal` and `vertical` margins
    public typealias ContentMargin = LayoutGroup_HV
}

// MARK: - Colors
extension VPrimaryButtonModel {
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
            enabled: ColorBook.primaryInverted,
            pressed: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted,
            loading: ColorBook.primaryInverted
        )
        
        /// Background colors
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "PrimaryButton.Background.enabled"),
            pressed: .init(componentAsset: "PrimaryButton.Background.pressed"),
            disabled: .init(componentAsset: "PrimaryButton.Background.disabled"),
            loading: .init(componentAsset: "PrimaryButton.Background.disabled")
        )
        
        /// Border colors
        public var border: StateColors = .init(
            enabled: ColorBook.clear,
            pressed: ColorBook.clear,
            disabled: ColorBook.clear,
            loading: ColorBook.clear
        )
        
        /// Loader colors
        public var loader: Color = ColorBook.primaryInverted
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VPrimaryButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_EPDL
    
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacities_PD
}

// MARK: - Fonts
extension VPrimaryButtonModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        ///
        /// Only applicable when using init with title
        public var title: Font = .system(size: 16, weight: .semibold)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - Sub-Models
extension VPrimaryButtonModel {
    var spinnerSubModel: VSpinnerModelContinous {
        var model: VSpinnerModelContinous = .init()
        model.colors.spinner = colors.loader
        return model
    }
}
