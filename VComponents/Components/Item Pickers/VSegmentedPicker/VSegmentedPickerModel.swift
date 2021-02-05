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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSegmentedPickerModel {
    public struct Layout {
        public var height: CGFloat = 31
        public var cornerRadius: CGFloat = 7
        
        public var indicatorCornerRadius: CGFloat = 6
        public var indicatorMargin: CGFloat = 2
        public var indicatorPressedScale: CGFloat = 0.95
        let indicatorShadowRadius: CGFloat = 1
        let indicatorShadowOffsetY: CGFloat = 1
        
        public var rowContentMargin: CGFloat = 2
        var actualRowContentMargin: CGFloat { indicatorMargin + rowContentMargin }
        
        public var headerFooterSpacing: CGFloat = 3
        public var headerFooterMarginHor: CGFloat = 10
        
        public var dividerSize: CGSize = .init(width: 1, height: 19)
        
        public init() {}
    }
}

// MARK:- Colors
extension VSegmentedPickerModel {
    public struct Colors {
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
            enabled: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public var indicator: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Indicator.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Indicator.disabled")
        )
        public var indicatorShadow: StateColors = .init(
            enabled: sliderReference.colors.thumb.shadow.enabled,
            disabled: sliderReference.colors.thumb.shadow.disabled
        )
        
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Background.enabled"),
            disabled: toggleReference.colors.fill.disabled
        )
        
        public var header: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Header"),
            disabled: .init(componentAsset: "SegmentedPicker.Header")
        )
        
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondary
        )
        
        public var divider: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Divider.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Divider.disabled")
        )
        
        public init() {}
    }
}

extension VSegmentedPickerModel.Colors {
    public typealias StateColors = StateColorsED
    
    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VSegmentedPickerModel {
    public struct Fonts {
        public var header: Font = .system(size: 14, weight: .regular, design: .default)
        public var footer: Font = .system(size: 13, weight: .regular, design: .default)
        
        public var rows: Font = .system(size: 14, weight: .medium, design: .default)    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VSegmentedPickerModel {
    public struct Animations {
        public var selection: Animation? = .easeInOut(duration: 0.2)
        
        public init() {}
    }
}

// MARK:- References
extension VSegmentedPickerModel {
    public static let toggleReference: VToggleModel = .init()
    public static let sliderReference: VSliderModel = .init()
}
