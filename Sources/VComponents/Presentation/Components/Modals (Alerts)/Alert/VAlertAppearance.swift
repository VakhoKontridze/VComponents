//
//  VAlertAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertAppearance {
    // MARK: Properties - Global
    var modalPresenterLinkAppearance: ModalPresenterLinkAppearance {
        var appearance: ModalPresenterLinkAppearance = .init()
        appearance.preferredDimmingViewColor = preferredDimmingViewColor
        return appearance
    }
    
    /// Preferred dimming color, that overrides a shared color from `ModalPresenterRootAppearance`, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Width group.
    public var widthGroup: WidthGroup = {
#if os(iOS)
        WidthGroup(
            portrait: .fixed(width: .fraction(0.75)),
            landscape: .fixed(width: .fraction(0.5))
        )
#elseif os(macOS)
        WidthGroup(
            portrait: .fixed(width: .absolute(250)),
            landscape: .zero
        )
#else
        fatalError()
#endif
    }()

    /// Vertical margin.
    ///
    /// Margin isn't noticeable most of the time, but when alert reaches maximum height, it will pad it.
    public var marginVertical: CGFloat = {
#if os(iOS)
        10
#elseif os(macOS)
        20
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radii.
    public var cornerRadii: RectangleCornerRadii = .init(20)

    /// Indicates if horizontal corners should switch to support RTL languages.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#elseif os(macOS)
        Color(nsColor: NSColor.windowBackgroundColor)
#else
        fatalError()
#endif
    }()

    var groupBoxAppearance: VGroupBoxAppearance {
        var appearance: VGroupBoxAppearance = .init()

        appearance.cornerRadii = cornerRadii
        appearance.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        appearance.backgroundColor = backgroundColor

        appearance.borderWidth = borderWidth
        appearance.borderColor = borderColor

        appearance.contentMargins = EdgeInsets()

        return appearance
    }

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border color.
    public var borderColor: Color = .clear

    // MARK: Properties - Alert Content
    /// Additional margins applied to title text, message text, and content as a whole.
    public var titleTextAndMessageTextAndContentMargins: EdgeInsets = .init(
        leading: 15,
        trailing: 15,
        top: 15,
        bottom: 10
    )

    // MARK: Properties - Alert Content - Title
    /// Title text configuration.
    public var titleTextConfiguration: TextConfiguration = .init(
        lineType: .multiLine(
            alignment: .center,
            lineLimit: 1...2
        ),
        color: Color.primary,
        font: Font.headline.weight(.bold)
    )
    
    /// Title text frame alignment.
    public var titleTextFrameAlignment: HorizontalAlignment = .center

    /// Title text margins.
    public var titleTextMargins: EdgeInsets = .init(
        leading: 0,
        trailing: 0,
        top: 5,
        bottom: 3
    )

    // MARK: Properties - Alert Content - Message
    /// Message text configuration.
    public var messageTextConfiguration: TextConfiguration = .init(
        lineType: .multiLine(
            alignment: .center,
            lineLimit: 1...5
        ),
        color: Color.primary,
        font: Font.subheadline
    )
    
    /// Message text frame alignment.
    public var messageTextFrameAlignment: HorizontalAlignment = .center

    /// Message text margins.
    public var messageTextMargins: EdgeInsets = .init(
        leading: 0,
        trailing: 0,
        top: 3,
        bottom: 5
    )

    // MARK: Properties - Alert Content - Content
    /// Content margins.
    public var contentMargins: EdgeInsets = .init(
        leading: 0,
        trailing: 0,
        top: 10,
        bottom: 0
    )

    // MARK: Properties - Alert Content - Buttons
    /// Primary button appearance.
    public var primaryButtonAppearance: VStretchedButtonAppearance = {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = {
#if os(iOS)
            40
#elseif os(macOS)
            22
#else
            fatalError()
#endif
        }()
        appearance.cornerRadius = {
#if os(iOS)
            10
#elseif os(macOS)
            4
#else
            fatalError()
#endif
        }()

        appearance.backgroundColors = ButtonStateColors(
            enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color(128, 176, 240)
        )

        appearance.labelTextConfiguration.colors = ButtonStateColors(Color.white)
        appearance.labelTextConfiguration.font = {
#if os(iOS)
            Font.callout.weight(.semibold)
#elseif os(macOS)
            Font.system(size: 13) // No dynamic type on `macOS`
#else
            fatalError()
#endif
        }()

        appearance.sensoryFeedback = nil

        return appearance
    }()
    
    /// Secondary button appearance.
    public var secondaryButtonAppearance: VStretchedButtonAppearance = {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = {
#if os(iOS)
            40
#elseif os(macOS)
            22
#else
            fatalError()
#endif
        }()
        appearance.cornerRadius = {
#if os(iOS)
            10
#elseif os(macOS)
            4
#else
            fatalError()
#endif
        }()

        appearance.backgroundColors = ButtonStateColors(
            enabled: Color.clear,
            pressed: Color.platformDynamic(Color(240, 240, 240), Color(70, 70, 70)),
            disabled: Color.clear
        )

        appearance.labelTextConfiguration.colors = ButtonStateColors(
            enabled: Color.blue,
            pressed: Color.blue,
            disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
        )
        appearance.labelTextConfiguration.font = {
#if os(iOS)
            Font.callout.weight(.semibold)
#elseif os(macOS)
            Font.system(size: 13) // No dynamic type on `macOS`
#else
            fatalError()
#endif
        }()

        appearance.sensoryFeedback = nil

        return appearance
    }()
    
    /// Destructive button appearance.
    public var destructiveButtonAppearance: VStretchedButtonAppearance = {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = {
#if os(iOS)
            40
#elseif os(macOS)
            22
#else
            fatalError()
#endif
        }()
        appearance.cornerRadius = {
#if os(iOS)
            10
#elseif os(macOS)
            4
#else
            fatalError()
#endif
        }()

        appearance.backgroundColors = ButtonStateColors(
            enabled: Color.clear,
            pressed: Color.platformDynamic(Color(240, 240, 240), Color(70, 70, 70)),
            disabled: Color.clear
        )

        appearance.labelTextConfiguration.colors = ButtonStateColors(
            enabled: Color.red,
            pressed: Color.red,
            disabled: Color.platformDynamic(Color.red.opacity(0.3), Color.red.opacity(0.5))
        )
        appearance.labelTextConfiguration.font = {
#if os(iOS)
            Font.callout.weight(.semibold)
#elseif os(macOS)
            Font.system(size: 13) // No dynamic type on `macOS`
#else
            fatalError()
#endif
        }()

        appearance.sensoryFeedback = nil

        return appearance
    }()

    /// Button margins.
    public var buttonMargins: EdgeInsets = .init(
        leading: 15,
        trailing: 15,
        top: 10,
        bottom: 15
    )

    /// Spacing between horizontal buttons.
    public var horizontalButtonSpacing: CGFloat = 10

    /// Spacing between vertical buttons.
    public var verticalButtonSpacing: CGFloat = {
#if os(iOS)
        5
#elseif os(macOS)
        10
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Transition - Appear/Disappear
    /// Scale effect during appear and disappear.
    public var scaleEffect: CGFloat = 1.01

    // MARK: Properties - Transition - Appear
    /// Appear animation.
    public var appearAnimation: Animation? = .linear(duration: 0.05)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation.
    public var disappearAnimation: Animation? = .easeIn(duration: 0.05)

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius.
    public var shadowRadius: CGFloat = 10

    /// Shadow offset.
    public var shadowOffset: CGPoint = .zero

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// Width group.
    public typealias WidthGroup = ModalComponentSizeGroup<Width>

    /// Width.
    nonisolated public enum Width: Equatable, Sendable {
        // MARK: Cases
        /// Fixed width.
        case fixed(width: AbsoluteFractionMeasurement)

        /// Stretched width.
        case stretched(margin: AbsoluteFractionMeasurement)

        // MARK: Properties
        var margin: AbsoluteFractionMeasurement {
            switch self {
            case .fixed: .absolute(0)
            case .stretched(let margin): margin
            }
        }

        // MARK: Initializers
        static var zero: Self {
            .fixed(width: .absolute(0))
        }
    }

    /// State-bound colors.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
