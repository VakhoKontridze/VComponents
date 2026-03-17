//
//  VCompactPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

enum VCompactPageIndicatorDotContent<CustomDotContent> where CustomDotContent: View {
    case standard
    case custom(builder: (VCompactPageIndicatorDotInternalState, Int) -> CustomDotContent)
}
