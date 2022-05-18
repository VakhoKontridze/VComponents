//
//  View.CustomViewFrames.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10/28/21.
//

import SwiftUI

// MARK: - Custom View Frames
extension View {
    /// Positions this view within an invisible frame with the specified dimension.
    ///
    /// Usage Example:
    ///
    ///     var body: some View {
    ///         Color.accentColor
    ///             .frame(dimension: 100)
    ///     }
    ///
    public func frame(
        dimension: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            width: dimension, height: dimension,
            alignment: alignment
        )
    }
    
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Usage Example:
    ///
    ///     var body: some View {
    ///         Color.accentColor
    ///             .frame(size: .init(width: 100, height: 100))
    ///     }
    ///
    public func frame(
        size: CGSize,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            width: size.width,
            height: size.height,
            alignment: alignment
        )
    }
    
    /// Positions this view within an invisible frame with the specified size configuration.
    ///
    /// Usage Example:
    ///
    ///     var body: some View {
    ///         Color.accentColor
    ///             .frame(size: .init(
    ///                 min: .zero,
    ///                 ideal: .init(dimension: 100),
    ///                 max: .init(dimension: .infinity)
    ///             ))
    ///     }
    ///
    public func frame(
        size: SizeConfiguration,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            minWidth: size.min.width,
            idealWidth: size.ideal.width,
            maxWidth: size.max.width,
            
            minHeight: size.min.height,
            idealHeight: size.ideal.height,
            maxHeight: size.max.height,
            
            alignment: alignment
        )
    }
}

// MARK: - Size Configuration
/// Object containing minimum, ideal, and maximum size configurations.
public struct SizeConfiguration {
    // MARK: Properties
    /// Minimum size.
    public var min: CGSize
    
    /// Ideal size.
    public var ideal: CGSize
    
    /// Maximum size.
    public var max: CGSize
    
    // MARK: Initializers
    /// Initializes `SizeConfiguration`.
    public init(min: CGSize, ideal: CGSize, max: CGSize) {
        self.min = min
        self.ideal = ideal
        self.max = max
    }
}
