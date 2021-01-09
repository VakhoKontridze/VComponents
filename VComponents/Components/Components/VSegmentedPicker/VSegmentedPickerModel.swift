//
//  VSegmentedPickerModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker Model
public struct VSegmentedPickerModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var behavior: Behavior = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSegmentedPickerModel {
    public struct Layout {
        public var height: CGFloat = 31
        public var cornerRadius: CGFloat = 7
        
        public var indicatorCornerRadius: CGFloat = 6
        public var indicatorPadding: CGFloat = 2
        public var indicatorPressedScale: CGFloat = 0.95
        let indicatorShadowRadius: CGFloat = 1
        let indicatorShadowOffsetY: CGFloat = 1
        
        public var rowContentPadding: CGFloat = 2
        var actualRowContentPadding: CGFloat { indicatorPadding + rowContentPadding }
        
        public var titleSpacing: CGFloat = 3
        public var titlePaddingHor: CGFloat = 10
        
        public var dividerHeight: CGFloat = 17
        
        public init() {}
    }
}

// MARK:- Colors
extension VSegmentedPickerModel {
    public struct Colors {
        public static let toggleColors: VToggleModel.Colors = .init()
        public static let sliderColors: VSliderModel.Colors = .init()
        
        public var foreground: StateOpacityColors = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only used in init with string
            enabled: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public var indicator: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Indicator.enabled"),
            disabled: .init(componentAsset: "SegmentedPicker.Indicator.disabled")
        )
        public var indicatorShadow: StateColors = .init(
            enabled: sliderColors.thumb.shadow.enabled,
            disabled: sliderColors.thumb.shadow.disabled
        )
        
        public var background: StateColors = .init(
            enabled: toggleColors.fill.off,
            disabled: toggleColors.fill.disabled
        )
        
        public var title: StateColors = .init(
            enabled: .init(componentAsset: "SegmentedPicker.Title"),
            disabled: .init(componentAsset: "SegmentedPicker.Title")
        )
        
        public var subtitle: StateColors = .init(
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
    }
    
    public typealias StateOpacityColors = VPrimaryButtonModel.Colors.StateOpacityColors
}

// MARK:- Fonts
extension VSegmentedPickerModel {
    public struct Fonts {
        public var title: Font = .system(size: 14, weight: .regular, design: .default)
        public var subtitle: Font = .system(size: 13, weight: .regular, design: .default)
        
        public var rows: Font = .system(size: 14, weight: .medium, design: .default)    // Only used in init with string
    }
}

// MARK:- Behavior
extension VSegmentedPickerModel {
    public struct Behavior {
        public var selectionAnimation: Animation? = .easeInOut(duration: 0.2)
        
        public init() {}
    }
}

// MARK:- ViewModel
extension VSegmentedPickerModel.Colors {
    func foregroundOpacity(state: VSegmentedPickerState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return foreground.disabledOpacity
        }
    }
    
    func foregroundOpacity(state: VSegmentedPickerRowState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }
    
    func textColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: text)
    }
    
    func indicatorColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: indicator)
    }
    
    func indicatorShadowColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: indicatorShadow)
    }
    
    func backgroundColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: background)
    }
    
    func titleColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: title)
    }
    
    func subtitleColor(for state: VSegmentedPickerState) -> Color {
        color(for: state, from: subtitle)
    }
    
    private func color(for state: VSegmentedPickerState, from colorSet: StateColors) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .disabled: return colorSet.disabled
        }
    }
}
