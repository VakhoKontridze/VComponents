//
//  StateColorsAndOpacities.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK:- Enabled, Disabled | Disabled
public struct StateColorsAndOpacitiesEP_D {
    public var enabled: Color
    public var disabled: Color
    public var disabledOpacity: Double
    
    public init(enabled: Color, disabled: Color, disabledOpacity: Double) {
        self.enabled = enabled
        self.disabled = disabled
        self.disabledOpacity = disabledOpacity
    }
}

extension StateColorsAndOpacitiesEP_D {
    func `for`(_ state: VTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VBaseTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VBaseTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return disabledOpacity
        }
    }
}

// MARK:- Enabled, Pressed, Disabled | Pressed, Disabled
public struct StateColorsAndOpacitiesEPD_PD {
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
}

extension StateColorsAndOpacitiesEPD_PD {
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
    
    func `for`(_ state: VCloseButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VCloseButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
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

// MARK:- Enabled, +Pressed, Focused, +Pressed, Success, +Pressed, Error, +Pressed, Disabled | Pressed, Disabled
public struct StateColorsEpFpSpEpD_PD {
    public var enabled: Color
    public var enabledPressed: Color
    public var focused: Color
    public var focusedPressed: Color
    public var success: Color
    public var successPressed: Color
    public var error: Color
    public var errorPressed: Color
    public var disabled: Color
    public var pressedOpacity: Double
    public var disabledOpacity: Double
    
    public init(enabled: Color, enabledPressed: Color, focused: Color, focusedPressed: Color, success: Color, successPressed: Color, error: Color, errorPressed: Color, disabled: Color, pressedOpacity: Double, disabledOpacity: Double) {
        self.enabled = enabled
        self.enabledPressed = enabledPressed
        self.focused = focused
        self.focusedPressed = focusedPressed
        self.success = success
        self.successPressed = successPressed
        self.error = error
        self.errorPressed = errorPressed
        self.disabled = disabled
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
}

extension StateColorsEpFpSpEpD_PD {
    func `for`(_ state: VTextFieldState, highlight: VTextFieldHighlight) -> Color {
        switch (highlight, state) {
        case (_, .disabled): return disabled
        case (.none, .enabled): return enabled
        case (.none, .focused): return focused
        case (.success, .enabled): return success
        case (.success, .focused): return success
        case (.error, .enabled): return error
        case (.error, .focused): return error
        }
    }
    
    func `for`(highlight: VTextFieldHighlight) -> Color {
        switch highlight {
        case .none: return enabledPressed
        case .success: return successPressed
        case .error: return errorPressed
        }
    }
}
