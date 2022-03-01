//
//  VPickableItems.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI

// MARK: - V Pickable Item
/// Allows enum to represent picker items in components.
public protocol VPickableItem: RawRepresentable, CaseIterable where RawValue == Int {} // FIXME: Remove

// MARK: - V Pickable Titled Item
/// Allows enum to represent picker items in components.
public protocol VPickableTitledItem: VPickableItem {
    var pickerTitle: String { get }
}
