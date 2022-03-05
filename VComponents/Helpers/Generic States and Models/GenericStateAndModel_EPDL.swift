//
//  GenericStateAndModel_EPDL.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import SwiftUI

// MARK: - Generic State (Enabled, Pressed, Disabled, Loading)
enum GenericState_EPDL {
    // MARK: Cases
    case enabled
    case pressed
    case disabled
    case loading
    
    // MARK: Properties
    var isEnabled: Bool {
        switch self {
        case .enabled: return true
        case .pressed: return true
        case .disabled: return false
        case .loading: return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .enabled: return false
        case .pressed: return false
        case .disabled: return false
        case .loading: return true
        }
    }
    
    // MARK: Initializers
    init(isEnabled: Bool, isPressed: Bool, isLoading: Bool) {
        switch (isEnabled, isPressed, isLoading) {
        case (false, _, _): self = .disabled
        case (true, false, false): self = .enabled
        case (true, true, false): self = .pressed
        case (true, _, true): self = .loading
        }
    }
}

// MARK: - Generic State Model (Enabled, Pressed, Disabled, Loading)
/// Value group containing enabled, pressed, disabled, and loading values.
public struct GenericStateModel_EPDL<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabled: Value
    
    /// Pressed value.
    public var pressed: Value
    
    /// Disabled value.
    public var disabled: Value
    
    /// Loading value.
    public var loading: Value
    
    // MARK: Initializers
    /// Initializes group with values.
    public init(
        enabled: Value,
        pressed: Value,
        disabled: Value,
        loading: Value
    ) {
        self.enabled = enabled
        self.pressed = pressed
        self.disabled = disabled
        self.loading = loading
    }
}

extension GenericStateModel_EPDL: Equatable where Value: Equatable {}

// MARK: - Mapping
extension GenericStateModel_EPDL {
    func `for`(_ state: GenericState_EPDL) -> Value {
        switch state {
        case .enabled: return enabled
        case .pressed: return pressed
        case .disabled: return disabled
        case .loading: return loading
        }
    }
}