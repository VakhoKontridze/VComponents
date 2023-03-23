//
//  VCheckBoxState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Toggle State
/// Enum that represents state, such as `off`, `on`, or `indeterminate`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VCheckBoxState = GenericState_OffOnIndeterminate

// MARK: - V Checkbox Internal State
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
typealias VCheckBoxInternalState = GenericState_OffOnIndeterminatePressedDisabled
