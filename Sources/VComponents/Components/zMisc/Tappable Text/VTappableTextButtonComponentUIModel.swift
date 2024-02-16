//
//  VTappableTextButtonComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI

// MARK: - V Tappable Text Button Component UI Model
/// Model that describes UI.
public struct VTappableTextButtonComponentUIModel {
    // MARK: Properties
    /// Color.
    public var color: Color = {
#if os(iOS)
        Color.blue
#elseif os(macOS)
        Color.blue
#elseif os(tvOS)
        Color.blue
#elseif os(watchOS)
        Color.blue
#elseif os(visionOS)
        Color.primary
#endif
    }()

    /// Font. Set to `bold` `body`.
    public var font: Font = .body.bold()

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
