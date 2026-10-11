import SwiftUI
import VCore

enum VSliderGeometry {
    static func value(
        location: CGPoint,
        size: CGSize,
        range: ClosedRange<Double>,
        step: Double?,
        direction: LayoutDirectionOmni,
        layoutDirection: LayoutDirection
    ) -> Double? {
        let coordinate: Double = location.coordinate(isX: direction.isHorizontal)
        guard let dimension: CGFloat = size.dimension(isWidth: direction.isHorizontal).nonZero else { return nil }

        // Drag coordinates are physical; only horizontal leading/trailing edges mirror in RTL.
        let isReversed: Bool = direction.isReversed != (direction.isHorizontal && layoutDirection.isRightToLeft)
        let fraction: Double = (coordinate / dimension)
            .invertedFromMax(
                1,
                if: isReversed
            )

        return (fraction * range.boundRange + range.lowerBound)
            .clamped(to: range, step: step)
    }
}
