//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import Foundation
import VCore

// MARK: - V Check Box State
/// Enumeration that represents state, such as `off`, `on`, or `indeterminate`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public typealias VCheckBoxState = GenericState_OffOnIndeterminate

// MARK: - V Check Box Internal State
/// Enumeration that represents state, such as `off`, `on`, `indeterminate`, `pressed`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public typealias VCheckBoxInternalState = GenericState_OffOnIndeterminatePressedDisabled
