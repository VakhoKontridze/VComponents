//
//  PickableEnumeration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import Foundation

// MARK: - Pickable Enumeration
/// Allows enum to represent picker items in components.
public protocol PickableEnumeration: Hashable, CaseIterable {}

// MARK: - Pickable Titled Enumeration
/// Allows enum to represent picker items in components.
public protocol PickableTitledEnumeration: PickableEnumeration {
    /// Title used for item in picker components.
    var pickerTitle: String { get }
}
