//
//  VMenuLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - V Menu Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VMenuLabel<Content> where Content: View {
    case title(title: String)
    case icon(icon: Image)
    case content(content: (VMenuInternalState) -> Content)
}
