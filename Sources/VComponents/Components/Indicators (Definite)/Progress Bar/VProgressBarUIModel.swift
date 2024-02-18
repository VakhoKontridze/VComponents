//
//  VProgressBarUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore

// MARK: - V Progress Bar UI Model
/// Model that describes UI.
public struct VProgressBarUIModel {
    // MARK: Properties - Global
    /// Direction. Set to `leftToRight`.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Progress bar height, but width for vertical layout.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `13.5` on `watchOS`.
    /// Set to `10` on `visionOS`.
    public var height: CGFloat = {
#if os(iOS)
        10
#elseif os(macOS)
        10
#elseif os(tvOS)
        10
#elseif os(watchOS)
        13.5
#elseif os(visionOS)
        10
#endif
    }()

    // MARK: Properties - Corners
    /// Progress bar corner radius.
    /// Set to `5` on `iOS`.
    /// Set to `5` on `macOS`.
    /// Set to `5` on `tvOS`.
    /// Set to `6.55` on `watchOS`
    /// Set to `5` on `visionOS`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        5
#elseif os(macOS)
        5
#elseif os(tvOS)
        5
#elseif os(watchOS)
        6.75
#elseif os(visionOS)
        5
#endif
    }()

    /// Indicates if progress bar rounds progress view right-edge. Set to `true`.
    ///
    /// For RTL languages, this refers to left-edge.
    public var roundsProgressViewRightEdge: Bool = true

    var progressViewRoundedCorners: RectCorner {
        if roundsProgressViewRightEdge {
            .allCorners
        } else {
            []
        }
    }

    // MARK: Properties - Track
    /// Track color.
    public var trackColor: Color = {
#if os(iOS)
        Color.dynamic(Color(230, 230, 230, 1), Color(45, 45, 45, 1))
#elseif os(macOS)
        Color.dynamic(Color.black.opacity(0.05), Color.white.opacity(0.125))
#elseif os(tvOS)
        Color.dynamic(Color(135, 135, 135, 1), Color(90, 90, 90, 1))
#elseif os(watchOS)
        Color(90, 90, 90, 1)
#elseif os(visionOS)
        Color.white.opacity(0.2)
#endif
    }()

    // MARK: Properties - Progress
    /// Progress color.
    public var progressColor: Color = {
#if os(iOS)
        Color.blue
#elseif os(macOS)
        Color.blue
#elseif os(tvOS)
        Color.dynamic(Color(220, 220, 220, 1), Color(220, 220, 220, 1))
#elseif os(watchOS)
        Color.white
#elseif os(visionOS)
        Color.blue
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    /// Set to `0` point on `iOS`.
    /// Set to `1` pixel on `macOS`.
    /// Set to `0` point on `tvOS`.
    /// Set to `0` point on `watchOS`.
    /// Set to `0` point on `visionOS`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#elseif os(tvOS)
        PointPixelMeasurement.points(0)
#elseif os(watchOS)
        PointPixelMeasurement.points(0)
#elseif os(visionOS)
        PointPixelMeasurement.points(0)
#endif
    }()

    /// Border color.
    public var borderColor: Color = {
#if os(iOS)
        Color.clear
#elseif os(macOS)
        Color.dynamic(Color.black.opacity(0.125), Color.clear)
#elseif os(tvOS)
        Color.clear
#elseif os(watchOS)
        Color.clear
#elseif os(visionOS)
        Color.clear
#endif
    }()

    // MARK: Properties - Transition
    /// Indicates if `progress` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesProgressAnimation: Bool = true

    /// Progress animation. Set to `default`.
    public var progressAnimation: Animation? = .default
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
