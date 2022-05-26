//
//  VAlertContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - V Alert Content
enum VAlertContent<CustomContent> where CustomContent: View {
    case empty
    case custom(content: () -> CustomContent)
}
