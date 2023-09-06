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
public struct ModalComponentSizes<ModalSize> {
    // MARK: Properties
    /// Portrait size .
    public var portrait: ModalSize

    /// Landscape size.
    public var landscape: ModalSize

    // MARK: Initializers
    /// Initializes `ModalComponentSizes` with sizes.
    public init(
        portrait: ModalSize,
        landscape: ModalSize
    ) {
        self.portrait = portrait
        self.landscape = landscape
    }

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
            return portrait
        } else {
            return landscape
        }
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    func current(
        _interfaceOrientation interfaceOrientation: _InterfaceOrientation
    ) -> ModalSize {
        switch interfaceOrientation {
        case .portrait: return portrait
        case .landscape: return landscape
        }
    }
}

extension ModalComponentSizes: Equatable where ModalSize: Equatable {}

// MARK: - Standard Modal Component Size
/// Model that represents standard modal component size with width and height.
public struct StandardModalComponentSize: Equatable {
    // MARK: Properties
    /// Width.
    public var width: ModalComponentDimension

    /// Height.
    public var height: ModalComponentDimension

    // MARK: Initializers
    /// Initializes `StandardModalComponentSize` with width and height.
    public init(
        width: ModalComponentDimension,
        height: ModalComponentDimension
    ) {
        self.width = width
        self.height = height
    }
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
        case .absolute(let dimension): return dimension
        case .fraction(let fraction): return fraction
        }
    }

    /// Converts `ModalComponentDimension` to absolute dimension.
    public func toAbsolute(
        in containerDimension: CGFloat
    ) -> CGFloat {
        switch self {
        case .absolute(let dimension): return dimension
        case .fraction(let fraction): return fraction * containerDimension
        }
    }
}
