//
//  VToggleRightContentModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Model
public struct VToggleModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = .system(size: 15, weight: .regular, design: .default)    // Only used in init with string
    public var behavior: Behavior = .init()
    
    public init() {}
}

// MARK:- Layout
extension VToggleModel {
    public struct Layout {
        public var size: CGSize = .init(width: 51, height: 31)
        public var thumbDimension: CGFloat = 27
        
        public var contentSpacing: CGFloat = 7
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumnStartPoint - spacing
            return offset
        }
    }
}

// MARK:- Colors
extension VToggleModel {
    public struct Colors {
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var fill: StateColors = .init(
            enabledOn: primaryButtonColors.background.enabled,
            enabledOff: .init(componentAsset: "Toggle.Fill.enabledOff"),
            disabledOn: primaryButtonColors.background.disabled,
            disabledOff: .init(componentAsset: "Toggle.Fill.disabledOff")
        )
        
        public var thumb: StateColors = .init(
            enabledOn: .init(componentAsset: "Toggle.Thumb.enabledOn"),
            enabledOff: .init(componentAsset: "Toggle.Thumb.enabledOn"),
            disabledOn: .init(componentAsset: "Toggle.Thumb.enabledOn"),
            disabledOff: .init(componentAsset: "Toggle.Thumb.enabledOn")
        )
        
        public var content: StateOpacityColors = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only used in init with string
            enabledOn: ColorBook.primary,
            enabledOff: ColorBook.primary,
            disabledOn: ColorBook.primary,
            disabledOff: ColorBook.primary
        )
        
        public init() {}
    }
}

extension VToggleModel.Colors {
    public struct StateColors {
        public var enabledOn: Color
        public var enabledOff: Color
        public var disabledOn: Color
        public var disabledOff: Color
        
        public init(enabledOn: Color, enabledOff: Color, disabledOn: Color, disabledOff: Color) {
            self.enabledOn = enabledOn
            self.enabledOff = enabledOff
            self.disabledOn = disabledOn
            self.disabledOff = disabledOff
        }
    }

    public typealias StateOpacityColors = VPrimaryButtonModel.Colors.StateOpacityColors
}

// MARK:- Behavior
extension VToggleModel {
    public struct Behavior {
        public var contentIsClickable: Bool = true
        public var animation: Animation = .easeIn(duration: 0.1)
        
        public init() {}
    }
}

// MARK:- Mapping
extension VToggleModel.Colors {
    func fillColor(isOn: Bool, state: VToggleInternalState) -> Color {
        color(isOn: isOn, state: state, from: fill)
    }
    
    func thumbColor(isOn: Bool, state: VToggleInternalState) -> Color {
        color(isOn: isOn, state: state, from: thumb)
    }
    
    func contentOpacity(state: VToggleInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }
    
    func textColor(isOn: Bool, state: VToggleInternalState) -> Color {
        color(isOn: isOn, state: state, from: text)
    }
    
    private func color(isOn: Bool, state: VToggleInternalState, from colorSet: StateColors) -> Color {
        switch (isOn, state) {
        case (true, .enabled): return colorSet.enabledOn
        case (false, .enabled): return colorSet.enabledOff
        case (true, .pressed): return colorSet.enabledOn
        case (false, .pressed): return colorSet.enabledOff
        case (true, .disabled): return colorSet.disabledOn
        case (false, .disabled): return colorSet.disabledOff
        }
    }
}
