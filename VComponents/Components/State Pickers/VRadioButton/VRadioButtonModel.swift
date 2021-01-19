//
//  VRadioButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Radio Button Model
/// Model that describes UI
public struct VRadioButtonModel {
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
extension VRadioButtonModel {
    public struct Layout {
        public static let checkBoxLayout: VCheckBoxModel.Layout = .init()
        
        public var dimension: CGFloat = checkBoxLayout.dimension
        
        public var borderWith: CGFloat = checkBoxLayout.borderWith
        
        public var bulletDimension: CGFloat = 8
        
        public var hitBox: CGFloat = checkBoxLayout.hitBox
        
        public var contentMarginLeading: CGFloat = checkBoxLayout.contentMarginLeading
    }
}

// MARK:- Colors
extension VRadioButtonModel {
    public struct Colors {
        public static let checkBoxColors: VCheckBoxModel.Colors = .init()

        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted
        )
        
        public var border: StateColors = .init(
            off: checkBoxColors.border.off,
            on: checkBoxColors.fill.on,
            disabled: checkBoxColors.border.disabled
        )
        
        public var bullet: StateColors = .init(
            off: .clear,
            on: checkBoxColors.fill.on,
            disabled: .clear
        )

        public var content: StateOpacity = checkBoxColors.content

        public var text: StateColors = .init(   // Only applicable during init with title
            off: checkBoxColors.text.off,
            on: checkBoxColors.text.on,
            disabled: checkBoxColors.text.disabled
        )

        public init() {}
    }
}

extension VRadioButtonModel.Colors {
    public typealias StateColors = VToggleModel.Colors.StateColors

    public typealias StateOpacity = VToggleModel.Colors.StateOpacity
}

// MARK:- ViewModel
extension VRadioButtonModel.Colors {
    func fillColor(state: VRadioButtonInternalState) -> Color {
        color(state: state, from: fill)
    }
    
    func borderColor(state: VRadioButtonInternalState) -> Color {
        color(state: state, from: border)
    }
    
    func bulletColor(state: VRadioButtonInternalState) -> Color {
        color(state: state, from: bullet)
    }

    func contentOpacity(state: VRadioButtonInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return content.pressedOpacity
        case .on: return 1
        case .pressedOn: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
        }
    }

    func textColor(state: VRadioButtonInternalState) -> Color {
        color(state: state, from: text)
    }

    private func color(state: VRadioButtonInternalState, from colorSet: StateColors) -> Color {
        switch state {
        case .off: return colorSet.off
        case .pressedOff: return colorSet.off
        case .on: return colorSet.on
        case .pressedOn: return colorSet.on
        case .disabled: return colorSet.disabled
        }
    }
}
