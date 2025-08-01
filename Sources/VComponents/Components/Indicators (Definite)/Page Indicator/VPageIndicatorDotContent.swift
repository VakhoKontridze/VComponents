//
//  VPageIndicatorDotContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27.02.23.
//

import SwiftUI

enum VPageIndicatorDotContent<CustomDotContent> where CustomDotContent: View {
    case standard
    case custom(builder: (VPageIndicatorDotInternalState, Int) -> CustomDotContent)
}
