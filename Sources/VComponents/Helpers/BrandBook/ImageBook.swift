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
    public static var checkBoxCheckMarkOn: Image = .init(module: "CheckMark.On").template // Mirrored for RTL languages
    
    /// Checkmark for `indeterminate` state in `VCheckBox`.
    public static var checkBoxCheckMarkIndeterminate: Image = .init(module: "CheckMark.Indeterminate").template
    
    /// Decrement icon for `VStepper`.
    public static var stepperDecrement: Image = .init(module: "Minus").template
    
    /// Increment icon for `VStepper`.
    public static var stepperIncrement: Image = .init(module: "Plus").template
    
    /// Search icon for `VTextField`.
    public static var textFieldSearch: Image = .init(module: "Search").template // Doesn't mirror, like `UISearchBar/.searchable(text:)`
    
    /// Visibility off icon for `VTextField`.
    public static var textFieldVisibilityOff: Image = .init(module: "Visibility.Off").template // Mirrored for RTL languages
    
    /// Visibility on icon for `VTextField`
    public static var textFieldVisibilityOn: Image = .init(module: "Visibility.On").template
    
    /// General close or clear button x-mark icon.
    public static var xMark: Image = .init(module: "XMark").template
    
    /// General chevron icon.
    public static var chevronUp: Image = .init(module: "Chevron.Up").template
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    fileprivate init(module name: String) {
        self.init(name, bundle: .module)
    }
    
    fileprivate var template: Self {
        self
            .renderingMode(.template)
    }
}
