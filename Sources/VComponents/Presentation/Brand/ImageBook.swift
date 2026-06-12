//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

@Uninitializable
struct ImageBook {
    @Uninitializable
    struct Symbols {
        static let checkmark: Image = .init(.checkmark) // Mirrored for RTL languages
        static let chevronUp: Image = .init(.chevronUp)
        static let eye: Image = .init(.eye)
        static let eyeCrossed: Image = .init(.eyeCrossed)
        static let line: Image = .init(.line)
        static let magnifyGlass: Image = .init(.magnifyGlass) // Doesn't mirror, like `UISearchBar.searchable(text:)`
        static let xmark: Image = .init(.xmark)
    }
}
