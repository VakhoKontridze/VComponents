//
//  StateOpacities.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI

// MARK:- Disabled
public struct StateOpacitiesD {
    public var disabledOpacity: Double
    
    public init(disabledOpacity: Double) {
        self.disabledOpacity = disabledOpacity
    }
}

extension StateOpacitiesD {
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

// MARK:- Pressed
public struct StateOpacitiesP {
    public var pressedOpacity: Double

    public init(pressedOpacity: Double) {
        self.pressedOpacity = pressedOpacity
    }
}

// MARK:- Pressed, Disabled
public struct StateOpacitiesPD {
    public var pressedOpacity: Double
    public var disabledOpacity: Double
    
    public init(pressedOpacity: Double, disabledOpacity: Double) {
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
}

extension StateOpacitiesPD {
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
        case .intermediate: return 1
        case .pressedIntermediate: return pressedOpacity
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
