//
//  RectangleCornerRadii+WithHorizontalCornersReversed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 09.07.24.
//

import SwiftUI

// MARK: - Rectangle Corner Radii + With Horizontal Corners Reversed
extension RectangleCornerRadii {
    func horizontalCornersReversed(
        if condition: Bool = true
    ) -> Self {
        guard condition else { return self }

        return RectangleCornerRadii(
            topLeading: topTrailing,
            bottomLeading: bottomTrailing,
            bottomTrailing: bottomLeading,
            topTrailing: topLeading
        )
    }
}
