//
//  VSegmentedPickerModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK: - V Segmented Picker Model
/// Model that describes UI.
public struct VSegmentedPickerModel {
    // MARK: Properties
    fileprivate static let toggleReference: VToggleModel = .init()
    fileprivate static let sliderReference: VSliderModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
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
        
        /// Indicator shadow radius. Defautls to `1`.
        public var indicatorShadowRadius: CGFloat = 1
        
        /// Indicator shadow X offset. Defautls to `0`.
        public var indicatorShadowOffsetX: CGFloat = 0
        
        /// Indicator shadow Y offset. Defautls to `1`.
        public var indicatorShadowOffsetY: CGFloat = 1
        
        /// Row content margin. Defaults to `2`.
        public var contentMargin: CGFloat = 2
        
        /// Header line limit. Defaults to `1`.
        public var headerLineLimit: Int? = 1
        
        /// Footer line limit. Defaults to `5`.
        public var footerLineLimit: Int? = 5
        
        /// Spacing between header, picker, and footer. Defaults to `3`.
        public var headerPickerFooterSpacing: CGFloat = 3
        
        /// Header and footer horizontal margin. Defaults to `10`.
        public var headerFooterMarginHorizontal: CGFloat = 10
        
        /// Row divider size. Defaults to width `1` and height `19`, similarly to native picker.
        public var dividerSize: CGSize = .init(width: 1, height: 19)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Background.enabled"),
            disabled: toggleReference.colors.fill.disabled
        )
        
        /// Selection indicator colors.
        public var indicator: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Indicator.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Indicator.disabled")
        )
        
        /// Selection indicator shadow colors.
        public var indicatorShadow: StateColors = .init(
            enabled: sliderReference.colors.thumbShadow.enabled,
            disabled: sliderReference.colors.thumbShadow.disabled
        )
        
        /// Title colors.
        ///
        /// Only applicable when using `init`with title.
        public var title: RowStateColors = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primaryPressedDisabled,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom content opacities.
        ///
        /// Applicable only when `init`with content is used.
        /// When using a custom content, it's subviews cannot be configured with indivudual colors,
        /// so instead, a general opacity is being applied.
        public var customContentOpacities: RowStateOpacities = .init(
            enabled: 1,
            pressed: 0.5,
            disabled: 0.5
        )
        
        /// Row divider colors.
        public var divider: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Divider.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Divider.disabled")
        )
        
        /// Header colors.
        public var header: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Footer colors.
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondaryPressedDisabled
        )
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_ED<Color>
        
        /// Sub-model containing colors for component states.
        public typealias RowStateColors = GenericStateModel_EPD<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias RowStateOpacities = GenericStateModel_EPD<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font. Defaults to system font of size `14`.
        public var header: Font = .system(size: 14)
        
        /// Footer font. Defaults to system font of size `13`.
        public var footer: Font = .system(size: 13)
        
        /// Row font. Defaults to system font of size `14` with `medium` weight.
        ///
        /// Only applicable when using `init`with title.
        public var rows: Font = .system(size: 14, weight: .medium)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeInOut` with duration `0.2`.
        public var selection: Animation? = .easeInOut(duration: 0.2)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
