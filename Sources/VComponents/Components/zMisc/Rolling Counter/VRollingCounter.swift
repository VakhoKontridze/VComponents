//
//  VRollingCounter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import OSLog
import VCore

// MARK: - V Rolling Counter
/// Text component that highlights change in a floating-absolute number.
///
///     @State private var value: Double = 10_000
///
///     var body: some View {
///         ZStack {
///             VRollingCounter(value: value)
///         }
///         .onFirstAppear(perform: changeValue)
///     }
///
///     private func changeValue() {
///         Task { @MainActor in
///             value += .random(in: -10...10)
///             try await Task.sleep(for: .seconds(1))
///             
///             changeValue()
///         }
///     }
///
/// Integer types can be represented by hiding fraction digits.
///
///     @State private var value: Int = 10_000
///
///     var body: some View {
///         ZStack {
///             VRollingCounter(
///                 appearance: {
///                     var appearance: VRollingCounterAppearance = .init()
///                     appearance.hasFractionDigits = false
///                     return appearance
///                 }(),
///                 value: Double(value)
///             )
///         }
///         .onFirstAppear(perform: changeValue)
///     }
///        
public struct VRollingCounter: View {
    // MARK: Properties - Appearance
    private let appearance: VRollingCounterAppearance

    // MARK: Properties - Value
    private let value: Double
    @State private var components: [any VRollingCounterComponentProtocol]
    
    // MARK: Properties - Operation
    @State private var operation: Operation = .none

    // MARK: Initializers
    /// Initializes `VRollingCounter` with value.
    public init<V>(
        appearance: VRollingCounterAppearance = .init(),
        value: V
    )
        where V: BinaryFloatingPoint
    {
        let value: Double = .init(value)

        self.appearance = appearance
        self.value = value
        self._components = State(
            wrappedValue: VRollingCounterFactory.components(
                value: value,
                appearance: appearance
            )
        )
    }

    // MARK: Body
    public var body: some View {
        HStack(
            alignment: appearance.verticalAlignment,
            spacing: appearance.spacing
        ) {
            ForEach(components, id: \.id, content: digitView)
        }
        .clipped() // Prevents clipping from animations

        .onChange(of: value, didChangeValue)
    }

    @ViewBuilder
    private func digitView(
        _ component: any VRollingCounterComponentProtocol
    ) -> some View {
        switch component {
        case let digit as VRollingCounterDigitComponent:
            Text(digit.stringRepresentation)
                .lineLimit(1)
                //.minimumScaleFactor(1)
                .foregroundStyle(textColor(digit.isHighlighted, defaultValue: appearance.digitTextColor))
                .font(appearance.digitTextFont)
                .applyIfLet(appearance.digitTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                .padding(appearance.digitTextMargins)
                .offset(y: appearance.digitTextOffsetY)
                .transition({
                    guard let digitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: digitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let fractionDigit as VRollingCounterFractionDigitComponent:
            Text(fractionDigit.stringRepresentation)
                .lineLimit(1)
                //.minimumScaleFactor(1)
                .foregroundStyle(textColor(fractionDigit.isHighlighted, defaultValue: appearance.fractionDigitTextColor))
                .font(appearance.fractionDigitTextFont)
                .applyIfLet(appearance.fractionDigitTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                .padding(appearance.fractionDigitTextMargins)
                .offset(y: appearance.fractionDigitTextOffsetY)
                .transition({
                    guard let fractionDigitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: fractionDigitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let groupingSeparator as VRollingCounterGroupingSeparatorComponent:
            Text(groupingSeparator.stringRepresentation)
                .lineLimit(1)
                //.minimumScaleFactor(1)
                .foregroundStyle(textColor(groupingSeparator.isHighlighted, defaultValue: appearance.groupingSeparatorTextColor))
                .font(appearance.groupingSeparatorTextFont)
                .applyIfLet(appearance.groupingSeparatorTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                .padding(appearance.groupingSeparatorTextMargins)
                .offset(y: appearance.groupingSeparatorTextOffsetY)
                .transition(.identity)

        case let decimalSeparator as VRollingCounterDecimalSeparatorComponent:
            Text(decimalSeparator.stringRepresentation)
                .lineLimit(1)
                //.minimumScaleFactor(1)
                .foregroundStyle(textColor(decimalSeparator.isHighlighted, defaultValue: appearance.fractionDigitTextColor))
                .font(appearance.decimalSeparatorTextFont)
                .applyIfLet(appearance.decimalSeparatorTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                .padding(appearance.decimalSeparatorTextMargins)
                .offset(y: appearance.decimalSeparatorTextOffsetY)
                .transition(.identity)

        default:
            let _ = Logger.rollingCounter.critical("Unsupported 'VRollingCounterComponentProtocol' '\(String(describing: type(of: component)))' in 'VRollingCounter'")
            fatalError()
        }
    }

    // MARK: Actions
    private func didChangeValue(
        from oldValue: Double,
        to newValue: Double
    ) {
        let newComponents: [any VRollingCounterComponentProtocol] = VRollingCounterFactory.components(
            oldValue: oldValue,
            oldComponents: components,
            newValue: newValue,
            appearance: appearance
        )

        withAnimation(
            appearance.highlightAnimation,
            {
                components = newComponents
                operation = Operation(oldValue: oldValue, newValue: newValue)
            },
            completion: {
                withAnimation(
                    appearance.dehighlightAnimation,
                    {
                        operation = .none

                        for i in components.indices {
                            components[i].isHighlighted = false
                        }
                    }
                )
            }
        )
    }

    // MARK: Operation
    private enum Operation {
        // MARK: Cases
        case none
        case decrement
        case increment

        // MARK: Initializers
        init(oldValue: CGFloat, newValue: CGFloat) {
            self = {
                if newValue > oldValue {
                    .increment
                } else if newValue < oldValue {
                    .decrement
                } else {
                    .none
                }
            }()
        }
    }

    // MARK: Helpers
    private func textColor(
        _ isHighlighted: Bool,
        defaultValue: Color
    ) -> Color {
        guard isHighlighted, let highlightedColor else { return defaultValue }
        return highlightedColor
    }

    private var highlightedColor: Color? {
        switch operation {
        case .none: Color.clear
        case .decrement: appearance.decrementHighlightColor
        case .increment: appearance.incrementHighlightColor
        }
    }

    private var digitTextRollingEdge: VerticalEdge? {
        switch operation {
        case .none: nil
        case .decrement: appearance.digitTextDecrementRollingEdge
        case .increment: appearance.digitTextIncrementRollingEdge
        }
    }

    private var fractionDigitTextRollingEdge: VerticalEdge? {
        switch operation {
        case .none: nil
        case .decrement: appearance.fractionDigitTextDecrementRollingEdge
        case .increment: appearance.fractionDigitTextIncrementRollingEdge
        }
    }
}

// MARK: - Helpers
extension Edge {
    fileprivate init(verticalEdge: VerticalEdge) {
        switch verticalEdge {
        case .top: self = .top
        case .bottom: self = .bottom
        }
    }
}

// MARK: - Preview
#if DEBUG

#Preview {
    @Previewable @State var value: Double = 10_000
    
    PreviewContainer {
        HStack(spacing: 20) {
            Button("-") { // No `VPlainButton` on all platforms
                value -= .random(in: 1...10)
            }
            
            Button("+") { // No `VPlainButton` on all platforms
                value += .random(in: 1...10)
            }
        }
        .padding(.top, 20)

        PreviewRow("Standard") {
            VRollingCounter(value: value)
        }

        PreviewRow("No Fractions") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()
                    appearance.hasFractionDigits = false
                    return appearance
                }(),
                value: value
            )
        }

        PreviewRow("No Grouping & No Fractions") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()
                    appearance.hasGroupingSeparator = false
                    appearance.hasFractionDigits = false
                    return appearance
                }(),
                value: value
            )
        }

        PreviewRow("No Highlight") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()
                    appearance.incrementHighlightColor = nil
                    appearance.decrementHighlightColor = nil
                    return appearance
                }(),
                value: value
            )
        }

        PreviewRow("Highlighted Symbols") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()
                    appearance.groupingSeparatorTextIsHighlightable = true
                    appearance.decimalSeparatorTextIsHighlightable = true
                    return appearance
                }(),
                value: value
            )
        }

        PreviewRow("Full Highlight") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()
                    appearance.highlightsOnlyTheAffectedCharacters = false
                    appearance.groupingSeparatorTextIsHighlightable = true
                    appearance.decimalSeparatorTextIsHighlightable = true
                    return appearance
                }(),
                value: value
            )
        }

        PreviewRow("Custom") {
            VRollingCounter(
                appearance: {
                    var appearance: VRollingCounterAppearance = .init()

                    appearance.decimalSeparatorTextColor = .secondary
                    appearance.decimalSeparatorTextOffsetY = -10

                    appearance.fractionDigitTextColor = .secondary
                    appearance.fractionDigitTextFont = Font.footnote.bold()
                    appearance.fractionDigitTextOffsetY = -2

                    return appearance
                }(),
                value: value
            )
        }
    }
}

#endif
