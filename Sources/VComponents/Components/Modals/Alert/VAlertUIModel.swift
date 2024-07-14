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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VAlertUIModel {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel { .init() }

    /// Alert sizes.
    /// Set to `0.75` fraction in portrait and `0.5` fraction in landscape on `iOS`.
    /// Set to `250` on `macOS`.
    public var widths: Widths = {
#if os(iOS)
        Widths(
            portrait: .fraction(0.75),
            landscape: .fraction(0.5)
        )
#elseif os(macOS)
        Widths(
            portrait: .absolute(250),
            landscape: .absolute(0)
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Additional margins applied to title text, message text, and content as a whole. Set to `(15, 15, 15, 10)`.
    public var titleTextMessageTextAndContentMargins: Margins = .init(
        leading: 15,
        trailing: 15,
        top: 15,
        bottom: 10
    )

    // MARK: Properties - Corners
    /// Corner radii. Set to to `20`s.
    public var cornerRadii: RectangleCornerRadii = .init(20)

    /// Indicates if horizontal corners should switch to support RTL languages. Set to `true`.
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

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.cornerRadii = cornerRadii
        uiModel.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Title
    /// Title title text frame alignment. Set to `center`.
    public var titleTextFrameAlignment: HorizontalAlignment = .center

    /// Title text line type. Set to `multiline` with `center` alignment and `1...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextLineType: TextLineType = .multiLine(
        alignment: .center,
        lineLimit: 1...2
    )

    /// Title text color.
    public var titleTextColor: Color = .primary

    /// Title text font. Set to `bold` `headline`.
    public var titleTextFont: Font = .headline.weight(.bold)

    /// Title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextLineType: TextLineType = .multiLine(
        alignment: .center,
        lineLimit: 1...5
    )

    /// Message text color.
    public var messageTextColor: Color = .primary

    /// Message text font. Set to `subheadline`.
    public var messageTextFont: Font = .subheadline

    /// Message text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
    /// Button height.
    /// Set to `40` on `iOS`.
    /// Set to `22` on `macOS`.
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
    /// Set to `10` on `iOS`.
    /// Set to `4` on `macOS`.
    public var buttonCornerRadius: CGFloat = {
#if os(iOS)
        10
#elseif os(macOS)
        4
#else
        fatalError() // Not supported
#endif
    }()

    /// Button title text font.
    /// Set to `semibold` `callout` on `iOS`.
    /// Set to `13` on `macOS`.
    public var buttonTitleTextFont: Font = {
#if os(iOS)
        Font.callout.weight(.semibold)
#elseif os(macOS)
        Font.system(size: 13) // No dynamic type on `macOS`
#else
        fatalError() // Not supported
#endif
    }()

    /// Button margins. Set to `(15, 15, 10, 15)`
    public var buttonMargins: Margins = .init(
        leading: 15,
        trailing: 15,
        top: 10,
        bottom: 15
    )

    /// Spacing between horizontal buttons. Set to `10`.
    public var horizontalButtonSpacing: CGFloat = 10

    /// Spacing between vertical buttons.
    /// Set to `5` on `iOS`.
    /// Set to `10` on `macOS`.
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
    /// Button haptic feedback style. Set to `nil`.
    public var buttonHaptic: UIImpactFeedbackGenerator.FeedbackStyle?
#endif

    // MARK: Properties - Button - Primary
    /// Primary button background colors.
    public var primaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240)
    )

    /// Primary button title text colors.
    public var primaryButtonTitleTextColors: ButtonStateColors = .init(Color.white)

    var primaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = primaryButtonBackgroundColors

        uiModel.titleTextColors = primaryButtonTitleTextColors
        uiModel.titleTextFont = buttonTitleTextFont
        uiModel.titleTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Secondary
    /// Secondary button background colors.
    public var secondaryButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.dynamic(Color(240, 240, 240), Color(70, 70, 70)),
        disabled: Color.clear
    )

    /// Secondary button title text colors.
    public var secondaryButtonTitleTextColors: ButtonStateColors = .init(
        enabled: Color.blue,
        pressed: Color.blue,
        disabled: Color.dynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
    )

    var secondaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = secondaryButtonBackgroundColors

        uiModel.titleTextColors = secondaryButtonTitleTextColors
        uiModel.titleTextFont = buttonTitleTextFont
        uiModel.titleTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Button - Destructive
    /// Destructive button background colors.
    public var destructiveButtonBackgroundColors: ButtonStateColors = .init(
        enabled: Color.clear,
        pressed: Color.dynamic(Color(240, 240, 240), Color(70, 70, 70)),
        disabled: Color.clear
    )

    /// Destructive button title text colors.
    public var destructiveButtonTitleTextColors: ButtonStateColors = .init(
        enabled: Color.red,
        pressed: Color.red,
        disabled: Color.dynamic(Color.red.opacity(0.3), Color.red.opacity(0.5))
    )

    var destructiveButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()

        uiModel.height = buttonHeight
        uiModel.cornerRadius = buttonCornerRadius

        uiModel.backgroundColors = destructiveButtonBackgroundColors

        uiModel.titleTextColors = destructiveButtonTitleTextColors
        uiModel.titleTextFont = buttonTitleTextFont
        uiModel.titleTextDynamicTypeSizeType = .partialRangeThrough(...(.accessibility2))

#if os(iOS)
        uiModel.haptic = buttonHaptic
#endif

        return uiModel
    }

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

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
    /// Alert widths.
    public typealias Widths = ModalComponentSizes<Width>

    // MARK: Width
    /// Alert width.
    public typealias Width = SingleDimensionModalComponentSize

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Button State Colors
    /// Model that contains colors for button component states.
    public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
