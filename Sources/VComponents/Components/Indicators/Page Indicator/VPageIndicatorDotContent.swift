//
//  VPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

// MARK: - V Page Indicator Dot Content
enum VPageIndicatorDotContent<CustomContent> where CustomContent: View {
    case `default`
    case custom(content: () -> CustomContent)
}
