//
//  VRollingCounterComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation

struct VRollingCounterDigitComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let digit: Int
    var stringRepresentation: String { .init(digit) }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String?, // If `nil`, new one will be generated
        digit: Int,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.digit = digit
        self.isHighlighted = isHighlighted
    }
}

struct VRollingCounterFractionDigitComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let digit: Int
    var stringRepresentation: String { .init(digit) }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String?, // If `nil`, new one will be generated
        digit: Int,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.digit = digit
        self.isHighlighted = isHighlighted
    }
}

struct VRollingCounterGroupingSeparatorComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let value: String
    var stringRepresentation: String { value }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String?, // If `nil`, new one will be generated
        value: String,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.value = value
        self.isHighlighted = isHighlighted
    }
}

struct VRollingCounterDecimalSeparatorComponent: VRollingCounterComponentProtocol {
    // MARK: Properties
    let id: String

    let value: String
    var stringRepresentation: String { value }

    var isHighlighted: Bool

    // MARK: Initializers
    init(
        id: String?, // If `nil`, new one will be generated
        value: String,
        isHighlighted: Bool = false
    ) {
        self.id = id ?? Self.generateID()
        self.value = value
        self.isHighlighted = isHighlighted
    }
}
