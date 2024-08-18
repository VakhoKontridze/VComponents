//
//  RectangleCornerRadii+CornersAdjustedForDirection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 14.07.24.
//

import SwiftUI
import VCore

// MARK: - Rectangle Corner Radii + Corners Adjusted for Direction
extension RectangleCornerRadii {
    func cornersAdjustedForDirection(
        _ direction: LayoutDirectionOmni
    ) -> Self {
        switch direction {
        case .leftToRight:
            self

        case .rightToLeft:
            RectangleCornerRadii(
                topLeading: topTrailing,
                bottomLeading: bottomTrailing,
                bottomTrailing: bottomLeading,
                topTrailing: topLeading
            )

        case .topToBottom:
            RectangleCornerRadii(
                topLeading: bottomLeading,
                bottomLeading: bottomTrailing,
                bottomTrailing: topTrailing,
                topTrailing: topLeading
            )

        case .bottomToTop:
            RectangleCornerRadii(
                topLeading: topTrailing,
                bottomLeading: topLeading,
                bottomTrailing: bottomLeading,
                topTrailing: bottomTrailing
            )
        }
    }
}
