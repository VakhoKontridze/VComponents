//
//  VPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

// MARK: - V Page Indicator Dot Content
enum VPageIndicatorDotContent<CustomDotContent> where CustomDotContent: View {
    case standard
    case custom(custom: (VPageIndicatorDotInternalState, Int) -> CustomDotContent)
}
