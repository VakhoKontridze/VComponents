//
//  VSecondaryButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button Model
/// Model that describes UI
public struct VSecondaryButtonModel {
    public static let primaryButtonFont: Font = VPrimaryButtonModel().font
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = primaryButtonFont   // Only applicable during init with title
    
    public init() {}
}

// MARK:- Layout
extension VSecondaryButtonModel {
    public struct Layout {
        public var height: CGFloat = 32
        var cornerRadius: CGFloat { height / 2 }
        
        public var borderWidth: CGFloat = 0
        var hasBorder: Bool { borderWidth > 0 }
        
        public var contentMarginHor: CGFloat = 10
        public var contentMarginVer: CGFloat = 3
        
        public var hitBoxHor: CGFloat = 10
        public var hitBoxVer: CGFloat = 10
        
        public init() {}
    }
}

// MARK:- Colors
extension VSecondaryButtonModel {
    public struct Colors {
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var content: StateOpacity = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
            enabled: primaryButtonColors.textContent.enabled,
            pressed: primaryButtonColors.textContent.pressed,
            disabled: primaryButtonColors.textContent.disabled
        )
        
        public var background: StateColors = .init(
            enabled: primaryButtonColors.background.enabled,
            pressed: primaryButtonColors.background.pressed,
            disabled: primaryButtonColors.background.disabled
        )
        
        public var border: StateColors = .init(
            enabled: primaryButtonColors.border.enabled,
            pressed: primaryButtonColors.border.pressed,
            disabled: primaryButtonColors.border.disabled
        )
        
        public init() { }
    }
}

extension VSecondaryButtonModel.Colors {
    public struct StateColors {
        public var enabled: Color
        public var pressed: Color
        public var disabled: Color
        
        public init(enabled: Color, pressed: Color, disabled: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
        
        func `for`(_ state: VSecondaryButtonInternalState) -> Color {
            switch state {
            case .enabled: return enabled
            case .pressed: return pressed
            case .disabled: return disabled
            }
        }
    }
    
    public typealias StateOpacity = VPrimaryButtonModel.Colors.StateOpacity
}

extension VSecondaryButtonModel.Colors.StateOpacity {
    func `for`(_ state: VSecondaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
