//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - Image Book
/// Contains icons used throughout the library.
///
/// Properties can be re-set.
public struct ImageBook {
    // MARK: Properties
    /// Checkmark for `on` state in `VCheckBox`.
    public static var checkBoxCheckmarkOn: Image = .init(module: "Checkmark.On") // Mirrored for RTL languages
    
    /// Checkmark for `indeterminate` state in `VCheckBox`.
    public static var checkBoxCheckmarkIndeterminate: Image = .init(module: "Checkmark.Indeterminate")
    
    /// Decrement icon for `VStepper`.
    public static var stepperDecrement: Image = .init(module: "Minus")
    
    /// Increment icon for `VStepper`.
    public static var stepperIncrement: Image = .init(module: "Plus")
    
    /// Search icon for `VTextField`.
    public static var textFieldSearch: Image = .init(module: "Search") // Doesn't mirror, like `UISearchBar/.searchable(text:)`
    
    /// Visibility off icon for `VTextField`.
    public static var textFieldVisibilityOff: Image = .init(module: "Visibility.Off") // Mirrored for RTL languages
    
    /// Visibility on icon for `VTextField`
    public static var textFieldVisibilityOn: Image = .init(module: "Visibility.On")
    
    /// General close or clear button x-mark icon.
    public static var xMark: Image = .init(module: "XMark")
    
    /// General chevron icon.
    public static var chevronUp: Image = .init(module: "Chevron.Up")
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    fileprivate init(module name: String) {
        self.init(name, bundle: .module)
    }
}
