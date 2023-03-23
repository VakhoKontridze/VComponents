//
//  VToggleState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Toggle State
/// Enum that represents state, such as `off` or `on`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VToggleState = GenericState_OffOn

// MARK: - V Toggle Internal State
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
typealias VToggleInternalState = GenericState_OffOnPressedDisabled
