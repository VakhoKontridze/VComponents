//
//  VNotificationParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

public import SwiftUI
import VCore

/// Parameters for presenting a `VNotification`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VNotificationParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public var id: UUID
    
    /// Appearance.
    public var appearance: VNotificationAppearance
    
    /// Image.
    public var image: Image?
    
    /// Title.
    public var title: String?
    
    /// Message.
    public var message: String?

    /// Attributes.
    public var attributes: [String: Any]
    
    // MARK: Parameters
    /// Initializes `VNotificationParameters`.
    public init(
        id: UUID = .init(),
        appearance: VNotificationAppearance = .init(),
        image: Image? = nil,
        title: String? = nil,
        message: String? = nil,
        attributes: [String: Any] = [:]
    ) {
        self.id = id
        self.appearance = appearance
        self.image = image
        self.title = title
        self.message = message
        self.attributes = attributes
    }
}
