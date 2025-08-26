//
//  VRollingCounterFactory.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation
import OSLog
import VCore

struct VRollingCounterFactory {
    // MARK: Initializers
    private init() {}

    // MARK: Components
    static func components(
        value: Double,
        appearance: VRollingCounterAppearance
    ) -> [any VRollingCounterComponentProtocol]? {
        let numberFormatter: NumberFormatter = numberFormatter(
            appearance: appearance
        )

        guard
            let valueString: String = numberFormatter.string(fromDouble: value)
        else {
            Logger.rollingCounter.critical("Failed to convert '\(String(describing: type(of: value)))' to 'String' in 'VRollingCounter'")
            return nil
        }

        var components: [any VRollingCounterComponentProtocol] = []
        var hasPassedDecimalSeparator = false

        for char in valueString {
            let charStr: String = .init(char)

            if charStr == appearance.groupingSeparator {
                components.append(
                    VRollingCounterGroupingSeparatorComponent(
                        id: nil,
                        value: charStr
                    )
                )

            } else if charStr == appearance.decimalSeparator {
                guard !hasPassedDecimalSeparator else {
                    Logger.rollingCounter.critical("Multiple decimal separators used in 'VRollingCounter'")
                    return nil
                }

                components.append(
                    VRollingCounterDecimalSeparatorComponent(
                        id: nil,
                        value: charStr
                    )
                )
                hasPassedDecimalSeparator = true

            } else if
                char.isNumber,
                let digit: Int = .init(charStr)
            {
                if hasPassedDecimalSeparator {
                    components.append(
                        VRollingCounterFractionDigitComponent(
                            id: nil,
                            digit: digit
                        )
                    )
                } else {
                    components.append(
                        VRollingCounterDigitComponent(
                            id: nil,
                            digit: digit
                        )
                    )
                }

            } else {
                Logger.rollingCounter.critical("Invalid 'Character' '\(char)' used in 'VRollingCounter'")
                return nil
            }
        }

        return components
    }

    static func components(
        oldValue: Double,
        oldComponents: [any VRollingCounterComponentProtocol],
        newValue: Double,
        appearance: VRollingCounterAppearance
    ) -> [any VRollingCounterComponentProtocol]? {
        let numberFormatter: NumberFormatter = numberFormatter(
            appearance: appearance
        )

        guard
            let oldString: String = numberFormatter.string(fromDouble: oldValue),
            let newString: String = numberFormatter.string(fromDouble: newValue)
        else {
            return []
        }

        let firstChangedIndex: Int = oldString
            .enumerated()
            .first { (i, char) in char != newString[i] }?
            .offset ??
            newString.count - 1

        var components: [any VRollingCounterComponentProtocol] = []
        var hasPassedDecimalSeparator = false

        for (i, char) in newString.enumerated() {
            let charStr: String = .init(char)

            if charStr == appearance.groupingSeparator {
                let isHighlighted: Bool = {
                    guard appearance.groupingSeparatorTextIsHighlightable else { return false }

                    if appearance.highlightsOnlyTheAffectedCharacters {
                        return i+1 >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                components.append(
                    VRollingCounterGroupingSeparatorComponent(
                        id: isHighlighted ? nil : oldComponents[i].id,
                        value: charStr,
                        isHighlighted: isHighlighted
                    )
                )

            } else if charStr == appearance.decimalSeparator {
                guard !hasPassedDecimalSeparator else {
                    Logger.rollingCounter.critical("Multiple decimal separators used in 'VRollingCounter'")
                    return nil
                }

                let isHighlighted: Bool = {
                    guard appearance.decimalSeparatorTextIsHighlightable else { return false }

                    if appearance.highlightsOnlyTheAffectedCharacters {
                        return i+1 >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                components.append(
                    VRollingCounterDecimalSeparatorComponent(
                        id: isHighlighted ? nil : oldComponents[i].id,
                        value: charStr,
                        isHighlighted: isHighlighted
                    )
                )

                hasPassedDecimalSeparator = true

            } else if
                char.isNumber,
                let digit: Int = .init(charStr)
            {
                let isHighlighted: Bool = {
                    if appearance.highlightsOnlyTheAffectedCharacters {
                        return i >= firstChangedIndex
                    } else {
                        return true
                    }
                }()

                let id: String? = isHighlighted ? nil : oldComponents[i].id

                if hasPassedDecimalSeparator {
                    components.append(
                        VRollingCounterFractionDigitComponent(
                            id: id,
                            digit: digit,
                            isHighlighted: isHighlighted
                        )
                    )
                } else {
                    components.append(
                        VRollingCounterDigitComponent(
                            id: id,
                            digit: digit,
                            isHighlighted: isHighlighted
                        )
                    )
                }

            } else {
                Logger.rollingCounter.critical("Invalid 'Character' '\(char)' used in 'VRollingCounter'")
                return nil
            }
        }

        return components
    }

    // MARK: Number Formatter
    private static func numberFormatter(
        appearance: VRollingCounterAppearance
    ) -> NumberFormatter {
        let formatter: NumberFormatter = .init()

        formatter.locale = Locale(identifier: "en") // Prevents issues when casting non-Arabic numbers to `Int`

        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true

        formatter.minimumFractionDigits = appearance.hasFractionDigits ? appearance.minFractionDigits : 0
        formatter.maximumFractionDigits = appearance.hasFractionDigits ? appearance.maxFractionDigits : 0

        formatter.usesGroupingSeparator = appearance.hasGroupingSeparator
        formatter.groupingSeparator = appearance.hasGroupingSeparator ? appearance.groupingSeparator : nil

        formatter.decimalSeparator = appearance.hasFractionDigits ? appearance.decimalSeparator : nil

        return formatter
    }
}

extension NumberFormatter {
    fileprivate func string(fromDouble double: Double) -> String? {
        string(
            from: NSDecimalNumber(
                decimal: Decimal(
                    double
                )
            )
        )
    }
}
