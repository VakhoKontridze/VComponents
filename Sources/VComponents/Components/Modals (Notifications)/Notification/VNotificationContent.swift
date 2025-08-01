//
//  VNotificationContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.24.
//

import SwiftUI

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VNotificationContent<CustomContent> where CustomContent: View {
    case imageAndTitleAndMessage(image: Image?, title: String?, message: String?)
    case custom(builder: () -> CustomContent)
}
