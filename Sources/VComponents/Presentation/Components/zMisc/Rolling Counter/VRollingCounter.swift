//
//  VRollingCounter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import OSLog
import VCore

/// Text component that highlights change in a floating-absolute number.
///
///     @State private var value: Double = 10_000
///
///     var body: some View {
///         ZStack {
///             VRollingCounter(value: value)
///         }
///         .onAppear { isFirst in
///             if isFirst {
///                 changeValue()
///             }
///         }
///     }
///
///     private func changeValue() {
///         Task {
///             value += .random(in: -10...10)
///
///             do {
///                 try await Task.sleep(for: .seconds(1))
///             } catch {
///                 return
///             }
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
///         .onAppear { isFirst in
///             if isFirst {
///                 changeValue()
///             }
///         }
///     }
///
public struct VRollingCounter: View {
    // MARK: Properties - Appearance
    private let appearance: VRollingCounterAppearance

    // MARK: Properties - Value
    private let value: Double
    @State private var components: [any VRollingCounterComponentProtocol]?
    
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
        ZStack {
            if let components {
                HStack(
                    alignment: appearance.verticalAlignment,
                    spacing: appearance.spacing
                ) {
                    ForEach(components, id: \.id, content: digitView)
                }
                .clipped() // Prevents clipping from animations
            }
        }
        .onChange(of: value, onValueChange)
    }

    @ViewBuilder
    private func digitView(
        _ component: any VRollingCounterComponentProtocol
    ) -> some View {
        switch component {
        case let digit as VRollingCounterDigitComponent:
            Text(digit.stringRepresentation)
                .textConfiguration({
                    var configuration: TextConfiguration = appearance.digitTextConfiguration
                    if digit.isHighlighted, let highlightedColor { configuration.color = highlightedColor }
                    return configuration
                }())
                .padding(appearance.digitTextMargins)
                .offset(y: appearance.digitTextOffsetY)
                .transition({
                    guard let digitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: digitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let fractionDigit as VRollingCounterFractionDigitComponent:
            Text(fractionDigit.stringRepresentation)
                .textConfiguration({
                    var configuration: TextConfiguration = appearance.fractionDigitTextConfiguration
                    if fractionDigit.isHighlighted, let highlightedColor { configuration.color = highlightedColor }
                    return configuration
                }())
                .padding(appearance.fractionDigitTextMargins)
                .offset(y: appearance.fractionDigitTextOffsetY)
                .transition({
                    guard let fractionDigitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: fractionDigitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let groupingSeparator as VRollingCounterGroupingSeparatorComponent:
            Text(groupingSeparator.stringRepresentation)
                .textConfiguration({
                    var configuration: TextConfiguration = appearance.groupingSeparatorTextConfiguration
                    if groupingSeparator.isHighlighted, let highlightedColor { configuration.color = highlightedColor }
                    return configuration
                }())
                .padding(appearance.groupingSeparatorTextMargins)
                .offset(y: appearance.groupingSeparatorTextOffsetY)
                .transition(.identity)

        case let decimalSeparator as VRollingCounterDecimalSeparatorComponent:
            Text(decimalSeparator.stringRepresentation)
                .textConfiguration({
                    var configuration: TextConfiguration = appearance.decimalSeparatorTextConfiguration
                    if decimalSeparator.isHighlighted, let highlightedColor { configuration.color = highlightedColor }
                    return configuration
                }())
                .padding(appearance.decimalSeparatorTextMargins)
                .offset(y: appearance.decimalSeparatorTextOffsetY)
                .transition(.identity)

        default:
            EmptyView()
                .onAppear { isFirst in
                    if isFirst {
                        Logger.rollingCounter.critical("Unsupported 'VRollingCounterComponentProtocol' '\(String(describing: type(of: component)))' in 'VRollingCounter'")
                    }
                }
        }
    }

    // MARK: Actions
    private func onValueChange(
        from oldValue: Double,
        to newValue: Double
    ) {
        let newComponents: [any VRollingCounterComponentProtocol]? = {
            if
                let components,
                let newComponents: [any VRollingCounterComponentProtocol] = VRollingCounterFactory.components(
                    oldValue: oldValue,
                    oldComponents: components,
                    newValue: newValue,
                    appearance: appearance
                )
            {
                return newComponents
            }
                
            if
                let newComponents: [any VRollingCounterComponentProtocol] = VRollingCounterFactory.components(
                    value: newValue,
                    appearance: appearance
                )
            {
                return newComponents
            }
                
            return nil
        }()

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

                        if let components {
                            for i in components.indices {
                                self.components?[i].isHighlighted = false
                            }
                        }
                    }
                )
            }
        )
    }

    // MARK: Helpers
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
    
    // MARK: Types
    nonisolated private enum Operation {
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
}

nonisolated extension Edge {
    fileprivate init(verticalEdge: VerticalEdge) {
        switch verticalEdge {
        case .top: self = .top
        case .bottom: self = .bottom
        }
    }
}

nonisolated extension TextConfiguration {
    fileprivate func withColor(_ color: Color?) -> Self {
        if let color {
            var copy: Self = self
            copy.color = color
            return copy
            
        } else {
            return self
        }
    }
}

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

                    appearance.decimalSeparatorTextConfiguration.color = .secondary
                    appearance.decimalSeparatorTextOffsetY = -10

                    appearance.fractionDigitTextConfiguration.color = .secondary
                    appearance.fractionDigitTextConfiguration.font = Font.footnote.bold()
                    appearance.fractionDigitTextOffsetY = -2

                    return appearance
                }(),
                value: value
            )
        }
    }
}

#endif
