//
//  VToggleState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import Foundation
import VCore

// MARK: - V Toggle State
/// Enumeration that represents state, such as `off` or `on`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public typealias VToggleState = GenericState_OffOn

// MARK: - V Toggle Internal State
/// Enumeration that represents state, such as `off`, `on`, `pressed`, or `disabled`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public typealias VToggleInternalState = GenericState_OffOnPressedDisabled
