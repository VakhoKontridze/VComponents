//
//  VAlertContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - V Alert Content
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VAlertContent<Content> where Content: View {
    case empty
    case content(content: () -> Content)
}
