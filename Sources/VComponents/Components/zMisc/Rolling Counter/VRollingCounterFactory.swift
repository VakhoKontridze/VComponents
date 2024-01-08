//
//  VRollingCounterFactory.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation
import VCore

// MARK: - V Rolling Counter Factory
@NonInitializable
struct VRollingCounterFactory {
    // MARK: Components
    static func components(
        value: Double,
        uiModel: VRollingCounterUIModel,
        numberFormatter: NumberFormatter
    ) -> [any VRollingCounterComponentProtocol] {
        guard
            let valueString: String = numberFormatter.string(fromDouble: value)
        else {
            fatalError()
        }

        var components: [any VRollingCounterComponentProtocol] = []
        var hasPassedDecimalSeparator = false

        for char in valueString {
            let charStr: String = .init(char)

            if charStr == uiModel.groupingSeparator {
                components.append(VRollingCounterGroupingSeparatorComponent(value: charStr))

            } else if charStr == uiModel.decimalSeparator {
                guard !hasPassedDecimalSeparator else { fatalError() }

                components.append(VRollingCounterDecimalSeparatorComponent(value: charStr))
                hasPassedDecimalSeparator = true

            } else if
                char.isNumber,
                let digit: Int = .init(charStr)
            {
                if hasPassedDecimalSeparator {
                    components.append(VRollingCounterFractionDigitComponent(digit: digit))
                } else {
                    components.append(VRollingCounterDigitComponent(digit: digit))
                }

            } else {
                fatalError()
            }
        }

        return components
    }

    static func components(
        oldComponents: [any VRollingCounterComponentProtocol],
        newValue: Double,
        uiModel: VRollingCounterUIModel,
        numberFormatter: NumberFormatter
    ) -> [any VRollingCounterComponentProtocol] {
        let oldValue: Double = value(
            components: oldComponents,
            numberFormatter: numberFormatter
        )

        guard
            let oldString: String = numberFormatter.string(fromDouble: oldValue),
            let newString: String = numberFormatter.string(fromDouble: newValue)
        else {
            return []
        }

        let firstChangedIndex: Int = oldString
            .enumerated()
            .first(where: { (i, char) in char != newString[i] })?
            .offset ??
            newString.count - 1

        var components: [any VRollingCounterComponentProtocol] = []
        var hasPassedDecimalSeparator = false

        for (i, char) in newString.enumerated() {
            let charStr: String = .init(char)

            if charStr == uiModel.groupingSeparator {
                let isHighlighted: Bool = {
                    guard uiModel.groupingSeparatorTextIsHighlightable else { return false }

                    if uiModel.highlightsOnlyTheAffectedCharacters {
                        return i+1 >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                components.append(VRollingCounterGroupingSeparatorComponent(
                    id: isHighlighted ? nil : oldComponents[i].id,
                    value: charStr,
                    isHighlighted: isHighlighted
                ))

            } else if charStr == uiModel.decimalSeparator {
                guard !hasPassedDecimalSeparator else { fatalError() }

                let isHighlighted: Bool = {
                    guard uiModel.decimalSeparatorTextIsHighlightable else { return false }

                    if uiModel.highlightsOnlyTheAffectedCharacters {
                        return i+1 >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                components.append(VRollingCounterDecimalSeparatorComponent(
                    id: isHighlighted ? nil : oldComponents[i].id,
                    value: charStr,
                    isHighlighted: isHighlighted
                ))

                hasPassedDecimalSeparator = true

            } else if
                char.isNumber,
                let digit: Int = .init(charStr)
            {
                let isHighlighted: Bool = {
                    if uiModel.highlightsOnlyTheAffectedCharacters {
                        return i >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                let id: String? = isHighlighted ? nil : oldComponents[i].id

                if hasPassedDecimalSeparator {
                    components.append(VRollingCounterFractionDigitComponent(
                        id: id,
                        digit: digit,
                        isHighlighted: isHighlighted
                    ))
                } else {
                    components.append(VRollingCounterDigitComponent(
                        id: id,
                        digit: digit,
                        isHighlighted: isHighlighted
                    ))
                }

            } else {
                fatalError()
            }
        }

        return components
    }

    // MARK: Value
    static func value(
        components: [any VRollingCounterComponentProtocol],
        numberFormatter: NumberFormatter
    ) -> Double {
        let string: String = components.map { $0.stringRepresentation }.joined()
        return numberFormatter.number(from: string)?.doubleValue ?? .zero
    }

    // MARK: Number Formatter
    static func numberFormatter(
        uiModel: VRollingCounterUIModel
    ) -> NumberFormatter {
        let formatter: NumberFormatter = .init()

        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true

        formatter.minimumFractionDigits = uiModel.hasFractionDigits ? uiModel.minFractionDigits : 0
        formatter.maximumFractionDigits = uiModel.hasFractionDigits ? uiModel.maxFractionDigits : 0

        formatter.usesGroupingSeparator = uiModel.hasGroupingSeparator
        formatter.groupingSeparator = uiModel.hasGroupingSeparator ? uiModel.groupingSeparator : nil

        formatter.decimalSeparator = uiModel.hasFractionDigits ? uiModel.decimalSeparator : nil

        return formatter
    }
}

// MARK: - Helpers
extension NumberFormatter {
    fileprivate func string(fromDouble double: Double) -> String? {
        string(from: NSDecimalNumber(decimal: Decimal(double)))
    }
}
