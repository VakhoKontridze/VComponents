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
        static let checkmark: Image = .init(.checkmark).renderingMode(.template) // Mirrored for RTL languages
        static let chevronUp: Image = .init(.chevronUp).renderingMode(.template)
        static let eye: Image = .init(.eye).renderingMode(.template)
        static let eyeCrossed: Image = .init(.eyeCrossed).renderingMode(.template)
        static let line: Image = .init(.line).renderingMode(.template)
        static let magnifyGlass: Image = .init(.magnifyGlass).renderingMode(.template) // Not mirrored, like `UISearchBar.searchable(text:)`
        static let xmark: Image = .init(.xmark).renderingMode(.template)
    }
}
