//
//  VNotificationParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

import SwiftUI
import VCore

/// Parameters for presenting a `VNotification`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VNotificationParameters: Equatable {
    // MARK: Properties
    /// Appearance.
    public var appearance: VNotificationAppearance
    
    /// Image.
    public var image: Image?
    
    /// Title.
    public var title: String?
    
    /// Message.
    public var message: String?

    /// Attributes.
    public var attributes: [String: Any?]
    
    // MARK: Parameters
    /// Initializes `VNotificationParameters`.
    public init(
        appearance: VNotificationAppearance = .init(),
        image: Image? = nil,
        title: String? = nil,
        message: String? = nil,
        attributes: [String: Any?] = [:]
    ) {
        self.appearance = appearance
        self.image = image
        self.title = title
        self.message = message
        self.attributes = attributes
    }
    
    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        isEqual(lhs, to: rhs, by: \.appearance, \.image, \.title, \.message)
    }
}
