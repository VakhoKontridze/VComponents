//
//  VToggleContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Toggle Content
enum VToggleContent<CustomContent> where CustomContent: View {
    case empty
    case title(title: String)
    case content(content: () -> CustomContent)
}
