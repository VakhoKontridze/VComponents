//
//  VTextFieldState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Text Field State
/// Enum that describes state, such as `enabled`, `focused`, or `disabled`.
public enum VTextFieldState: Int, CaseIterable {
    // MARK: Cases
    /// Enabled.
    case enabled
    
    /// Focused.
    case focused
    
    /// Disabled.
    case disabled
    
    // MARK: Properties
    /// Indicates if state is enabled.
    public var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
    
    var isFocused: Bool {
        switch self {
        case .enabled: return false
        case .focused: return true
        case .disabled: return false
        }
    }

    // MARK: Helpers
    static func baseTextFieldState(_ state: Binding<VTextFieldState>) -> Binding<VBaseTextFieldState> {
        .init(
            get: {
                switch state.wrappedValue {
                case .enabled: return .enabled
                case .focused: return .focused
                case .disabled: return .disabled
                }
            },
            set: { baseState in
                switch baseState {
                case .enabled: state.wrappedValue = .enabled
                case .focused: state.wrappedValue = .focused
                case .disabled: state.wrappedValue = .disabled
                }
            }
        )
    }
    
    var clearButtonIsEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
    
    var visiblityButtonIsEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
    
    var cancelButtonIsEnabled: Bool {
        switch self {
        case .enabled: return true
        case .focused: return true
        case .disabled: return false
        }
    }
}

// MARK: - Mapping
extension StateColors_EFD {
    func `for`(_ state: VTextFieldState) -> Color {
        switch state {
        case .enabled: return enabled
        case .focused: return focused
        case .disabled: return disabled
        }
    }
}

extension StateColors_EFSED {
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

extension StateColors_EFSEPD {
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

extension StateOpacities_D {
    func `for`(_ state: VTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return disabledOpacity
        }
    }
}

extension StateColorsAndOpacities_EP_D {
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
}
