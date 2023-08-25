//
//  VRollingCounterComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation

// MARK: - V Rolling Counter Component (Digit)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct VRollingCounterDigitComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let digit: Int
    var stringRepresentation: String { .init(digit) }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String? = nil, // If `nil`, new one will be generated
        digit: Int,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.digit = digit
        self.isHighlighted = isHighlighted
    }
}

// MARK: - V Rolling Counter Component (Fraction Digit)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct VRollingCounterFractionDigitComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let digit: Int
    var stringRepresentation: String { .init(digit) }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String? = nil, // If `nil`, new one will be generated
        digit: Int,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.digit = digit
        self.isHighlighted = isHighlighted
    }
}

// MARK: - V Rolling Counter Component (Grouping Separator)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct VRollingCounterGroupingSeparatorComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let value: String
    var stringRepresentation: String { value }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String? = nil, // If `nil`, new one will be generated
        value: String,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.value = value
        self.isHighlighted = isHighlighted
    }
}

// MARK: - V Rolling Counter Component (Decimal Separator)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct VRollingCounterDecimalSeparatorComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let value: String
    var stringRepresentation: String { value }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String? = nil, // If `nil`, new one will be generated
        value: String,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.value = value
        self.isHighlighted = isHighlighted
    }
}
