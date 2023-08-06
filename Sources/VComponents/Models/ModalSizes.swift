//
//  ModalSizes.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import Foundation
import VCore

// MARK: Modal Sizes
/// Model that represents modal sizes.
public struct ModalSizes<ModalSizeMeasurement>
    where ModalSizeMeasurement: ScreenRelativeSizeMeasurement
{
    // MARK: Properties
    /// Portrait size configuration.
    public var portrait: SizeConfiguration
    
    /// Landscape size configuration.
    public var landscape: SizeConfiguration
    
    // MARK: Initializers
    /// Initializes `ModalSizes` with size configurations.
    public init(
        portrait: SizeConfiguration,
        landscape: SizeConfiguration
    ) {
        self.portrait = portrait
        self.landscape = landscape
    }
    
    /// Initializes `ModalSizes` with size configuration.
    public init(
        _ configuration: SizeConfiguration
    ) {
        self.portrait = configuration
        self.landscape = configuration
    }

    // MARK: Current
    /// Current size configuration based on interface orientation.
    public func current(
        isPortrait: Bool
    ) -> SizeConfiguration {
        if isPortrait {
            return portrait
        } else {
            return landscape
        }
    }

    func current(
        _interfaceOrientation interfaceOrientation: _InterfaceOrientation
    ) -> SizeConfiguration {
        switch interfaceOrientation {
        case .portrait: return portrait
        case .landscape: return landscape
        }
    }
}

// MARK: - Size Configuration
extension ModalSizes {
    /// Enum that represents state, either `point` or `relative`.
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
        public func size(in screenSize: CGSize) -> ModalSizeMeasurement {
            switch self {
            case .point(let size): return size
            case .fraction(let size): return ModalSizeMeasurement.relativeMeasurementToPoints(size, in: screenSize)
            }
        }
    }
}
