//
//  VTappableTextTextComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI

// MARK: - V Tappable Text Text Component UI Model
/// Model that describes UI.
public struct VTappableTextTextComponentUIModel {
    // MARK: Properties
    /// Color.
    public var color: Color = ColorBook.primary

    /// Font. Set to `body` (`17`).
    public var font: Font = .body

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
