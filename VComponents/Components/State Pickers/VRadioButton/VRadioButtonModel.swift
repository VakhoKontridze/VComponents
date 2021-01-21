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
    public static let toggleModel: VToggleModel = .init()
    public static let checkBoxModel: VCheckBoxModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = toggleModel.font    // Only applicable during init with title
    public var animation: Animation = toggleModel.animation
    public var contentIsClickable: Bool = toggleModel.contentIsClickable

    public init() {}
}

// MARK:- Layout
extension VRadioButtonModel {
    public struct Layout {
        public var dimension: CGFloat = VRadioButtonModel.checkBoxModel.layout.dimension
        
        public var borderWith: CGFloat = VRadioButtonModel.checkBoxModel.layout.borderWith
        
        public var bulletDimension: CGFloat = 8
        
        public var hitBox: CGFloat = VRadioButtonModel.checkBoxModel.layout.hitBox
        
        public var contentMarginLeading: CGFloat = VRadioButtonModel.checkBoxModel.layout.contentMarginLeading
    }
}

// MARK:- Colors
extension VRadioButtonModel {
    public struct Colors {
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted
        )
        
        public var border: StateColors = .init(
            off: VRadioButtonModel.checkBoxModel.colors.border.off,
            on: VRadioButtonModel.checkBoxModel.colors.fill.on,
            disabled: VRadioButtonModel.checkBoxModel.colors.border.disabled
        )
        
        public var bullet: StateColors = .init(
            off: .clear,
            on: VRadioButtonModel.checkBoxModel.colors.fill.on,
            disabled: .clear
        )

        public var content: StateOpacity = VRadioButtonModel.checkBoxModel.colors.content

        public var textContent: StateColors = .init(   // Only applicable during init with title
            off: VRadioButtonModel.checkBoxModel.colors.textContent.off,
            on: VRadioButtonModel.checkBoxModel.colors.textContent.on,
            disabled: VRadioButtonModel.checkBoxModel.colors.textContent.disabled
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
