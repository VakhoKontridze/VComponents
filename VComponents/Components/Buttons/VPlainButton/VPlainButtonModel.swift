//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Model Button
/// Model that describes UI
public struct VPlainButtonModel {
    public static let squareButtonFont: Font = VSquareButtonModel().font
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var font: Font = squareButtonFont    // Only applicable during init with title
    
    public init() { }
}

// MARK:- Layout
extension VPlainButtonModel {
    public struct Layout {
        public var hitBoxHor: CGFloat = 15
        public var hitBoxVer: CGFloat = 5
        
        public init() {}
    }
}

// MARK:- Colors
extension VPlainButtonModel {
    public struct Colors {
        public var content: StateOpacity = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(   // Only applicable during init with title
            enabled: ColorBook.accent,
            pressed: ColorBook.accent,
            disabled: ColorBook.accent
        )
        
        public init() {}
    }
}

extension VPlainButtonModel.Colors {
    public typealias StateColors = VSecondaryButtonModel.Colors.StateColors
    
    public typealias StateOpacity = VSecondaryButtonModel.Colors.StateOpacity
}

// MARK:- ViewModel
extension VPlainButtonModel.Colors {
    func contentOpacity(state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return content.pressedOpacity
        case .disabled: return content.disabledOpacity
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
