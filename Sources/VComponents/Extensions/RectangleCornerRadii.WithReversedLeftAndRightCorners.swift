//
//  RectangleCornerRadii.WithReversedLeftAndRightCorners.swift
//
//
//  Created by Vakhtang Kontridze on 09.07.24.
//

import SwiftUI

// MARK: - Rectangle Corner Radii with Reversed Left and Right Corners
extension RectangleCornerRadii {
    func withReversedLeftAndRightCorners(
        _ condition: Bool = true
    ) -> Self {
        guard condition else { return self }

        return Self(
            topLeading: topTrailing,
            bottomLeading: bottomTrailing,
            bottomTrailing: bottomLeading,
            topTrailing: topLeading
        )
    }
}
