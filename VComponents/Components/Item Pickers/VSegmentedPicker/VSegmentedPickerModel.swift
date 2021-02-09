//
//  VSegmentedPickerModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker Model
/// Model that describes UI
public struct VSegmentedPickerModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VSegmentedPickerModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Picker height. Defaults to `31`, similarly to native picker.
        public var height: CGFloat = 31
        
        /// Picker corner radius. Defaults to `8`, similarly to native picker.
        public var cornerRadius: CGFloat = 7
        
        /// Selection indicator corner radius.  Defaults to `6`, similarly to native picker.
        public var indicatorCornerRadius: CGFloat = 6
        
        /// Selection inticator margin. Defaults to `2`.
        public var indicatorMargin: CGFloat = 2
        
        /// Scale by which selection indicator changes on press. Defaults to `0.95`.
        public var indicatorPressedScale: CGFloat = 0.95
        
        let indicatorShadowRadius: CGFloat = 1
        
        let indicatorShadowOffsetY: CGFloat = 1
        
        /// Row content margin. Defaults to `2`.
        public var rowContentMargin: CGFloat = 2
        
        var actualRowContentMargin: CGFloat { indicatorMargin + rowContentMargin }
        
        /// Spacing between header and picker, and picker and footer. Defaults to `3`.
        public var headerFooterSpacing: CGFloat = 3
        
        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerFooterMarginHorizontal: CGFloat = 10
        
        /// Row divider size. Defaults to width `1` and height `19`, similarly to native picker.
        public var dividerSize: CGSize = .init(width: 1, height: 19)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VSegmentedPickerModel {
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
            enabled: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        /// Selection indicator colors
        public var indicator: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Indicator.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Indicator.disabled")
        )
        
        /// Selection indicator shadow colors
        public var indicatorShadow: StateColors = .init(
            enabled: sliderReference.colors.thumbShadow.enabled,
            disabled: sliderReference.colors.thumbShadow.disabled
        )
        
        /// Background colors
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Background.enabled"),
            disabled: toggleReference.colors.fill.disabled
        )
        
        /// Header colors
        public var header: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Header"),
            disabled: .init(componentAsset: "SegmentedPicker.Header")
        )
        
        /// Footer colors
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondary
        )
        
        /// Row divider colors
        public var divider: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Divider.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Divider.disabled")
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSegmentedPickerModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsED
    
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VSegmentedPickerModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Header font. Defaults to system font of size `14`.
        public var header: Font = .system(size: 14)
        
        /// Footer font. Defaults to system font of size `13`.
        public var footer: Font = .system(size: 13)
        
        /// Row font. Defaults to system font of size `14` with `medium` weight.
        ///
        /// Only applicable when using init with title
        public var rows: Font = .system(size: 14, weight: .medium)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VSegmentedPickerModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// State change animation. Defaults to `easeIn` with duration `0.2`.
        public var selection: Animation? = .easeInOut(duration: 0.2)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VSegmentedPickerModel {
    /// Reference to `VToggleModel`
    public static let toggleReference: VToggleModel = .init()
    
    /// Reference to `VSliderModel`
    public static let sliderReference: VSliderModel = .init()
}
