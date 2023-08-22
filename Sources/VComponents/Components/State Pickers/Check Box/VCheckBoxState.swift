//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import Foundation
import VCore

// MARK: - V Toggle State
/// Enumeration that represents state, such as `off`, `on`, or `indeterminate`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VCheckBoxState = GenericState_OffOnIndeterminate

// MARK: - V Checkbox Internal State
/// Enumeration that represents state, such as `off`, `on`, `indeterminate`, `pressed`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VCheckBoxInternalState = GenericState_OffOnIndeterminatePressedDisabled
