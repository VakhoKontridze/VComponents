//
//  VSquareButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Square Button Model
/// Model that describes UI
public struct VSquareButtonModel {
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
extension VSquareButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Button dimension. Defaults to `56`.
        public var dimension: CGFloat = 56
        
        /// Button corner radius. Defaults to `16`.
        public var cornerRadius: CGFloat = 16
        
        /// Button border width. Defaults to `0`.
        public var borderWidth: CGFloat = 0
        
        var hasBorder: Bool { borderWidth > 0 }
        
        /// Content margin. Defaults to `3` horizontally and `3` vertically.
        public var contentMargins: ContentMargin = .init(
            horizontal: 3,
            vertical: 3
        )
        
        /// Hit box. Defaults to `0` horizontally and `0` vertically.
        public var hitBox: HitBox = .init(
            horizontal: 0,
            vertical: 0
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSquareButtonModel.Layout {
    /// Sub-model containing `horizontal` and `vertical` margins
    public typealias ContentMargin = LayoutGroup_HV
    
    /// Sub-model containing `horizontal` and `vertical` hit boxes
    public typealias HitBox = LayoutGroup_HV
}

// MARK: - Colors
extension VSquareButtonModel {
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
            enabled: primaryButtonReference.colors.textContent.enabled,
            pressed: primaryButtonReference.colors.textContent.pressed,
            disabled: primaryButtonReference.colors.textContent.disabled
        )
        
        /// Background colors
        public var background: StateColors = .init(
            enabled: primaryButtonReference.colors.background.enabled,
            pressed: primaryButtonReference.colors.background.pressed,
            disabled: primaryButtonReference.colors.background.disabled
        )
        
        /// Border colors
        public var border: StateColors = .init(
            enabled: primaryButtonReference.colors.border.enabled,
            pressed: primaryButtonReference.colors.border.pressed,
            disabled: primaryButtonReference.colors.border.disabled
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSquareButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_EPD
    
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacities_PD
}

// MARK: - Fonts
extension VSquareButtonModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `14` with `semibold` weight.
        ///
        /// Only applicable when using init with title
        public var title: Font = .system(size: 14, weight: .semibold)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - References
extension VSquareButtonModel {
    /// Reference to `VPrimaryButtonModel`
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
}
