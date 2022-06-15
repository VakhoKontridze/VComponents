//
//  ModalSizes.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import Foundation

// MARK: Modal Sizes
/// Model that describes modal sizes.
public struct ModalSizes<ModalSizeMeasurement>
    where ModalSizeMeasurement: ScreenRelativeSizeMeasurement
{
    // MARK: Properties
    /// Portrait size configuration.
    public let portrait: SizeConfiguration
    
    /// Landscape size configuration.
    public let landscape: SizeConfiguration
    
    /// Current size configuration based on interface orientation.
    public var current: SizeConfiguration? {
        switch DeviceInterfaceOrientation() {
        case nil: return nil
        case .portrait: return portrait
        case .landscape: return landscape
        }
    }
    
    var _current: SizeConfiguration {
        current ?? portrait
    }
    
    // MARK: Initializers
    /// Initializes `ModalSizes` with size configurations.
    public init(portrait: SizeConfiguration, landscape: SizeConfiguration) {
        self.portrait = portrait
        self.landscape = landscape
    }
}

// MARK: - Size Configuration
extension ModalSizes {
    /// Enum that describes state, either `point` or `relative`.
    public enum SizeConfiguration {
        // MARK: Cases
        /// Size configuration with fixed sizes represented in points.
        case point(ModalSizeMeasurement)
        
        /// Size configuration with ratios relative to screen sizes.
        case fraction(ModalSizeMeasurement)
        
        // MARK: Properties
        /// Size configuration represented in points.
        ///
        /// `point` configuration is returned directly,
        /// while `relative` configurations are multiplied by the screen size.
        public var size: ModalSizeMeasurement {
            switch self {
            case .point(let size): return size
            case .fraction(let size): return ModalSizeMeasurement.relativeMeasurementToPoints(size)
            }
        }
    }
}

// MARK: - Hashable, Equatable, Comparable
extension ModalSizes: Hashable where ModalSizeMeasurement: Hashable {}

extension ModalSizes: Equatable where ModalSizeMeasurement: Equatable {}

extension ModalSizes: Comparable where ModalSizeMeasurement: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.portrait, lhs.landscape) < (rhs.portrait, lhs.landscape)
    }
}

extension ModalSizes.SizeConfiguration: Hashable where ModalSizeMeasurement: Hashable {}

extension ModalSizes.SizeConfiguration: Equatable where ModalSizeMeasurement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.point(let lhs), .point(let rhs)): return lhs == rhs
        case (.point(let lhs), .fraction(let rhs)): return lhs == ModalSizeMeasurement.relativeMeasurementToPoints(rhs)
        case (.fraction(let lhs), .point(let rhs)): return ModalSizeMeasurement.relativeMeasurementToPoints(lhs) == rhs
        case (.fraction(let lhs), .fraction(let rhs)): return lhs == rhs
        }
    }
}

extension ModalSizes.SizeConfiguration: Comparable where ModalSizeMeasurement: Comparable {}
