//
//  VMenuState.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import Foundation
import VCore

// MARK: - V Menu Internal State
/// Enum that represents state, such as `enabled` or `disabled`.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public typealias VMenuInternalState = GenericState_EnabledDisabled
