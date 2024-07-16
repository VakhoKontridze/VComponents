//
//  VNotificationContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.24.
//

import SwiftUI

// MARK: - V Notification Content
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VNotificationContent<Content> where Content: View {
    case iconTitleMessage(icon: Image?, title: String?, message: String?)
    case content(content: () -> Content)
}
