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
///         ZStack(content: {
///             VRollingCounter(value: value)
///         })
///         .onAppear(perform: changeValue)
///     }
///
///     private func changeValue() {
///         Task(operation: {
///             value += .random(in: -10...10)
///             changeValue()
///         })
///     }
///
/// Integer types can be represented by hiding fraction digits.
///
///     @State private var value: Int = 10_000
///
///     var body: some View {
///         ZStack(content: {
///             VRollingCounter(
///                 uiModel: {
///                     var uiModel: VRollingCounterUIModel = .init()
///                     uiModel.hasFractionDigits = false
///                     return uiModel
///                 }(),
///                 value: Double(value)
///             )
///         })
///         .onAppear(perform: changeValue)
///     }
///        
public struct VRollingCounter: View {
    // MARK: Properties - UI Model
    private let uiModel: VRollingCounterUIModel

    // MARK: Properties - Values
    private let value: Double
    @State private var components: [any VRollingCounterComponentProtocol]
    @State private var numberFormatter: NumberFormatter // Marked as `State` to persist value
    
    // MARK: Properties - Flags
    @State private var isIncrementing: Bool?

    // MARK: Initializers
    /// Initializes `VRollingCounter` with value.
    public init<V>(
        uiModel: VRollingCounterUIModel = .init(),
        value: V
    )
        where V: BinaryFloatingPoint
    {
        let value: Double = .init(value)

        let numberFormatter: NumberFormatter = VRollingCounterFactory.numberFormatter(
            uiModel: uiModel
        )

        self.uiModel = uiModel
        self.value = value
        self._components = State(
            wrappedValue: VRollingCounterFactory.components(
                value: value,
                uiModel: uiModel,
                numberFormatter: numberFormatter
            )
        )
        self._numberFormatter = State(wrappedValue: numberFormatter)
    }

    // MARK: Body
    public var body: some View {
        HStack(
            alignment: uiModel.verticalAlignment,
            spacing: uiModel.spacing,
            content: {
                ForEach(
                    components,
                    id: \.id,
                    content: digitView
                )
            }
        )
        // Prevents animation clipping
        .clipped()

        // No need for initial checks, as `VRollingCounterFactory` sets up everything in `init`.
        .onChange(of: value, perform: didChangeValue)
    }

    @ViewBuilder
    private func digitView(
        _ component: any VRollingCounterComponentProtocol
    ) -> some View {
        switch component {
        case let digit as VRollingCounterDigitComponent:
            Text(digit.stringRepresentation)
                .foregroundStyle(textColor(digit.isHighlighted, defaultValue: uiModel.digitTextColor))
                .font(uiModel.digitTextFont)
                .applyIfLet(uiModel.digitTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                .padding(uiModel.digitTextMargins)
                .offset(y: uiModel.digitTextOffsetY)
                .transition({
                    guard let digitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: digitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let fractionDigit as VRollingCounterFractionDigitComponent:
            Text(fractionDigit.stringRepresentation)
                .foregroundStyle(textColor(fractionDigit.isHighlighted, defaultValue: uiModel.fractionDigitTextColor))
                .font(uiModel.fractionDigitTextFont)
                .applyIfLet(uiModel.fractionDigitTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                .padding(uiModel.fractionDigitTextMargins)
                .offset(y: uiModel.fractionDigitTextOffsetY)
                .transition({
                    guard let fractionDigitTextRollingEdge else { return .identity }
                    let edge: Edge = .init(verticalEdge: fractionDigitTextRollingEdge)
                    return AnyTransition.push(from: edge)
                }())

        case let groupingSeparator as VRollingCounterGroupingSeparatorComponent:
            Text(groupingSeparator.stringRepresentation)
                .foregroundStyle(textColor(groupingSeparator.isHighlighted, defaultValue: uiModel.groupingSeparatorTextColor))
                .font(uiModel.groupingSeparatorTextFont)
                .applyIfLet(uiModel.groupingSeparatorTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                .padding(uiModel.groupingSeparatorTextMargins)
                .offset(y: uiModel.groupingSeparatorTextOffsetY)
                .transition(.identity)

        case let decimalSeparator as VRollingCounterDecimalSeparatorComponent:
            Text(decimalSeparator.stringRepresentation)
                .foregroundStyle(textColor(decimalSeparator.isHighlighted, defaultValue: uiModel.fractionDigitTextColor))
                .font(uiModel.decimalSeparatorTextFont)
                .applyIfLet(uiModel.decimalSeparatorTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                .padding(uiModel.decimalSeparatorTextMargins)
                .offset(y: uiModel.decimalSeparatorTextOffsetY)
                .transition(.identity)

        default:
            let _ = Logger.rollingCounter.critical("Unsupported 'VRollingCounterComponentProtocol' '\(String(describing: type(of: component)))' in 'VRollingCounter'")
            fatalError()
        }
    }

    // MARK: Actions
    private func didChangeValue(to newValue: Double) {
        let oldValue: Double = VRollingCounterFactory.value(
            components: components,
            numberFormatter: numberFormatter
        )

        let newComponents: [any VRollingCounterComponentProtocol] = VRollingCounterFactory.components(
            oldComponents: components,
            newValue: newValue,
            uiModel: uiModel,
            numberFormatter: numberFormatter
        )

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.highlightAnimation?.toSwiftUIAnimation,
                {
                    components = newComponents

                    isIncrementing = {
                        if newValue > oldValue {
                            true
                        } else if newValue < oldValue {
                            false
                        } else {
                            nil
                        }
                    }()
                },
                completion: {
                    withAnimation(
                        uiModel.dehighlightAnimation?.toSwiftUIAnimation,
                        {
                            isIncrementing = nil

                            for i in components.indices {
                                components[i].isHighlighted = false
                            }
                        }
                    )
                }
            )

        } else {
            withBasicAnimation(
                uiModel.highlightAnimation,
                body: {
                    components = newComponents

                    isIncrementing = {
                        if newValue > oldValue {
                            true
                        } else if newValue < oldValue {
                            false
                        } else {
                            nil
                        }
                    }()
                },
                completion: {
                    withAnimation(
                        uiModel.dehighlightAnimation?.toSwiftUIAnimation, {
                            isIncrementing = nil

                            for i in components.indices {
                                components[i].isHighlighted = false
                            }
                        }
                    )
                }
            )
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
        switch isIncrementing {
        case nil: Color.clear
        case false?: uiModel.decrementHighlightColor
        case true?: uiModel.incrementHighlightColor
        }
    }

    private var digitTextRollingEdge: VerticalEdge? {
        switch isIncrementing {
        case nil: nil
        case false?: uiModel.digitTextDecrementRollingEdge
        case true?: uiModel.digitTextIncrementRollingEdge
        }
    }

    private var fractionDigitTextRollingEdge: VerticalEdge? {
        switch isIncrementing {
        case nil: nil
        case false?: uiModel.fractionDigitTextDecrementRollingEdge
        case true?: uiModel.fractionDigitTextIncrementRollingEdge
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

#Preview(body: {
    struct ContentView: View {
        @State private var value: Double = 10_000

        var body: some View {
            PreviewContainer(content: {
                HStack(spacing: 20, content: {
                    Button( // No `VPlainButton` on all platforms
                        "-",
                        action: { value -= .random(in: 1...10) }
                    )

                    Button( // No `VPlainButton` on all platforms
                        "+",
                        action: { value += .random(in: 1...10) }
                    )
                })
                .padding(.top, 20)

                PreviewRow("Standard", content: {
                    VRollingCounter(value: value)
                })

                PreviewRow("No Fractions", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()
                            uiModel.hasFractionDigits = false
                            return uiModel
                        }(),
                        value: value
                    )
                })

                PreviewRow("No Grouping & No Fractions", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()
                            uiModel.hasGroupingSeparator = false
                            uiModel.hasFractionDigits = false
                            return uiModel
                        }(),
                        value: value
                    )
                })

                PreviewRow("No Highlight", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()
                            uiModel.incrementHighlightColor = nil
                            uiModel.decrementHighlightColor = nil
                            return uiModel
                        }(),
                        value: value
                    )
                })

                PreviewRow("Highlighted Symbols", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()
                            uiModel.groupingSeparatorTextIsHighlightable = true
                            uiModel.decimalSeparatorTextIsHighlightable = true
                            return uiModel
                        }(),
                        value: value
                    )
                })

                PreviewRow("Full Highlight", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()
                            uiModel.highlightsOnlyTheAffectedCharacters = false
                            uiModel.groupingSeparatorTextIsHighlightable = true
                            uiModel.decimalSeparatorTextIsHighlightable = true
                            return uiModel
                        }(),
                        value: value
                    )
                })

                PreviewRow("Custom", content: {
                    VRollingCounter(
                        uiModel: {
                            var uiModel: VRollingCounterUIModel = .init()

                            uiModel.decimalSeparatorTextColor = .secondary
                            uiModel.decimalSeparatorTextOffsetY = -10

                            uiModel.fractionDigitTextColor = .secondary
                            uiModel.fractionDigitTextFont = Font.footnote.bold()
                            uiModel.fractionDigitTextOffsetY = -2

                            return uiModel
                        }(),
                        value: value
                    )
                })
            })
        }
    }

    return ContentView()
})

#endif
