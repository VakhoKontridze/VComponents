import SwiftUI
import Testing
@testable import VComponents

@MainActor
struct VSliderValueBindingTests {
    @Test(arguments: [
        (0.0, 1.0, 0.5),
        (10.0, 20.0, 15.0),
        (0.0, 100.0, 50.0),
        (-20.0, -10.0, -15.0),
        (-10.0, 10.0, 0.0)
    ])
    func preservesRangeUnits(lower: Double, upper: Double, value: Double) {
        let progress = VSliderValueBinding.make(
            range: lower...upper,
            step: nil,
            value: .constant(value)
        )

        #expect(progress.wrappedValue == value)
    }

    @Test
    func readsExternalChangesWithoutRecreatingTheBinding() {
        var value = 15.0
        let progress = VSliderValueBinding.make(
            range: 10.0...20.0,
            step: nil,
            value: Binding(get: { value }, set: { value = $0 })
        )

        value = 18

        #expect(progress.wrappedValue == 18)
    }

    @Test
    func writesAndReadsInTheSameUnits() {
        var value = 15.0
        let progress = VSliderValueBinding.make(
            range: 10.0...20.0,
            step: nil,
            value: Binding(get: { value }, set: { value = $0 })
        )

        progress.wrappedValue = 17

        #expect(value == 17)
        #expect(progress.wrappedValue == 17)
    }

    @Test(arguments: [(5.0, 10.0), (25.0, 20.0)])
    func clampsReadsWithoutMutatingTheSource(value initialValue: Double, expected: Double) {
        var value = initialValue
        let progress = VSliderValueBinding.make(
            range: 10.0...20.0,
            step: nil,
            value: Binding(get: { value }, set: { value = $0 })
        )

        #expect(progress.wrappedValue == expected)
        #expect(value == initialValue)
    }

    @Test
    func appliesStepInRangeUnitsFromTheLowerBound() {
        let progress = VSliderValueBinding.make(
            range: 11.0...21.0,
            step: 2,
            value: .constant(14.0)
        )

        #expect(progress.wrappedValue == 15)
    }

    @Test
    func retainsFractionalStepForTheDefaultRange() {
        let progress = VSliderValueBinding.make(
            range: 0.0...1.0,
            step: 0.25,
            value: .constant(0.6)
        )

        #expect(progress.wrappedValue == 0.5)
    }

    @Test
    func supportsFloatBindings() {
        var value: Float = 15
        let progress = VSliderValueBinding.make(
            range: Float(10)...20,
            step: nil,
            value: Binding(get: { value }, set: { value = $0 })
        )

        #expect(progress.wrappedValue == 15)
        progress.wrappedValue = 17.5
        #expect(value == 17.5)
        #expect(progress.wrappedValue == 17.5)
    }

    @Test
    func preservesUnclampedWrites() {
        var value = 15.0
        let progress = VSliderValueBinding.make(
            range: 10.0...20.0,
            step: nil,
            value: Binding(get: { value }, set: { value = $0 })
        )

        progress.wrappedValue = 25

        #expect(value == 25)
        #expect(progress.wrappedValue == 20)
    }

    @Test
    func usesTheLowerBoundForADegenerateRange() {
        let progress = VSliderValueBinding.make(
            range: 10.0...10.0,
            step: nil,
            value: .constant(10.0)
        )

        #expect(progress.wrappedValue == 10)
    }

    @Test(arguments: [Double.nan, Double.infinity, -Double.infinity])
    func usesTheLowerBoundForNonFiniteValues(_ value: Double) {
        let progress = VSliderValueBinding.make(
            range: 10.0...20.0,
            step: nil,
            value: .constant(value)
        )

        #expect(progress.wrappedValue == 10)
    }
}
