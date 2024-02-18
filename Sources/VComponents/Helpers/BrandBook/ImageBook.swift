//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - Image Book
@NonInitializable
struct ImageBook {
    static let checkmarkOn: Image = .init(.checkmarkOn) // Mirrored for RTL languages
    static let checkmarkIndeterminate: Image = .init(.checkmarkIndeterminate)

    static let magnifyGlass: Image = .init(.magnifyGlass) // Doesn't mirror, like `UISearchBar.searchable(text:)`

    static let visibilityOff: Image = .init(.visibilityOff) // Mirrored for RTL languages
    static let visibilityOn: Image = .init(.visibilityOn)

    static let xMark: Image = .init(.xMark)

    static let chevronUp: Image = .init(.chevronUp)
}
