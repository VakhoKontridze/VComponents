//
//  StateColors.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK:- Enabled, Disabled
public struct StateColorsED {
    public var enabled: Color
    public var disabled: Color
    
    public init(enabled: Color, disabled: Color) {
        self.enabled = enabled
        self.disabled = disabled
    }
}

extension StateColorsED {
    func `for`(_ state: VStepperState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VWheelPickerState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VSliderState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}

// MARK:- Enabled, Pressed, Disabled
public struct StateColorsEPD {
    public var enabled: Color
    public var pressed: Color
    public var disabled: Color
    
    public init(enabled: Color, pressed: Color, disabled: Color) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
    }
}

extension StateColorsEPD {
    func `for`(_ state: VSecondaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    
    func `for`(_ state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VPlainButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VStepperButtonState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
}

// MARK:- Enabled, Pressed, Disabled, Loading
public struct StateColorsEPDL {
    public var enabled: Color
    public var pressed: Color
    public var disabled: Color
    public var loading: Color
    
    public init(enabled: Color, pressed: Color, disabled: Color, loading: Color) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.loading = loading
    }
}

extension StateColorsEPDL {
    func `for`(_ state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        case .loading: return loading
        }
    }
}

// MARK:- Off, On, Disabled
public struct StateColorsOOD {
    public var off: Color
    public var on: Color
    public var disabled: Color
    
    public init(off: Color, on: Color, disabled: Color) {
        self.off = off
        self.on = on
        self.disabled = disabled
    }
}

extension StateColorsOOD {
    func `for`(_ state: VToggleInternalState) -> Color {
        switch state {
        case .off: return off
        case .pressedOff: return off
        case .on: return on
        case .pressedOn: return on
        case .disabled: return disabled
        }
    }
    
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

// MARK:- Off, On, Intermediate, Disabled
public struct StateColorsOOID {
    public var off: Color
    public var on: Color
    public var intermediate: Color
    public var disabled: Color

    public init(off: Color, on: Color, intermediate: Color, disabled: Color) {
        self.off = off
        self.on = on
        self.intermediate = intermediate
        self.disabled = disabled
    }
}

extension StateColorsOOID {
    func `for`(_ state: VCheckBoxInternalState) -> Color {
        switch state {
        case .off: return off
        case .pressedOff: return off
        case .on: return on
        case .pressedOn: return on
        case .intermediate: return intermediate
        case .pressedIntermediate: return intermediate
        case .disabled: return disabled
        }
    }
}

// MARK:- Enabled, Focused, Disabled
public struct StateColorsEFD {
    public var enabled: Color
    public var focused: Color
    public var disabled: Color
    
    public init(enabled: Color, focused: Color, disabled: Color) {
        self.enabled = enabled
        self.focused = focused
        self.disabled = disabled
    }
}

extension StateColorsEFD {
    func `for`(_ state: VTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return focused
        case .disabled: return disabled
        }
    }
}

// MARK:- Enabled, Focused, Success, Error, Disabled
public struct StateColorsEFSED {
    public var enabled: Color
    public var focused: Color
    public var success: Color
    public var error: Color
    public var disabled: Color
    
    public init(enabled: Color, focused: Color, success: Color, error: Color, disabled: Color) {
        self.enabled = enabled
        self.focused = focused
        self.success = success
        self.error = error
        self.disabled = disabled
    }
}

extension StateColorsEFSED {
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
}

// MARK:- Enabled, +Pressed, Focused, +Pressed, Success, +Pressed, Error, +Pressed, Disabled
public struct StateColorsEpFpSpEpD {
    public var enabled: Color
    public var enabledPressed: Color
    public var focused: Color
    public var focusedPressed: Color
    public var success: Color
    public var successPressed: Color
    public var error: Color
    public var errorPressed: Color
    public var disabled: Color
    
    public init(enabled: Color, enabledPressed: Color, focused: Color, focusedPressed: Color, success: Color, successPressed: Color, error: Color, errorPressed: Color, disabled: Color) {
        self.enabled = enabled
        self.enabledPressed = enabledPressed
        self.focused = focused
        self.focusedPressed = focusedPressed
        self.success = success
        self.successPressed = successPressed
        self.error = error
        self.errorPressed = errorPressed
        self.disabled = disabled
    }
}

extension StateColorsEpFpSpEpD {
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
