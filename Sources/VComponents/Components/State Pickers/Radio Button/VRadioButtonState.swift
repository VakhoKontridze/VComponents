//
//  VRadioButtonState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation
import VCore

// MARK: - V Radio Button State
/// Enum that represents state, such as `off` or `on`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VRadioButtonState = GenericState_OffOn

// MARK: - V Radio Button Internal State
/// Enum that represents state, such as `off`, `on`, `pressed`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VRadioButtonInternalState = GenericState_OffOnPressedDisabled
