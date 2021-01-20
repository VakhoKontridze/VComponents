//
//  VChevronButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Model
/// Model that describes UI
public struct VChevronButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VChevronButtonModel {
    public struct Layout {
        public var dimension: CGFloat = 32
        
        public var iconDimension: CGFloat = 12
        
        public var hitBoxHor: CGFloat = 0
        public var hitBoxVer: CGFloat = 0
        
        public init() {}
    }
}

// MARK:- Colors
extension VChevronButtonModel {
    public struct Colors {
        public var content: StateColorsAndOpacity = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var background: StateColors = .init(
            enabled: .init(componentAsset: "ChevronButton.Background.enabled"),
            pressed: .init(componentAsset: "ChevronButton.Background.pressed"),
            disabled: .init(componentAsset: "ChevronButton.Background.disabled")
        )
        
        public init() {}
    }
}

extension VChevronButtonModel.Colors {
    public typealias StateColors = VSecondaryButtonModel.Colors.StateColors
    
    public struct StateColorsAndOpacity {
        public var enabled: Color
        public var pressed: Color
        public var disabled: Color
        public var pressedOpacity: Double
        public var disabledOpacity: Double
        
        public init(enabled: Color, pressed: Color, disabled: Color, pressedOpacity: Double, disabledOpacity: Double) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VChevronButtonInternalState) -> Color {
            switch state {
            case .enabled: return enabled
            case .pressed: return pressed
            case .disabled: return disabled
            }
        }
        
        func `for`(_ state: VChevronButtonInternalState) -> Double {
            switch state {
            case .enabled: return 1
            case .pressed: return pressedOpacity
            case .disabled: return disabledOpacity
            }
        }
    }
}
