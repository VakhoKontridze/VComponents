//
//  VToggleAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VToggleAppearance: Equatable, Sendable {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        appearance.animatesStateChange = false

        return appearance
    }

    /// Toggle size.
    public var size: CGSize = {
#if os(iOS)
        CGSize(width: 51, height: 31)
#elseif os(macOS)
        CGSize(width: 38, height: 22)
#elseif os(watchOS)
        CGSize(width: 34, height: 22)
#else
        fatalError() // Not supported
#endif
    }()

    /// Spacing between toggle and label.
    public var toggleAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#elseif os(watchOS)
        5
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    var cornerRadius: CGFloat { size.height }

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.dynamic(Color(220, 220, 220), Color(90, 90, 90)),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.dynamic(Color(240, 240, 240), Color(50, 50, 50))
        )
#elseif os(macOS)
        StateColors(
            off: Color.primary.opacity(0.1),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.primary.opacity(0.16),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.primary.opacity(0.03)
        )
#elseif os(watchOS)
        StateColors(
            off: Color(60, 60, 60),
            on: Color(25, 131, 255),
            pressedOff: Color(90, 90, 90),
            pressedOn: Color(36, 106, 186),
            disabled: Color(50, 50, 50)
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#elseif os(watchOS)
        PointPixelMeasurement.points(0)
#else
        fatalError() // Not supported
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = {
#if os(iOS)
        StateColors.clearColors
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color(200, 200, 200), Color(80, 80, 80)),
            on: Color.clear,
            pressedOff: Color.dynamic(Color(170, 170, 170), Color(110, 110, 110)),
            pressedOn: Color.clear,
            disabled: Color.dynamic(Color(220, 220, 220), Color(70, 70, 70))
        )
#elseif os(watchOS)
        StateColors.clearColors
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Thumb
    /// Thumb dimension.
    public var thumbSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 27)
#elseif os(macOS)
        CGSize(dimension: 20)
#elseif os(watchOS)
        CGSize(dimension: 20)
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb corner radius.
    public var thumbCornerRadius: CGFloat = {
#if os(iOS)
        13.5
#elseif os(macOS)
        10
#elseif os(watchOS)
        10
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb colors.
    public var thumbColors: StateColors = .init(
        off: Color.white,
        on: Color.white,
        pressedOff: Color.white,
        pressedOn: Color.white,
        disabled: Color.platformDynamic(Color.white, Color.white.opacity(0.75))
    )

    // MARK: Properties - Label
    /// Indicates if label is clickable.
    public var labelIsClickable: Bool = true

    // MARK: Properties - Label - Text
    /// Label text line type...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Label text minimum scale factor.
    public var labelTextMinimumScaleFactor: CGFloat = 1

    /// Label text colors.
    public var labelTextColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.primary,
            on: Color.primary,
            pressedOff: Color.primary,
            pressedOn: Color.primary,
            disabled: Color.primary.opacity(0.3)
        )
#elseif os(macOS)
        StateColors(
            off: Color.primary.opacity(0.85),
            on: Color.primary.opacity(0.85),
            pressedOff: Color.primary.opacity(0.85),
            pressedOn: Color.primary.opacity(0.85),
            disabled: Color.primary.opacity(0.85 * 0.3)
        )
#elseif os(watchOS)
        StateColors(
            off: Color.white,
            on: Color.white,
            pressedOff: Color.white,
            pressedOn: Color.white,
            disabled: Color.white.opacity(0.3)
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Label text font.
    public var labelTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(macOS)
        Font.body
#elseif os(watchOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    /// Label text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Transition - State Change
    /// Indicates if `stateChangeAnimation` is applied.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesStateChangeAnimation: Bool = true

    /// State change animation.
    public var stateChangeAnimation: Animation? = .easeIn(duration: 0.1)

    // MARK: Properties - Sensory Feedback
    /// Sensory feedback.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var sensoryFeedback: SensoryFeedback? = {
#if os(iOS)
        SensoryFeedback.impact(weight: .light)
#elseif os(macOS)
        nil
#elseif os(watchOS)
        SensoryFeedback.impact(weight: .light)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound colors.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
}
