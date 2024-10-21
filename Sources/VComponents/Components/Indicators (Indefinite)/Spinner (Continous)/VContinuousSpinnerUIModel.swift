//
//  VContinuousSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Continuous Spinner UI Model
/// Model that describes UI.
public struct VContinuousSpinnerUIModel: Sendable {
    // MARK: Properties
    /// Dimension.
    /// Set to `15` on `iOS`.
    /// Set to `25` on `macOS`.
    /// Set to `30` on `tvOS`.
    /// Set to `15` on `watchOS`.
    /// Set to `30` on `visionOS`.
    public var dimension: CGFloat = {
#if os(iOS)
        15
#elseif os(macOS)
        25
#elseif os(tvOS)
        30
#elseif os(watchOS)
        15
#elseif os(visionOS)
        30
#endif
    }()

    /// Length of the colored part. Set to `0.75`.
    public var length: CGFloat = 0.75

    /// Thickness.
    /// Set to `2` on `watchOS`.
    /// Set to `3` on `macOS`.
    /// Set to `4` on `tvOS`.
    /// Set to `2` on `watchOS`.
    /// Set to `4` on `visionOS`.
    public var thickness: CGFloat = {
#if os(iOS)
        2
#elseif os(macOS)
        3
#elseif os(tvOS)
        4
#elseif os(watchOS)
        2
#elseif os(visionOS)
        4
#endif
    }()

    /// Color.
    public var color: Color = {
#if os(iOS)
        Color.blue
#elseif os(macOS)
        Color.gray
#elseif os(tvOS)
        Color.gray
#elseif os(watchOS)
        Color.gray
#elseif os(visionOS)
        Color.gray
#endif
    }()

    /// Animation. Set to `linear` with duration `0.75`.
    public var animation: Animation = .linear(duration: 0.75)
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
