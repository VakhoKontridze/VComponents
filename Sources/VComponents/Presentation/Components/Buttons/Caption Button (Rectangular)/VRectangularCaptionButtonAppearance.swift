//
//  VRectangularCaptionButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularCaptionButtonAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    /// Spacing between rectangle and caption.
    public var rectangleAndCaptionSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(watchOS)
        3
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Rectangle
    /// Rectangle size.
    public var rectangleSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 56)
#elseif os(watchOS)
        CGSize(width: 64, height: 56)
#else
        fatalError()
#endif
    }()

    /// Rectangle corner radius.
    public var rectangleCornerRadius: CGFloat = 24

    /// Rectangle colors.
    public var rectangleColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240, 0.25), Color(25, 131, 255, 0.35)),
        pressed: Color.platformDynamic(Color(31, 104, 182, 0.25), Color(36, 106, 186, 0.35)),
        disabled: Color(128, 176, 240, 0.35)
    )

    /// Rectangle pressed scale.
    public var rectanglePressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError()
#endif
    }()

    /// Rectangle border width.
    ///
    /// To hide border, set to `0`.
    public var rectangleBorderWidth: PointPixelMeasurement = .points(0)

    /// Rectangle border colors.
    public var rectangleBorderColors: StateColors = .clearColors

    // MARK: Properties - Label - Image
    /// Label image configuration.
    public var labelImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(
            enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color(128, 176, 240, 0.5)
        ),
        aspectRatio: ImageConfiguration.AspectRatio(
            contentMode: .fit
        ),
        resizable: ImageConfiguration.Resizable(),
        size: {
#if os(iOS)
            CGSize(dimension: 24)
#elseif os(watchOS)
            CGSize(dimension: 26)
#else
            fatalError()
#endif
        }()
    )

    /// Label image pressed scale.
    public var labelImagePressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError()
#endif
    }()

    /// Label image margins.
    public var labelImageMargins: EdgeInsets = .init(3)

    // MARK: Properties - Caption
    /// Maximum caption width.
    public var captionWidthMax: CGFloat = 100

    /// Caption frame alignment.
    public var captionFrameAlignment: HorizontalAlignment = .center

    /// Caption text and caption image placement.
    public var captionTextAndCaptionImagePlacement: TextAndImagePlacement = .imageAndText

    /// Caption spacing.
    ///
    /// Applicable only if `init` with multiple components is used.
    public var captionSpacing: CGFloat = 8

    /// Caption pressed scale.
    public var captionPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError()
#endif
    }()
    
    // MARK: Properties - Caption - Text
    /// Caption text configuration.
    public var captionTextConfiguration: StateTextConfiguration = .init(
        lineType: {
#if os(iOS)
            .multiLine(
                alignment: .center,
                lineLimit: 1...2
            )
#elseif os(watchOS)
            .singleLine
#else
            fatalError()
#endif
        }(),
        colors: StateColors(
            enabled: Color.primary,
            pressed: Color.primary.opacity(0.3),
            disabled: Color.primary.opacity(0.3)
        ),
        font: {
#if os(iOS)
            Font.subheadline
#elseif os(watchOS)
            Font.body
#else
            fatalError()
#endif
        }(),
        minimumScaleFactor: 0.75
    )

    // MARK: Properties - Caption - Image
    /// Caption image configuration.
    public var captionImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(
            enabled: Color.primary,
            pressed: Color.primary.opacity(0.3),
            disabled: Color.primary.opacity(0.3)
        ),
        aspectRatio: ImageConfiguration.AspectRatio(
            contentMode: .fit
        ),
        resizable: ImageConfiguration.Resizable(),
        size: {
#if os(iOS)
            CGSize(dimension: 16)
#elseif os(watchOS)
            CGSize(dimension: 18)
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
    ///
    /// By default, `background` of button is transparent.
    /// And applying shadow directly without making it opaque is not recommended.
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
