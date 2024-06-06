//
//  ModalComponentSizes.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import Foundation
import VCore

// MARK: - Modal Component Sizes
/// Model that represents modal component sizes.
@MemberwiseInitializable(
    comment: "/// Initializes `ModalComponentSizes` with sizes."
)
public struct ModalComponentSizes<ModalSize> {
    // MARK: Properties
    /// Portrait size .
    public var portrait: ModalSize

    /// Landscape size.
    public var landscape: ModalSize

    // MARK: Initializers
    /// Initializes `ModalComponentSizes` with size.
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

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    func current(
        _interfaceOrientation interfaceOrientation: _InterfaceOrientation
    ) -> ModalSize {
        switch interfaceOrientation {
        case .portrait: portrait
        case .landscape: landscape
        }
    }
}

extension ModalComponentSizes: Equatable where ModalSize: Equatable {}

// MARK: - Standard Modal Component Size
/// Model that represents standard modal component size with width and height.
@MemberwiseInitializable(
    comment: "/// Initializes `StandardModalComponentSize` with width and height."
)
public struct StandardModalComponentSize: Equatable {
    /// Width.
    public var width: ModalComponentDimension

    /// Height.
    public var height: ModalComponentDimension
}

// MARK: - Single Dimension Modal Component Size
/// Model that represents modal component size with a single dimension, either width or height.
public typealias SingleDimensionModalComponentSize = ModalComponentDimension

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
