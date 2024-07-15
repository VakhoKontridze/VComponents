//
//  ModalComponentSizeGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import Foundation
import VCore

// MARK: - Modal Component Size Group
/// Modal component sizes.
@MemberwiseInitializable(
    comment: "/// Initializes `ModalComponentSizeGroup` with sizes."
)
public struct ModalComponentSizeGroup<ModalSize> {
    // MARK: Properties
    /// Portrait size .
    public var portrait: ModalSize

    /// Landscape size.
    public var landscape: ModalSize

    // MARK: Initializers
    /// Initializes `ModalComponentSizeGroup` with size.
    public init(
        _ size: ModalSize
    ) {
        self.portrait = size
        self.landscape = size
    }

    // MARK: Current
    /// Current size based on interface orientation.
    public func current(
        isPortrait: Bool
    ) -> ModalSize {
        if isPortrait {
            portrait
        } else {
            landscape
        }
    }

    func current(
        orientation: PlatformInterfaceOrientation
    ) -> ModalSize {
        switch orientation {
        case .portrait: portrait
        case .landscape: landscape
        }
    }
}

extension ModalComponentSizeGroup: Equatable where ModalSize: Equatable {}

// MARK: - Modal Component Size
/// Modal component size.
@MemberwiseInitializable(
    comment: "/// Initializes `ModalComponentSize` with width and height."
)
public struct ModalComponentSize: Equatable {
    /// Width.
    public var width: ModalComponentDimension

    /// Height.
    public var height: ModalComponentDimension
}

// MARK: - Modal Component Dimension
/// Enumeration that represents modal component dimension, either in points or fractions.
public enum ModalComponentDimension: Equatable {
    // MARK: Cases
    /// Absolute measurement.
    case absolute(CGFloat)

    /// Fraction measurement.
    case fraction(CGFloat)

    // MARK: Properties
    var value: CGFloat {
        switch self {
        case .absolute(let dimension): dimension
        case .fraction(let fraction): fraction
        }
    }

    /// Converts `ModalComponentDimension` to absolute dimension.
    public func toAbsolute(
        in containerDimension: CGFloat
    ) -> CGFloat {
        switch self {
        case .absolute(let dimension): dimension
        case .fraction(let fraction): fraction * containerDimension
        }
    }
}
