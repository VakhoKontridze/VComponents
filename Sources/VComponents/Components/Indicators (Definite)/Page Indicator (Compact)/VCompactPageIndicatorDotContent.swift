//
//  VCompactPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

// MARK: - V Compact Page Indicator Dot Content
enum VCompactPageIndicatorDotContent<Content> where Content: View {
    case empty
    case content(content: (VCompactPageIndicatorDotInternalState, Int) -> Content)
}
