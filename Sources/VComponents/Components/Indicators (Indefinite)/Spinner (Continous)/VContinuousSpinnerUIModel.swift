//
//  VContinuousSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Continuous Spinner UI Model
/// Model that describes UI.
public struct VContinuousSpinnerUIModel {
    // MARK: Properties
    /// Dimension.
    /// Set to `15` on `iOS`.
    /// Set to `25` on `macOS`.
    /// Set to `30` on `tvOS`.
    /// Set to `15` on `watchOS`.
    public var dimension: CGFloat = {
#if os(iOS)
        return 15
#elseif os(macOS)
        return 25
#elseif os(tvOS)
        return 30
#elseif os(watchOS)
        return 15
#endif
    }()

    /// Length of the colored part. Set to `0.75`.
    public var length: CGFloat = 0.75

    /// Thickness.
    /// Set to `2` on `watchOS`.
    /// Set to `3` on `macOS`.
    /// Set to `4` on `tvOS`.
    /// Set to `2` on `watchOS`.
    public var thickness: CGFloat = {
#if os(iOS)
        return 2
#elseif os(macOS)
        return 3
#elseif os(tvOS)
        return 4
#elseif os(watchOS)
        return 2
#endif
    }()

    /// Color.
    public var color: Color = ColorBook.accentBlue

    /// Animation. Set to `linear` with duration `0.75`.
    public var animation: Animation = .linear(duration: 0.75)
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
