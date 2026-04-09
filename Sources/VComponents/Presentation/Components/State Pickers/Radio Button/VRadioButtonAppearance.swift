//
//  VRadioButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VRadioButtonAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        appearance.animatesStateChange = false

        return appearance
    }
    
    /// Size.
    public var size: CGSize = {
#if os(iOS)
        CGSize(dimension: 22)
#elseif os(macOS)
        CGSize(dimension: 16)
#else
        fatalError()
#endif
    }()

    /// Corner radius.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        11
#elseif os(macOS)
        8
#else
        fatalError()
#endif
    }()

    /// Spacing between radio button and label.
    public var radioButtonAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(Color.primaryInverted)
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            on: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            pressedOff: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            pressedOn: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            disabled: Color.dynamic(Color(250, 250, 250), Color.black.opacity(0.05))
        )
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(1.5)
#elseif os(macOS)
        PointPixelMeasurement.points(1)
#else
        fatalError()
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = .init(
        off: Color.platformDynamic(Color(200, 200, 200), Color(100, 100, 100)),
        on: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressedOff: Color.platformDynamic(Color(170, 170, 170), Color(130, 130, 130)),
        pressedOn: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color.platformDynamic(Color(230, 230, 230), Color(70, 70, 70))
    )

    // MARK: Properties - Bullet
    /// Bullet dimension. 
    public var bulletSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 12)
#elseif os(macOS)
        CGSize(dimension: 8)
#else
        fatalError()
#endif
    }()

    /// Bullet corner radius.
    public var bulletCornerRadius: CGFloat = {
#if os(iOS)
        6
#elseif os(macOS)
        4
#else
        fatalError()
#endif
    }()

    /// Bullet colors.
    public var bulletColors: StateColors = .init(
        off: Color.clear,
        on: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressedOff: Color.clear,
        pressedOn: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color.clear
    )

    // MARK: Properties - Label
    /// Indicates if label is clickable.
    public var labelIsClickable: Bool = true

    // MARK: Properties - Label - Text
    /// Label text configuration.
    public var labelTextConfiguration: StateTextConfiguration = .init(
        lineType: .multiLine(
            alignment: .leading,
            lineLimit: 1...2
        ),
        colors: {
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
#else
            fatalError()
#endif
        }(),
        font: {
#if os(iOS)
            Font.subheadline
#elseif os(macOS)
            Font.body
#else
            fatalError()
#endif
        }()
    )

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
#else
        fatalError()
#endif
    }()
    
    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound colors.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
    
    /// State-bound text configuration.
    public typealias StateTextConfiguration = GenericStateTextConfiguration<StateColors>
}
