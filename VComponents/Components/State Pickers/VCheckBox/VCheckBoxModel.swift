//
//  VCheckBoxModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V CheckBox Model
/// Model that describes UI
public struct VCheckBoxModel {
    public static let toggleFont: Font = VToggleModel().font
    public static let toggleAnimation: Animation = VToggleModel().animation
    public static let toggleContentIsClickable: Bool = VToggleModel().contentIsClickable
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = toggleFont    // Only applicable during init with title
    public var animation: Animation = toggleAnimation
    public var contentIsClickable: Bool = toggleContentIsClickable

    public init() {}
}

// MARK:- Layout
extension VCheckBoxModel {
    public struct Layout {
        public static let toggleLayout: VToggleModel.Layout = .init()
        
        public var dimension: CGFloat = 16
        public var cornerRadius: CGFloat = 4
        
        public var borderWith: CGFloat = 1
        
        public var iconDimension: CGFloat = 10
        
        public var hitBox: CGFloat = toggleLayout.contentMarginLeading
        
        public var contentMarginLeading: CGFloat = 0
    }
}

// MARK:- Colors
extension VCheckBoxModel {
    public struct Colors {
        public static let toggleColors: VToggleModel.Colors = .init()

        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: toggleColors.fill.on,
            intermediate: toggleColors.fill.on,
            disabled: ColorBook.primaryInverted
        )
        
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: .clear,
            intermediate: .clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        public var icon: StateColors = .init(
            off: .clear,
            on: toggleColors.thumb.off,
            intermediate: toggleColors.thumb.on,
            disabled: .clear
        )

        public var content: StateOpacity = .init(
            pressedOpacity: toggleColors.content.pressedOpacity,
            disabledOpacity: toggleColors.content.disabledOpacity
        )

        public var text: StateColors = .init(   // Only applicable during init with title
            off: toggleColors.text.off,
            on: toggleColors.text.on,
            intermediate: toggleColors.text.on,
            disabled: toggleColors.text.disabled
        )

        public init() {}
    }
}

extension VCheckBoxModel.Colors {
    public struct StateColors {
        public var off: Color
        public var on: Color
        public var intermediate: Color
        public var disabled: Color

        public init(off: Color, on: Color, intermediate: Color, disabled: Color) {
            self.off = off
            self.on = on
            self.intermediate = intermediate
            self.disabled = disabled
        }
    }

    public typealias StateOpacity = VPrimaryButtonModel.Colors.StateOpacity
}

// MARK:- ViewModel
extension VCheckBoxModel.Colors {
    func fillColor(state: VCheckBoxInternalState) -> Color {
        color(from: fill, state: state)
    }
    
    func borderColor(state: VCheckBoxInternalState) -> Color {
        color(from: border, state: state)
    }
    
    func iconColor(state: VCheckBoxInternalState) -> Color {
        color(from: icon, state: state)
    }

    func contentOpacity(state: VCheckBoxInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return content.pressedOpacity
        case .on: return 1
        case .pressedOn: return content.pressedOpacity
        case .intermediate: return 1
        case .pressedIntermediate: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }

    func textColor(state: VCheckBoxInternalState) -> Color {
        color(from: text, state: state)
    }

    private func color(from colorSet: StateColors, state: VCheckBoxInternalState) -> Color {
        switch state {
        case .off: return colorSet.off
        case .pressedOff: return colorSet.off
        case .on: return colorSet.on
        case .pressedOn: return colorSet.on
        case .intermediate: return colorSet.intermediate
        case .pressedIntermediate: return colorSet.intermediate
        case .disabled: return colorSet.disabled
        }
    }
}
