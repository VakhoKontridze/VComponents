//
//  StateOpacities.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK: - Pressed
/// Opacity level group containing values for `pressed` state
public struct StateOpacities_P {
    // MARK: Properties
    /// Pressed opacity level
    public var pressedOpacity: Double

    // MARK: Initializers
    /// Initializes group with values
    public init(
        pressedOpacity: Double
    ) {
        self.pressedOpacity = pressedOpacity
    }
    
    /// Instance of group with clear values
    public static var clear: Self {
        .init(
            pressedOpacity: 0
        )
    }
    
    /// Instance of group with solid values
    public static var solid: Self {
        .init(
            pressedOpacity: 1
        )
    }
}

// MARK: - Disabled
/// Opacity level group containing values for `disabled` state
public struct StateOpacities_D {
    // MARK: Properties
    /// Disabled opacity level
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values
    public init(
        disabledOpacity: Double
    ) {
        self.disabledOpacity = disabledOpacity
    }
    
    /// Instance of group with clear values
    public static var clear: Self {
        .init(
            disabledOpacity: 0
        )
    }
    
    /// Instance of group with solid values
    public static var solid: Self {
        .init(
            disabledOpacity: 1
        )
    }
    
    // MARK: Mapping
    func `for`(_ state: VWheelPickerState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VTextFieldState) -> Double {
        switch state {
        case .enabled: return 1
        case .focused: return 1
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VAccordionState) -> Double {
        switch state {
        case .collapsed: return 1
        case .expanded: return 1
        case .disabled: return disabledOpacity
        }
    }
}

// MARK: - Pressed, Disabled
/// Opacity level group containing values for `pressed` and `disabled` states
public struct StateOpacities_PD {
    // MARK: Properties
    /// Pressed opacity level
    public var pressedOpacity: Double
    
    /// Disabled opacity level
    public var disabledOpacity: Double
    
    // MARK: Initializers
    /// Initializes group with values
    public init(
        pressedOpacity: Double,
        disabledOpacity: Double
    ) {
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
    
    /// Instance of group with clear values
    public static var clear: Self {
        .init(
            pressedOpacity: 0,
            disabledOpacity: 0
        )
    }
    
    /// Instance of group with solid values
    public static var solid: Self {
        .init(
            pressedOpacity: 1,
            disabledOpacity: 1
        )
    }

    // MARK: Mapping
    func `for`(_ state: VPrimaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        case .loading: return disabledOpacity
        }
    }
    
    func `for`(_ state: VSecondaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VSquareButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VChevronButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VCloseButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VToggleInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return pressedOpacity
        case .on: return 1
        case .pressedOn: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VCheckBoxInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return pressedOpacity
        case .on: return 1
        case .pressedOn: return pressedOpacity
        case .indeterminate: return 1
        case .pressedIndeterminate: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VRadioButtonInternalState) -> Double {
        switch state {
        case .off: return 1
        case .pressedOff: return pressedOpacity
        case .on: return 1
        case .pressedOn: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VSegmentedPickerState) -> Double {
        switch state {
        case .enabled: return 1
        case .disabled: return disabledOpacity
        }
    }
    
    func `for`(_ state: VSegmentedPickerRowState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return pressedOpacity
        case .disabled: return disabledOpacity
        }
    }
}
