//
//  VStretchedButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VStretchedButtonAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    /// Height.
    public var height: CGFloat = {
#if os(iOS)
        48
#elseif os(macOS)
        40
#elseif os(watchOS)
        64
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        14
#elseif os(macOS)
        12
#elseif os(watchOS)
        32
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240)
    )

    /// Background pressed scale.
    public var backgroundPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins.
    public var labelMargins: EdgeInsets = .init(
        horizontal: 15,
        vertical: 3
    )

    /// Label text and label image placement.
    public var labelTextAndLabelImagePlacement: TextAndImagePlacement = .imageAndText

    /// Label spacing type.
    ///
    /// Applicable only if `init` with multiple components is used.
    public var labelSpacingType: TextAndImageSpacingType = .fixed(spacing: 8)

    /// Label pressed scale.
    public var labelPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Label - Text
    /// Label text configuration.
    public var labelTextConfiguration: StateTextConfiguration = .init(
        colors: StateColors(Color.white),
        font: {
#if os(iOS)
            Font.callout.weight(.semibold)
#elseif os(macOS)
            Font.system(size: 16, weight: .semibold) // No dynamic type on `macOS`
#elseif os(watchOS)
            Font.title3.weight(.semibold)
#else
            fatalError()
#endif
        }(),
        minimumScaleFactor: 0.75
    )

    // MARK: Properties - Label - Image
    /// Label image configuration.
    public var labelImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(Color.white),
        aspectRatio: ImageConfiguration.AspectRatio(
            contentMode: .fit
        ),
        resizable: ImageConfiguration.Resizable(),
        size: {
#if os(iOS)
            CGSize(dimension: 18)
#elseif os(macOS)
            CGSize(dimension: 16)
#elseif os(watchOS)
            CGSize(dimension: 22)
#else
            fatalError()
#endif
        }()
    )

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset.
    public var shadowOffset: CGPoint = .zero

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
        fatalError()
#endif
    }()

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound colors.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    /// State-bound opacities.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    
    /// State-bound text configuration.
    public typealias StateTextConfiguration = GenericStateTextConfiguration<StateColors>
    
    /// State-bound image configuration.
    public typealias StateImageConfiguration = GenericStateImageConfiguration<StateColors, StateOpacities>
}
