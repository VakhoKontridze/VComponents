//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

@Uninitializable
nonisolated struct ImageBook {
    @Uninitializable
    nonisolated struct Symbols { // Asset symbols are main-actor-isolated
        @MainActor static let checkmark: Image = .init(.checkmark).renderingMode(.template)
        @MainActor static let chevronUp: Image = .init(.chevronUp).renderingMode(.template)
        @MainActor static let eye: Image = .init(.eye).renderingMode(.template)
        @MainActor static let eyeCrossed: Image = .init(.eyeCrossed).renderingMode(.template)
        @MainActor static let line: Image = .init(.line).renderingMode(.template)
        @MainActor static let magnifyGlass: Image = .init(.magnifyGlass).renderingMode(.template)
        @MainActor static let xmark: Image = .init(.xmark).renderingMode(.template)
    }
}
