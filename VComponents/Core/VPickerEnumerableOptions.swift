//
//  VPickerEnumerableOptions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI

// MARK:- V Picker Enumerable Option
public protocol VPickerEnumerableOption: RawRepresentable, CaseIterable where RawValue == Int {
    associatedtype PickerSymbol: View
    var pickerSymbol: PickerSymbol { get }
}

// MARK:- V Picker Titled Enumerable Option
public protocol VPickerTitledEnumerableOption: RawRepresentable, CaseIterable where RawValue == Int {
    associatedtype S: StringProtocol
    var pickerTitle: S { get }
}
