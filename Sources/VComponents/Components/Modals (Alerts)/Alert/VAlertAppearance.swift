//
//  VAlertAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertAppearance: Sendable {
    // MARK: Properties - Global
    var modalPresenterLinkAppearance: ModalPresenterLinkAppearance {
        var appearance: ModalPresenterLinkAppearance = .init()
        appearance.preferredDimmingViewColor = preferredDimmingViewColor
        return appearance
    }
    
    /// Preferred dimming color, that overrides a shared color from `ModalPresenterRootAppearance`, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Alert width group.
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
        fatalError() // Not supported
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
        fatalError() // Not supported
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
        fatalError() // Not supported
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
    /// Title text frame alignment.
    public var titleTextFrameAlignment: HorizontalAlignment = .center

    /// Title text line type...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextLineType: TextLineType = .multiLine(
        alignment: .center,
        lineLimit: 1...2
    )
    
    /// Title text minimum scale factor.
    public var titleTextMinimumScaleFactor: CGFloat = 1

    /// Title text color.
    public var titleTextColor: Color = .primary

    /// Title text font.
    public var titleTextFont: Font = .headline.weight(.bold)

    /// Title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    /// Title text margins.
    public var titleTextMargins: EdgeInsets = .init(
        leading: 0,
        trailing: 0,
        top: 5,
        bottom: 3
    )

    // MARK: Properties - Alert Content - Message
    /// Message text frame alignment.
    public var messageTextFrameAlignment: HorizontalAlignment = .center

    /// Message text line type...5` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextLineType: TextLineType = .multiLine(
        alignment: .center,
        lineLimit: 1...5
    )
    
    /// Message text minimum scale factor.
    public var messageTextMinimumScaleFactor: CGFloat = 1

    /// Message text color.
    public var messageTextColor: Color = .primary

    /// Message text font.
    public var messageTextFont: Font = .subheadline

    /// Message text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
    /// Button height.
    public var buttonHeight: CGFloat = {
#if os(iOS)
        40
#elseif os(macOS)
        22
#else
        fatalError() // Not supported
#endif
    }()

    /// Button corner radius.
    public var buttonCornerRadius: CGFloat = {
#if os(iOS)
        10
#elseif os(macOS)
        4
#else
        fatalError() // Not supported
#endif
    }()

    /// Button text font.
    public var buttonTextFont: Font = {
#if os(iOS)
        Font.callout.weight(.semibold)
#elseif os(macOS)
        Font.system(size: 13) // No dynamic type on `macOS`
#else
        fatalError() // Not supported
#endif
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
        fatalError() // Not supported
#endif
    }()

#if os(iOS)
    /// Button haptic feedback style.
    public var buttonHaptic: UIImpactFeedbackGenerator.FeedbackStyle?
#endif

    // MARK: Properties - Alert Content - Button - Primary
    /// Primary button background colors.
    public var primaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240)
    )

    /// Primary button text colors.
    public var primaryButtonTextColors: ButtonStateColors = .init(Color.white)

    var primaryButtonAppearance: VStretchedButtonAppearance {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = buttonHeight
        appearance.cornerRadius = buttonCornerRadius

        appearance.backgroundColors = primaryButtonBackgroundColors

        appearance.labelTextColors = primaryButtonTextColors
        appearance.labelTextFont = buttonTextFont
        appearance.labelTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        appearance.haptic = buttonHaptic
#endif

        return appearance
    }

    // MARK: Properties - Alert Content - Button - Secondary
    /// Secondary button background colors.
    public var secondaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.platformDynamic(Color(240, 240, 240), Color(70, 70, 70)),
        disabled: Color.clear
    )

    /// Secondary button text colors.
    public var secondaryButtonTextColors: ButtonStateColors = .init(
        enabled: Color.blue,
        pressed: Color.blue,
        disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
    )

    var secondaryButtonAppearance: VStretchedButtonAppearance {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = buttonHeight
        appearance.cornerRadius = buttonCornerRadius

        appearance.backgroundColors = secondaryButtonBackgroundColors

        appearance.labelTextColors = secondaryButtonTextColors
        appearance.labelTextFont = buttonTextFont
        appearance.labelTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        appearance.haptic = buttonHaptic
#endif

        return appearance
    }

    // MARK: Properties - Alert Content - Button - Destructive
    /// Destructive button background colors.
    public var destructiveButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.platformDynamic(Color(240, 240, 240), Color(70, 70, 70)),
        disabled: Color.clear
    )

    /// Destructive button text colors.
    public var destructiveButtonTextColors: ButtonStateColors = .init(
        enabled: Color.red,
        pressed: Color.red,
        disabled: Color.platformDynamic(Color.red.opacity(0.3), Color.red.opacity(0.5))
    )

    var destructiveButtonAppearance: VStretchedButtonAppearance {
        var appearance: VStretchedButtonAppearance = .init()

        appearance.height = buttonHeight
        appearance.cornerRadius = buttonCornerRadius

        appearance.backgroundColors = destructiveButtonBackgroundColors

        appearance.labelTextColors = destructiveButtonTextColors
        appearance.labelTextFont = buttonTextFont
        appearance.labelTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        appearance.haptic = buttonHaptic
#endif

        return appearance
    }

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

    // MARK: Width Group
    /// Alert width group.
    public typealias WidthGroup = ModalComponentSizeGroup<Width>

    // MARK: Width
    /// Alert width.
    public enum Width: Sendable {
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

    // MARK: Button State Colors
    /// Model that contains colors for button component states.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
