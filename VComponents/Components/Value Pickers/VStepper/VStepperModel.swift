//
//  VStepperModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/4/21.
//

import SwiftUI

// MARK:- V Stepper Picker Model
/// Model that describes UI
public struct VStepperModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    
    public init() {}
}

// MARK:- Layout
extension VStepperModel {
    public struct Layout {
        public var size: CGSize = .init(width: 94, height: 32)
        public var cornerRadius: CGFloat = 7
        
        public var iconDimension: CGFloat = 15
        
        public var divider: CGSize = segmentedPickerReference.layout.dividerSize
        
        public init() {}
    }
}

// MARK:- Layout
extension VStepperModel {
    public struct Colors {
        public var background: StateColors = segmentedPickerReference.colors.background
        
        public var buttonBackground: ButtonStateColors = .init(
            enabled: .clear,
            pressed: .init(componentAsset: "VStepper.Button.Background.pressed"),
            disabled: .clear
        )
        
        public var buttonIcon: StateColorsAndOpacity = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var divider: StateColors = segmentedPickerReference.colors.divider
        
        public init() {}
    }
}

extension VStepperModel.Colors {
    public typealias StateColors = VSegmentedPickerModel.Colors.StateColors
    
    public struct ButtonStateColors {
        public var enabled: Color
        public var pressed: Color
        public var disabled: Color
        
        public init(enabled: Color, pressed: Color, disabled: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
        
        func `for`(_ state: VStepperButtonState) -> Color {
            switch state {
            case .enabled: return enabled
            case .pressed: return pressed
            case .disabled: return disabled
            }
        }
    }
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}

extension VStepperModel.Colors.StateColors {
    func `for`(_ state: VStepperState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}

extension VStepperModel.Colors.StateColorsAndOpacity {
    func `for`(_ state: VStepperButtonState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VStepperButtonState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}

// MARK:- References
extension VStepperModel {
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
}
