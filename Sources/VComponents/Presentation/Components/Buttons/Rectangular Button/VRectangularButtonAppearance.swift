//
//  VRectangularButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularButtonAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    /// Size.
    public var size: CGSize = {
#if os(iOS)
        CGSize(dimension: 56)
#elseif os(macOS)
        CGSize(dimension: 28)
#elseif os(watchOS)
        CGSize(width: 64, height: 56)
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        16
#elseif os(macOS)
        6
#elseif os(watchOS)
        16
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
    public var labelMargins: EdgeInsets = .init(3)

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
            Font.subheadline.weight(.semibold)
#elseif os(macOS)
            Font.body
#elseif os(watchOS)
            Font.body.weight(.semibold)
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
            CGSize(dimension: 24)
#elseif os(macOS)
            CGSize(dimension: 14)
#elseif os(watchOS)
            CGSize(dimension: 26)
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
    public var sensoryFeedback: SensoryFeedback?
    
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
