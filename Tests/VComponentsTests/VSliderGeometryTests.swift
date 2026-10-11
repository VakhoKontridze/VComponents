import SwiftUI
import Testing
import VCore
@testable import VComponents

@MainActor
struct VSliderGeometryTests {
    @Test
    func reversedCustomRangePreservesTheMidpoint() {
        let value = VSliderGeometry.value(
            location: CGPoint(x: 100, y: 37),
            size: CGSize(width: 200, height: 60),
            range: 10...20,
            step: nil,
            direction: .rightToLeft,
            layoutDirection: .leftToRight
        )

        #expect(value == 15)
    }

    @Test(arguments: [
        (LayoutDirectionOmni.leftToRight, LayoutDirection.leftToRight, 12.5),
        (.rightToLeft, .leftToRight, 17.5),
        (.leftToRight, .rightToLeft, 17.5),
        (.rightToLeft, .rightToLeft, 12.5),
        (.topToBottom, .leftToRight, 12.0),
        (.bottomToTop, .leftToRight, 18.0),
        (.topToBottom, .rightToLeft, 12.0),
        (.bottomToTop, .rightToLeft, 18.0)
    ])
    func mapsDragCoordinatesForEachDirection(
        direction: LayoutDirectionOmni,
        layoutDirection: LayoutDirection,
        expected: Double
    ) {
        let value = VSliderGeometry.value(
            location: CGPoint(x: 50, y: 20),
            size: CGSize(width: 200, height: 100),
            range: 10...20,
            step: nil,
            direction: direction,
            layoutDirection: layoutDirection
        )

        #expect(value == expected)
    }

    @Test(arguments: [
        (LayoutDirectionOmni.leftToRight, LayoutDirection.leftToRight, 10.0, 20.0),
        (.rightToLeft, .leftToRight, 20.0, 10.0),
        (.leftToRight, .rightToLeft, 20.0, 10.0),
        (.rightToLeft, .rightToLeft, 10.0, 20.0),
        (.topToBottom, .leftToRight, 10.0, 20.0),
        (.bottomToTop, .leftToRight, 20.0, 10.0),
        (.topToBottom, .rightToLeft, 10.0, 20.0),
        (.bottomToTop, .rightToLeft, 20.0, 10.0)
    ])
    func mapsBothEndpointsForEachDirection(
        direction: LayoutDirectionOmni,
        layoutDirection: LayoutDirection,
        expectedAtOrigin: Double,
        expectedAtEnd: Double
    ) {
        let size = CGSize(width: 200, height: 100)
        let valueAtOrigin = VSliderGeometry.value(
            location: .zero,
            size: size,
            range: 10...20,
            step: nil,
            direction: direction,
            layoutDirection: layoutDirection
        )
        let valueAtEnd = VSliderGeometry.value(
            location: CGPoint(x: size.width, y: size.height),
            size: size,
            range: 10...20,
            step: nil,
            direction: direction,
            layoutDirection: layoutDirection
        )

        #expect(valueAtOrigin == expectedAtOrigin)
        #expect(valueAtEnd == expectedAtEnd)
    }

    @Test(arguments: [
        (0.0, 1.0, 0.75),
        (10.0, 20.0, 17.5),
        (-20.0, -10.0, -12.5),
        (-10.0, 10.0, 5.0)
    ])
    func mapsReversedDragAcrossRanges(lower: Double, upper: Double, expected: Double) {
        let value = VSliderGeometry.value(
            location: CGPoint(x: 50, y: 37),
            size: CGSize(width: 200, height: 60),
            range: lower...upper,
            step: nil,
            direction: .rightToLeft,
            layoutDirection: .leftToRight
        )

        #expect(value == expected)
    }

    @Test(arguments: [(-50.0, 20.0), (0.0, 20.0), (200.0, 10.0), (250.0, 10.0)])
    func clampsReversedDragsAtBothEndpoints(coordinate: Double, expected: Double) {
        let value = VSliderGeometry.value(
            location: CGPoint(x: coordinate, y: 37),
            size: CGSize(width: 200, height: 60),
            range: 10...20,
            step: nil,
            direction: .rightToLeft,
            layoutDirection: .leftToRight
        )

        #expect(value == expected)
    }

    @Test(arguments: [
        (21.0, 50.0, 19.0),
        (21.0, 100.0, 17.0),
        (20.0, 0.0, 20.0)
    ])
    func snapsReversedDragFromTheLowerBound(upper: Double, coordinate: Double, expected: Double) {
        let value = VSliderGeometry.value(
            location: CGPoint(x: coordinate, y: 37),
            size: CGSize(width: 200, height: 60),
            range: 11...upper,
            step: 2,
            direction: .rightToLeft,
            layoutDirection: .leftToRight
        )

        #expect(value == expected)
    }

    @Test(arguments: [
        (LayoutDirectionOmni.leftToRight, CGSize(width: 0, height: 100)),
        (.rightToLeft, CGSize(width: 0, height: 100)),
        (.topToBottom, CGSize(width: 200, height: 0)),
        (.bottomToTop, CGSize(width: 200, height: 0))
    ])
    func doesNotProduceValueForZeroDimension(direction: LayoutDirectionOmni, size: CGSize) {
        let value = VSliderGeometry.value(
            location: CGPoint(x: 50, y: 20),
            size: size,
            range: 10...20,
            step: nil,
            direction: direction,
            layoutDirection: .rightToLeft
        )

        #expect(value == nil)
    }

    @Test
    func writesSnappedRTLDragsThroughTheSourceBinding() throws {
        var value: Float = 11
        let progress = VSliderValueBinding.make(
            range: Float(11)...21,
            step: 2,
            value: Binding(get: { value }, set: { value = $0 })
        )
        let draggedValue = try #require(VSliderGeometry.value(
            location: CGPoint(x: 50, y: 37),
            size: CGSize(width: 200, height: 60),
            range: 11...21,
            step: 2,
            direction: .leftToRight,
            layoutDirection: .rightToLeft
        ))

        progress.wrappedValue = draggedValue

        #expect(value == 19)
        #expect(progress.wrappedValue == 19)
    }
}
