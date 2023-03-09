//
//  VDisclosureGroupState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group State
/// Enum that represents state, such as `collapsed` or `standard`.
@available(iOS 14.0, *)
public typealias VDisclosureGroupState = GenericState_CollapsedExpanded

// MARK: - V Disclosure Group Internal State
@available(iOS 14.0, *)
typealias VDisclosureGroupInternalState = GenericState_CollapsedExpandedDisabled
