//
//  VPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

// MARK: - V Page Indicator Dot Content
enum VPageIndicatorDotContent<Content> where Content: View {
    case empty
    case content(content: (VPageIndicatorDotInternalState, Int) -> Content)
}
