//
//  VSliderUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Slider UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VSliderUIModel {
    // MARK: Properties - Global
    /// Direction. Set to `leftToRight`.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Slider height, but width for vertical layout. Set to `10`.
    public var height: CGFloat = {
#if os(iOS)
        10
#elseif os(macOS)
        10
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Slider corner radius. Set to `5`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        5
#elseif os(macOS)
        5
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Body
    /// Indicates if body is draggable.
    /// Set to `false` on `iOS`.
    /// Set to `true` on `macOS`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var bodyIsDraggable: Bool = {
#if os(iOS)
        false
#elseif os(macOS)
        true
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Track
    /// Slider track colors.
    public var trackColors: StateColors = {
#if os(iOS)
        StateColors(
            enabled: Color.makeDynamic((230, 230, 230, 1), (45, 45, 45, 1)),
            disabled: Color.makeDynamic((245, 245, 245, 1), (35, 35, 35, 1))
        )
#elseif os(macOS)
        StateColors(
            enabled: Color.dynamic(light: Color.black.opacity(0.05), dark: Color.white.opacity(0.125)),
            disabled: Color.dynamic(light: Color.black.opacity(0.03), dark: Color.white.opacity(0.075))
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Progress
    /// Slider progress colors.
    public var progressColors: StateColors = .init(
        enabled: Color.blue,
        disabled: Color.blue.opacity(0.3)
    )

    /// Indicates if slider rounds progress view right-edge. Set to `true`.
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

    // MARK: Properties - Border
    /// Border width.
    /// Set to `0` point on `iOS`.
    /// Set to `1` pixel on `macOS`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#else
        fatalError() // Not supported
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = {
#if os(iOS)
        StateColors(Color.clear)
#elseif os(macOS)
        StateColors(
            enabled: Color.dynamic(light: Color.black.opacity(0.125), dark: Color.clear),
            disabled: Color.dynamic(light: Color.black.opacity(0.05), dark: Color.clear)
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Thumb
    /// Thumb dimension. Set to `20`.
    ///
    /// To hide thumb, set to `0`.
    public var thumbDimension: CGFloat = 20

    /// Thumb corner radius. Set to `10`.
    public var thumbCornerRadius: CGFloat = 10

    /// Thumb colors.
    public var thumbColors: StateColors = .init(Color.white)

    // MARK: Properties - Thumb Border
    /// Thumb border widths.
    /// Set to `0` point on `iOS`.
    /// Set to `1` pixel on `macOS`.
    ///
    /// To hide border, set to `0`.
    public var thumbBorderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb border colors.
    public var thumbBorderColors: StateColors = {
#if os(iOS)
        StateColors.clearColors
#elseif os(macOS)
        StateColors(
            enabled: Color.makeDynamic((200, 200, 200, 1), (100, 100, 100, 1)),
            disabled: Color.makeDynamic((230, 230, 230, 1), (70, 70, 70, 1))
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Thumb Shadow
    /// Thumb shadow colors.
    public var thumbShadowColors: StateColors = .init(
        enabled: Color.make((100, 100, 100, 0.5)),
        disabled: Color.make((100, 100, 100, 0.2))
    )

    /// Thumb shadow radius.
    /// Set to `2` on `iOS`.
    /// Set to `1` on `macOS`.
    public var thumbShadowRadius: CGFloat = {
#if os(iOS)
        2
#elseif os(macOS)
        1
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb shadow offset.
    /// Set to `(0, 2)` on `iOS`.
    /// Set to `(0, 1)` on `macOS`.
    public var thumbShadowOffset: CGPoint = {
#if os(iOS)
        CGPoint(x: 0, y: 2)
#elseif os(macOS)
        CGPoint(x: 0, y: 1)
#else
        fatalError() // Not supported
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

    /// Progress animation. Set to `nil`.
    public var progressAnimation: Animation? = nil

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
}
