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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()

    public init() {}
}

// MARK:- Layout
extension VRadioButtonModel {
    public struct Layout {
        public var dimension: CGFloat = checkBoxReference.layout.dimension
        
        public var borderWith: CGFloat = checkBoxReference.layout.borderWith
        
        public var bulletDimension: CGFloat = 8
        
        public var hitBox: CGFloat = checkBoxReference.layout.hitBox
        
        public var contentMarginLeading: CGFloat = checkBoxReference.layout.contentMarginLeading
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
            off: checkBoxReference.colors.border.off,
            on: checkBoxReference.colors.fill.on,
            disabled: checkBoxReference.colors.border.disabled
        )
        
        public var bullet: StateColors = .init(
            off: .clear,
            on: checkBoxReference.colors.fill.on,
            disabled: .clear
        )

        public var content: StateOpacity = checkBoxReference.colors.content

        public var textContent: StateColors = .init(   // Only applicable during init with title
            off: checkBoxReference.colors.textContent.off,
            on: checkBoxReference.colors.textContent.on,
            disabled: checkBoxReference.colors.textContent.disabled
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

// MARK:- Fonts
extension VRadioButtonModel {
    public struct Fonts {
        public var title: Font = toggleRefrence.fonts.title    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VRadioButtonModel {
    public struct Animations {
        public var stateChange: Animation? = toggleRefrence.animations.stateChange
        
        public init() {}
    }
}

// MARK:- Misc
extension VRadioButtonModel {
    public struct Misc {
        public var contentIsClickable: Bool = toggleRefrence.misc.contentIsClickable
        
        public init() {}
    }
}

// MARK:- References
extension VRadioButtonModel {
    public static let toggleRefrence: VToggleModel = .init()
    public static let checkBoxReference: VCheckBoxModel = .init()
}
