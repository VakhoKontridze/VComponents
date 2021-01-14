//
//  VPickerEnumerableOptions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI

// MARK:- V Picker Enumerable Item
/// Allows enum to represent picker items in components, such as VSegmentedPicker, VWheelPicker, VDropDown, and VTabHeader
public protocol VPickerEnumerableItem: RawRepresentable, CaseIterable where RawValue == Int {}

// MARK:- V Picker Titled Enumerable Item
/// Allows enum to represent picker items components, such as VSegmentedPicker, VWheelPicker, VDropDown, and VTabHeader
public protocol VPickerTitledEnumerableItem: VPickerEnumerableItem {
    var pickerTitle: String { get }
}
