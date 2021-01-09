//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Model Button
public struct VPlainButtonModel {
    public static let squareButtonFont: Font = VSquareButtonModel().font
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = squareButtonFont    // Only used in init with string
    
    public init() { }
}

// MARK:- Layout
extension VPlainButtonModel {
    public struct Layout {
        public var hitBoxSpacingX: CGFloat = 15
        public var hitBoxSpacingY: CGFloat = 5
        
        public init() {}
    }
}

// MARK:- Colors
extension VPlainButtonModel {
    public struct Colors {
        public var foreground: StateOpacityColors = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only used in init with string
            enabled: ColorBook.accent,
            pressed: ColorBook.accent,
            disabled: ColorBook.accent
        )
        
        public init() {}
    }
}

extension VPlainButtonModel.Colors {
    public typealias StateColors = VSecondaryButtonModel.Colors.StateColors
    
    public typealias StateOpacityColors = VSecondaryButtonModel.Colors.StateOpacityColors
}

// MARK:- ViewModel
extension VPlainButtonModel.Colors {
    func foregroundOpacity(state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }
    
    func textColor(state: VPlainButtonInternalState) -> Color {
        color(for: state, from: text)
    }
    
    private func color(for state: VPlainButtonInternalState, from colorSet: StateColors) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .pressed: return colorSet.pressed
        case .disabled: return colorSet.disabled
        }
    }
}
