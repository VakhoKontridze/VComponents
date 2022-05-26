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
    public static var checkBoxCheckMarkOn: Image = .init(templateComponentAsset: "CheckMark.On")
    
    /// Checkmark for `indeterminate` state in `VCheckBox`.
    public static var checkBoxCheckMarkIndeterminate: Image = .init(templateComponentAsset: "CheckMark.Indeterminate")
    
    /// Decrement icon for `VStepper`.
    public static var stepperDecrement: Image = .init(templateComponentAsset: "Minus")
    
    /// Increment icon for `VStepper`.
    public static var stepperIncrement: Image = .init(templateComponentAsset: "Plus")
    
    /// Search icon for `VTextField`.
    public static var textFieldSearch: Image = .init(templateComponentAsset: "Search")
    
    /// Visibility off icon for `VTextField`.
    public static var textFieldVisibilityOff: Image = .init(templateComponentAsset: "Visibility.Off")
    
    /// Visibility on icon for `VTextField`
    public static var textFieldVisibilityOn: Image = .init(templateComponentAsset: "Visibility.On")
    
    /// General close or clear button x-mark icon.
    public static var xMark: Image = .init(templateComponentAsset: "XMark")
    
    /// General chevron icon.
    public static var chevronUp: Image = .init(templateComponentAsset: "Chevron.Up")
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    fileprivate init(componentAsset name: String) {
        self = Image(name, bundle: .module)
    }
    
    fileprivate init(templateComponentAsset name: String) {
        self = .init(componentAsset: name).renderingMode(.template)
    }
}
