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
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
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

extension VPlainButtonModel.Colors.StateColors {
    func `for`(_ state: VPlainButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}

extension VPlainButtonModel.Colors.StateOpacity {
    func `for`(_ state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
