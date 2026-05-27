//
//  VPlainButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VPlainButtonAppearance {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    // MARK: Properties - Label
    /// Label text and label image placement.
    public var labelTextAndLabelImagePlacement: TextAndImagePlacement = .imageAndText

    /// Label spacing.
    ///
    /// Applicable only if `init` with multiple components is used.
    public var labelSpacing: CGFloat = 8

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
        colors: StateColors(
            enabled: Color.blue,
            pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
            disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
        ),
        font: Font.body,
        minimumScaleFactor: 0.75
    )

    // MARK: Properties - Label - Image
    /// Label image configuration.
    public var labelImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(
            enabled: Color.blue,
            pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
            disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
        ),
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
