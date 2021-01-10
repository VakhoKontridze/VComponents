//
//  VPickerEnumerableOptions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI

// MARK:- V Picker Enumerable Option
public protocol VPickerEnumerableOption: RawRepresentable, CaseIterable where RawValue == Int {}

// MARK:- V Picker Titled Enumerable Option
public protocol VPickerTitledEnumerableOption: VPickerEnumerableOption {
    var pickerTitle: String { get }
}
