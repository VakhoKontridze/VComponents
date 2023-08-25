//
//  VToggleButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation
import VCore

// MARK: - V Toggle Button State
/// Enumeration that represents state, such as `off` or `on`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VToggleButtonState = GenericState_OffOn

// MARK: - V Toggle Button Internal State
/// Enumeration that represents state, such as `off`, `on`, `pressed`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VToggleButtonInternalState = GenericState_OffOnPressedDisabled
