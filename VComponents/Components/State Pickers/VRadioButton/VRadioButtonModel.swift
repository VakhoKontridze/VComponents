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

extension VRadioButtonModel.Colors.StateColors {
    func `for`(_ state: VRadioButtonInternalState) -> Color {
        switch state {
        case .off: return off
        case .pressedOff: return off
        case .on: return on
        case .pressedOn: return on
        case .disabled: return disabled
        }
    }
}

extension VRadioButtonModel.Colors.StateOpacity {
    func `for`(_ state: VRadioButtonInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return pressedOpacity
        case .on: return 1
        case .pressedOn: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
