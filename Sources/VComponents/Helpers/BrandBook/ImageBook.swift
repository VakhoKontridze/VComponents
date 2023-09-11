//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - Image Book
struct ImageBook {
    // MARK: Properties
    static let checkmarkOn: Image = .init(module: "Checkmark.On") // Mirrored for RTL languages
    static let checkmarkIndeterminate: Image = .init(module: "Checkmark.Indeterminate")

    static let minus: Image = .init(module: "Minus")
    static let plus: Image = .init(module: "Plus")

    static let magnifyGlass: Image = .init(module: "MagnifyGlass") // Doesn't mirror, like `UISearchBar.searchable(text:)`

    static let visibilityOff: Image = .init(module: "Visibility.Off") // Mirrored for RTL languages
    static let visibilityOn: Image = .init(module: "Visibility.On")

    static let xMark: Image = .init(module: "XMark")

    static let chevronUp: Image = .init(module: "Chevron.Up")
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    fileprivate init(module name: String) {
        self.init(name, bundle: .module)
    }
}
