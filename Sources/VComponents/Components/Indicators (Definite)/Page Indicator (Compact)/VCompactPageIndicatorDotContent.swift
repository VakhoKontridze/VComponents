//
//  VCompactPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

// MARK: - V Compact Page Indicator Dot Content
enum VCompactPageIndicatorDotContent<CustomDotContent> where CustomDotContent: View {
    case standard
    case custom(custom: (VCompactPageIndicatorDotInternalState, Int) -> CustomDotContent)
}
