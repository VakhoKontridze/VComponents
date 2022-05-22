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
    
    // MARK: Single Size Configuration
    /// Enum that describes state, either `point` or `relative`.
    public enum SizeConfiguration {
        // MARK: Cases
        /// Size configuration with fixed sizes represented in points.
        case point(ModalSizeMeasurement)
        
        /// Size configuration with ratios relative to screen sizes.
        case relative(ModalSizeMeasurement)
        
        // MARK: Properties
        /// Size configuration represented in points.
        ///
        /// `point` configuration is returned directly,
        /// while `relative` configurations are multiplied by the screen size.
        public var size: ModalSizeMeasurement {
            switch self {
            case .point(let size): return size
            case .relative(let relativeSize): return ModalSizeMeasurement.relativeMeasurementToPoints(relativeSize)
            }
        }
    }
}
