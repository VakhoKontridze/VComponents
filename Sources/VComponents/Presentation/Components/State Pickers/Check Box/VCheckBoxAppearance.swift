//
//  VCheckBoxAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VCheckBoxAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        appearance.animatesStateChange = false

        return appearance
    }
    
    /// Checkbox dimension.
    public var size: CGSize = {
#if os(iOS)
        CGSize(dimension: 22)
#elseif os(macOS)
        CGSize(dimension: 16)
#else
        fatalError()
#endif
    }()

    /// Spacing between checkbox and label.
    public var checkBoxAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Corners
    /// Checkbox corner radius.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        11
#elseif os(macOS)
        4
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.primaryInverted,
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            indeterminate: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.primaryInverted,
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            pressedIndeterminate: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.primaryInverted
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            indeterminate: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            pressedIndeterminate: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
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
        on: Color.clear,
        indeterminate: Color.clear,
        pressedOff: Color.platformDynamic(Color(170, 170, 170), Color(130, 130, 130)),
        pressedOn: Color.clear,
        pressedIndeterminate: Color.clear,
        disabled: Color.platformDynamic(Color(230, 230, 230), Color(70, 70, 70))
    )

    // MARK: Properties - Checkmark
    /// Checkmark image configuration.
    public var checkmarkImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(
            off: Color.clear,
            on: Color.white,
            indeterminate: Color.white,
            pressedOff: Color.clear,
            pressedOn: Color.white,
            pressedIndeterminate: Color.white,
            disabled: Color.clear
        ),
        aspectRatio: ImageConfiguration.AspectRatio(
            contentMode: .fit
        ),
        resizable: ImageConfiguration.Resizable(),
        size: {
#if os(iOS)
            CGSize(dimension: 11)
#elseif os(macOS)
            CGSize(dimension: 9)
#else
            fatalError()
#endif
        }()
    )
    
    /// Checkmark image (on).
    public var checkmarkImageOn: Image = ImageBook.Symbols.checkmark.renderingMode(.template)

    /// Checkmark image (indeterminate).
    public var checkmarkImageIndeterminate: Image = ImageBook.Symbols.line.renderingMode(.template)

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
                indeterminate: Color.primary,
                pressedOff: Color.primary,
                pressedOn: Color.primary,
                pressedIndeterminate: Color.primary,
                disabled: Color.primary.opacity(0.3)
            )
#elseif os(macOS)
            StateColors(
                off: Color.primary.opacity(0.85),
                on: Color.primary.opacity(0.85),
                indeterminate: Color.primary.opacity(0.85),
                pressedOff: Color.primary.opacity(0.85),
                pressedOn: Color.primary.opacity(0.85),
                pressedIndeterminate: Color.primary.opacity(0.85),
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
    public typealias StateColors = GenericStateModel_OffOnIndeterminatePressedDisabled<Color>

    /// State-bound opacities.
    public typealias StateOpacities = GenericStateModel_OffOnIndeterminatePressedDisabled<CGFloat>
    
    /// State-bound text configuration.
    public typealias StateTextConfiguration = GenericStateTextConfiguration<StateColors>
    
    /// State-bound image configuration.
    public typealias StateImageConfiguration = GenericStateImageConfiguration<StateColors, StateOpacities>
}
