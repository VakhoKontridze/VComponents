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
        
        public var dividerHeight: CGFloat = 17
        
        public init() {}
    }
}

// MARK:- Colors
extension VSegmentedPickerModel {
    public struct Colors {
        public var content: StateOpacity = .init(
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
            enabled: toggleReference.colors.fill.off,
            disabled: toggleReference.colors.fill.disabled
        )
        
        public var header: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Title"),
            disabled: .init(componentAsset: "SegmentedPicker.Title")
        )
        
        public var footer: StateColors = .init(
            enabled: ColorBook.secondary,
            disabled: ColorBook.secondary
        )
        
        public init() {}
    }
}

extension VSegmentedPickerModel.Colors {
    public struct StateColors {
        public var enabled: Color
        public var disabled: Color
        
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        func `for`(_ state: VSegmentedPickerState) -> Color {
            switch state {
            case .enabled: return enabled
            case .disabled: return disabled
            }
        }
    }
    
    public typealias StateOpacity = VPrimaryButtonModel.Colors.StateOpacity
}

extension VSegmentedPickerModel.Colors.StateOpacity {
    func `for`(_ state: VSegmentedPickerState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VSegmentedPickerRowState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
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
