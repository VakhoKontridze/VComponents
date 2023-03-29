//
//  VAlertContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - V Alert Content
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VAlertContent<Content> where Content: View {
    case empty
    case content(content: () -> Content)
}
