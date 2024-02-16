//
//  VAlertUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertUIModel {
    // MARK: Properties - Global
    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    /// Color scheme. Set to `nil`.
    public var colorScheme: ColorScheme? = nil

    /// Alert sizes.
    /// Set to `0.75` ratio of container width in portrait.
    /// Set to `0.5` ratio of container width in landscape.
    public var widths: Widths = .init(
        portrait: .fraction(0.75),
        landscape: .fraction(0.5)
    )

    /// Additional margins applied to title text, message text, and content as a whole. Set to `(15, 15, 15, 10)`.
    public var titleTextMessageTextAndContentMargins: Margins = .init(
        leading: 15,
        trailing: 15,
        top: 15,
        bottom: 10
    )

    // MARK: Properties - Corners
    /// Rounded corners. Set to to `allCorners`.
    public var roundedCorners: RectCorner = .allCorners

    /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
    public var reversesLeftAndRightCornersForRTLLanguages: Bool = true

    /// Corner radius. Set to `20`.
    public var cornerRadius: CGFloat = 20

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#else
        fatalError() // Not supported
#endif
    }()

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.roundedCorners = roundedCorners
        uiModel.reversesLeftAndRightCornersForRTLLanguages = reversesLeftAndRightCornersForRTLLanguages
        uiModel.cornerRadius = cornerRadius

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Title
    /// Title title text frame alignment. Set to `center`.
    public var titleTextFrameAlignment: HorizontalAlignment = .center

    /// Title text line type. Set to `multiline` with `center` alignment and `1...2` lines.
    public var titleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .center, lineLimit: 1...2)
        } else {
            .multiLine(alignment: .center, lineLimit: 2)
        }
    }()

    /// Title text color.
    public var titleTextColor: Color = .primary

    /// Title text font. Set to `bold` `headline`.
    public var titleTextFont: Font = .headline.weight(.bold)

    /// Title text margins. Set to `(0, 0, 5, 3)`.
    public var titleTextMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 5,
        bottom: 3
    )

    // MARK: Properties - Message
    /// Message title text frame alignment. Set to `center`.
    public var messageTextFrameAlignment: HorizontalAlignment = .center

    /// Message line type. Set to `multiline` with `center` alignment and `1...5` lines.
    public var messageTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .center, lineLimit: 1...5)
        } else {
            .multiLine(alignment: .center, lineLimit: 5)
        }
    }()

    /// Message text color.
    public var messageTextColor: Color = .primary

    /// Message text font. Set to `subheadline`.
    public var messageTextFont: Font = .subheadline

    /// Message text margins. Set to `(0, 0, 3, 5)`.
    public var messageTextMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 3,
        bottom: 5
    )

    // MARK: Properties - Content
    /// Content margins  Set to `(0, 0, 10, 0)`.
    public var contentMargins: Margins = .init(
        leading: 0,
        trailing: 0,
        top: 10,
        bottom: 0
    )

    // MARK: Properties - Buttons
    /// Button height. Set to `40`.
    public var buttonHeight: CGFloat = 40

    /// Button corner radius. Set to `10`.
    public var buttonCornerRadius: CGFloat = 10

    /// Button margins. Set to `(15, 15, 10, 15)`
    public var buttonMargins: Margins = .init(
        leading: 15,
        trailing: 15,
        top: 10,
        bottom: 15
    )

    /// Spacing between horizontal buttons.  Set to `10`.
    public var horizontalButtonSpacing: CGFloat = 10

    /// Spacing between vertical buttons.  Set to `5`.
    public var verticalButtonSpacing: CGFloat = 5

#if os(iOS)
    /// Button haptic feedback style. Set to `nil`.
    public var buttonHaptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil
#endif

    // MARK: Properties - Button - Primary
    /// Primary button background colors.
    public var primaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.makeDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
        pressed: Color.makeDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
        disabled: Color.make((128, 176, 240, 1))
    )

    /// Primary button title text colors.
    public var primaryButtonTitleTextColors: ButtonStateColors = .init(Color.white)

    var primaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = primaryButtonBackgroundColors

        uiModel.titleTextColors = primaryButtonTitleTextColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Secondary
    /// Secondary button background colors.
    public var secondaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.makeDynamic((240, 240, 240, 1), (70, 70, 70, 1)),
        disabled: Color.clear
    )

    /// Secondary button title text colors.
    public var secondaryButtonTitleTextColors: ButtonStateColors = .init(
        enabled: Color.blue,
        pressed: Color.blue,
        disabled: Color.dynamic(light: Color.blue.opacity(0.3), dark: Color.blue.opacity(0.5))
    )

    var secondaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = secondaryButtonBackgroundColors

        uiModel.titleTextColors = secondaryButtonTitleTextColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Destructive
    /// Destructive button background colors.
    public var destructiveButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.makeDynamic((240, 240, 240, 1), (70, 70, 70, 1)),
        disabled: Color.clear
    )

    /// Destructive button title text colors.
    public var destructiveButtonTitleTextColors: ButtonStateColors = .init(
        enabled: Color.red,
        pressed: Color.red,
        disabled: Color.dynamic(light: Color.red.opacity(0.3), dark: Color.red.opacity(0.5))
    )

    var destructiveButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = destructiveButtonBackgroundColors

        uiModel.titleTextColors = destructiveButtonTitleTextColors

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Dimming View
    /// Dimming view color.
    public var dimmingViewColor: Color = .makeDynamic((100, 100, 100, 0.3), (0, 0, 0, 0.4))

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Appear animation. Set to `linear` with duration `0.05`.
    public var appearAnimation: BasicAnimation? = .init(curve: .linear, duration: 0.05)

    /// Disappear animation. Set to `easeIn` with duration `0.05`.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)

    /// Scale effect during appear and disappear. Set to `1.01`.
    public var scaleEffect: CGFloat = 1.01

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Widths
    /// Model that represents alert widths.
    public typealias Widths = ModalComponentSizes<Width>

    // MARK: Width
    /// Model that represents alert width.
    public typealias Width = SingleDimensionModalComponentSize

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Button State Colors
    /// Model that contains colors for button component states.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
