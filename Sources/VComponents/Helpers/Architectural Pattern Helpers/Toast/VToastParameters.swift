//
//  VToastParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

import Foundation
import VCore

/// Parameters for presenting a `VToast`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VToastParameters: Equatable {
    // MARK: Properties
    /// Appearance.
    public var appearance: VToastAppearance
    
    /// Text.
    public var text: String

    /// Attributes.
    public var attributes: [String: Any?]
    
    // MARK: Parameters
    /// Initializes `VToastParameters`.
    public init(
        appearance: VToastAppearance = .init(),
        text: String,
        attributes: [String: Any?] = [:]
    ) {
        self.appearance = appearance
        self.text = text
        self.attributes = attributes
    }
    
    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        isEqual(lhs, to: rhs, by: \.appearance, \.text)
    }
}
