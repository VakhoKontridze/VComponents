//
//  StateColors.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - Enabled, Disabled
/// Color group containing `enabled` and `disabled` values.
public struct StateColors_ED: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Disabled color.
    public var disabled: Color
    
    /// Initializes group with values.
    public init(
        enabled: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.disabled = disabled
    }
    
    // MARK: Initializers
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            enabled: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
    func `for`(_ state: VStepperState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VSegmentedPickerState) -> Color {
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
    
    func `for`(_ state: VRangeSliderState) -> Color {
        switch state {
        case .enabled: return enabled
        case .disabled: return disabled
        }
    }
}

// MARK: - Enabled, Pressed, Disabled
/// Color group containing `enabled`, `pressed`, and `disabled` values.
public struct StateColors_EPD: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            enabled: ColorBook.clear,
            pressed: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }
    
    // MARK: Mapping
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
    
    func `for`(_ state: VChevronButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VCloseButtonInternalState) -> Color {
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

// MARK: - Enabled, Pressed, Disabled, Loading
/// Color group containing enabled, pressed, disabled, and loading values.
public struct StateColors_EPDL: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Pressed color.
    public var pressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    /// Loading color.
    public var loading: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        pressed: Color,
        disabled: Color,
        loading: Color
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.loading = loading
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            enabled: ColorBook.clear,
            pressed: ColorBook.clear,
            disabled: ColorBook.clear,
            loading: ColorBook.clear
        )
    }

    // MARK: Mapping
    func `for`(_ state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        case .loading: return loading
        }
    }
}

// MARK: - Off, On, Disabled
/// Color group containing `off`, `on`, and `disabled` values.
public struct StateColors_OOD: Equatable {
    // MARK: Properties
    /// Off color.
    public var off: Color
    
    /// On color.
    public var on: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Color,
        on: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            off: ColorBook.clear,
            on: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
    func `for`(_ state: VToggleInternalState) -> Color {
        switch state {
        case .off: return off
        case .on: return on
        case .pressedOff: return off
        case .pressedOn: return on
        case .disabled: return disabled
        }
    }
    
    func `for`(_ state: VRadioButtonInternalState) -> Color {
        switch state {
        case .off: return off
        case .on: return on
        case .pressedOff: return off
        case .pressedOn: return on
        case .disabled: return disabled
        }
    }
}

// MARK: - Off, On, Indeterminate, Disabled
/// Color group containing `off`, `on`, `indeterminate`, and `disabled` values.
public struct StateColors_OOID: Equatable {
    // MARK: Properties
    /// Off color.
    public var off: Color
    
    /// On color.
    public var on: Color
    
    /// Indeterminate color.
    public var indeterminate: Color
    
    /// Disabled color.
    public var disabled: Color

    // MARK: Initializers
    /// Initializes group with values.
    public init(
        off: Color,
        on: Color,
        indeterminate: Color,
        disabled: Color
    ) {
        self.off = off
        self.on = on
        self.indeterminate = indeterminate
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            off: ColorBook.clear,
            on: ColorBook.clear,
            indeterminate: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
    func `for`(_ state: VCheckBoxInternalState) -> Color {
        switch state {
        case .off: return off
        case .on: return on
        case .indeterminate: return indeterminate
        case .pressedOff: return off
        case .pressedOn: return on
        case .pressedIndeterminate: return indeterminate
        case .disabled: return disabled
        }
    }
}

// MARK: - Enabled, Focused, Disabled
/// Color group containing `enabled`, `focused`, and `disabled` values.
public struct StateColors_EFD: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Focused color.
    public var focused: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        focused: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.focused = focused
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            enabled: ColorBook.clear,
            focused: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
    func `for`(_ state: VTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return focused
        case .disabled: return disabled
        }
    }
}

// MARK: - Enabled, Focused, Success, Error, Disabled
/// Color group containing `enabled`, `focused`, `success`, `error`, and `disabled` values.
public struct StateColors_EFSED: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Focused color.
    public var focused: Color
    
    /// Success color.
    public var success: Color
    
    /// Error color.
    public var error: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        focused: Color,
        success: Color,
        error: Color,
        disabled: Color
    ) {
        self.enabled = enabled
        self.focused = focused
        self.success = success
        self.error = error
        self.disabled = disabled
    }
    
    /// Initializes group with clear values.
    public static var clear: Self {
        .init(
            enabled: ColorBook.clear,
            focused: ColorBook.clear,
            success: ColorBook.clear,
            error: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
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

// MARK: - Enabled, +Pressed, Focused, +Pressed, Success, +Pressed, Error, +Pressed, Disabled
/// Color group containing `enabled` (+`pressed`), `focused` (+`pressed`), `success` (+`pressed`), `error` (+`pressed`), and `disabled` values.
public struct StateColors_EpFpSpEpD: Equatable {
    // MARK: Properties
    /// Enabled color.
    public var enabled: Color
    
    /// Enabled pressed color.
    public var enabledPressed: Color
    
    /// Focused color.
    public var focused: Color
    
    /// Focused pressed color.
    public var focusedPressed: Color
    
    /// Success color.
    public var success: Color
    
    /// Success pressed color.
    public var successPressed: Color
    
    /// Error color.
    public var error: Color
    
    /// Error pressed color.
    public var errorPressed: Color
    
    /// Disabled color.
    public var disabled: Color
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Color,
        enabledPressed: Color,
        focused: Color,
        focusedPressed: Color,
        success: Color,
        successPressed: Color,
        error: Color,
        errorPressed: Color,
        disabled: Color
    ) {
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
    
    /// Initializes group with clear values.
    public var clear: Self {
        .init(
            enabled: ColorBook.clear,
            enabledPressed: ColorBook.clear,
            focused: ColorBook.clear,
            focusedPressed: ColorBook.clear,
            success: ColorBook.clear,
            successPressed: ColorBook.clear,
            error: ColorBook.clear,
            errorPressed: ColorBook.clear,
            disabled: ColorBook.clear
        )
    }

    // MARK: Mapping
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