//
//  VNotificationUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 15.07.24.
//

import SwiftUI
import VCore

// MARK: - V Notification UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VNotificationUIModel {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()
        uiModel.alignment = presentationEdge.toAlignment
        return uiModel
    }

    /// Widths.
    public var widths: Widths = .init(
        portrait: .stretched(marginHorizontal: 15),
        landscape: .fixed(widthFraction: 0.5)
    )

    /// Edge from which notification appears, and to which it disappears. Set to `top`.
    public var presentationEdge: VerticalEdge = .top

    /// Margin from presented edge. Set to `5`.
    public var marginPresentedEdge: CGFloat = 5

    // MARK: Properties - Corners
    /// Corner radius. Set to `12`.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.secondarySystemBackground)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Body
    /// Body margins. Set to `15`s.
    public var bodyMargins: Margins = .init(15)

    /// Spacing between icon and title/messages texts. Set to `12`.
    public var iconAndTitleTextMessageTextSpacing: CGFloat = 12

    /// Spacing between tile text and message text. Set to `2`.
    public var titleTextAndMessageTextSpacing: CGFloat = 2

    // MARK: Properties - Body - Icon
    /// Indicates if `resizable(...)` modifier is applied to icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconResizable: Bool = true

    /// Icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconContentMode: ContentMode? = .fit

    /// Icon size. Set to `(22, 22)`.
    public var iconSize: CGSize? = .init(dimension: 22)

    /// Icon color.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconColor: Color? = .primary

    /// Icon opacity. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconOpacity: CGFloat?

    /// Icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconResizable` should be set to `false`, and `iconSize` should be set to `nil`.
    public var iconFont: Font?

    /// Icon `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Body - Icon Background
    /// Icon background size. Set to `(44, 44)`.
    public var iconBackgroundSize: CGSize = .init(dimension: 44)

    /// Icon background corner radius. Set to `10`.
    public var iconBackgroundCornerRadius: CGFloat = 10

    /// Icon background color.
    public var iconBackgroundColor: Color = {
#if os(iOS)
        Color.dynamic(
            Color(uiColor: UIColor.secondarySystemBackground).darken(by: 0.05),
            Color(22, 22, 22)
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Body - Title
    /// Title text frame alignment. Set to `leading`.
    public var titleTextFrameAlignment: HorizontalAlignment = .leading

    /// Title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text color.
    public var titleTextColor: Color = .primary

    /// Title text font. Set to `semibold` `callout`.
    public var titleTextFont: Font = .callout.weight(.semibold)

    /// Title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Body - Message
    /// Message text frame alignment. Set to `leading`.
    public var messageTextFrameAlignment: HorizontalAlignment = .leading

    /// Message line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Title text minimum scale factor. Set to `0.75`.
    public var messageTextMinimumScaleFactor: CGFloat = 0.75

    /// Message text color.
    public var messageTextColor: Color = .primary

    /// Message text font. Set to `callout`.
    public var messageTextFont: Font = .callout

    /// Message text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar. Set to `default`.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear
    /// Appear animation. Set to `easeOut` with duration `0.2`.
    public var appearAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation. Set to `easeIn` with duration `0.2`.
    ///
    /// This is a standard disappear animation. Other dismiss methods, such as pull-down, are handled elsewhere.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)

    // MARK: Properties - Transition - Timeout Dismiss
    /// Timeout duration. Set to `5` seconds.
    ///
    /// Has no effect unless `dismissType` includes `timeout`.
    public var timeoutDuration: TimeInterval = 5

    // MARK: Properties - Transition - Swipe Dismiss
    /// Ratio of height to drag notification by to initiate dismiss. Set to `0.2`.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissDistanceHeightRatio: CGFloat = 0.2

    func swipeDismissDistance(in containerDimension: CGFloat) -> CGFloat { swipeDismissDistanceHeightRatio * containerDimension }

    /// Swipe dismiss animation. Set to `easeInOut` with duration `0.2`.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.2)

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius. Set to `20`.
    public var shadowRadius: CGFloat = 20

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback type. Set to `nil`.
    public var haptic: UINotificationFeedbackGenerator.FeedbackType?
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Widths
    /// Notification widths..
    public typealias Widths = ModalComponentSizeGroup<Width>

    // MARK: Width
    /// Notification width.
    public struct Width: Equatable {
        // MARK: Properties
        let storage: Storage

        // MARK: Initializers
        init(
            _ storage: Storage
        ) {
            self.storage = storage
        }

        /// Notification takes specified width.
        public static func fixed(
            width: CGFloat
        ) -> Self {
            self.init(
                .fixed(
                    width: width
                )
            )
        }

        /// Notification takes specified width fraction, relative to container.
        public static func fixed(
            widthFraction: CGFloat
        ) -> Self {
            self.init(
                .fixedFraction(
                    widthFraction: widthFraction
                )
            )
        }

        /// Notification stretches to full width.
        public static func stretched(
            marginHorizontal: CGFloat
        ) -> Self {
            self.init(
                .stretched(
                    marginHorizontal: marginHorizontal
                )
            )
        }

        // MARK: Storage
        enum Storage: Equatable {
            case fixed(width: CGFloat)
            case fixedFraction(widthFraction: CGFloat)

            case stretched(marginHorizontal: CGFloat)
        }
    }

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Dismiss Type
    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet {
        // MARK: Options
        private enum Options: Int {
            case timeout
            case swipe
        }

        // MARK: Options Initializers
        /// Default value. Set to `all`.
        public static var `default`: DismissType { .all }
    }
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VNotificationUIModel {
    /// `VNotificationUIModel` that applies blue color scheme.
    public static var info: Self {
        var uiModel: Self = .init()

        uiModel.applyInfoColorScheme()

#if os(iOS)
        uiModel.haptic = .success
#endif

        return uiModel
    }

    /// `VNotificationUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()

        uiModel.applySuccessColorScheme()

#if os(iOS)
        uiModel.haptic = .success
#endif

        return uiModel
    }

    /// `VNotificationUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()

        uiModel.applyWarningColorScheme()

#if os(iOS)
        uiModel.haptic = .warning
#endif

        return uiModel
    }

    /// `VNotificationUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()

        uiModel.applyErrorColorScheme()

#if os(iOS)
        uiModel.haptic = .error
#endif

        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VNotificationUIModel {
    /// Applies blue color scheme to `VNotificationUIModel`.
    mutating public func applyInfoColorScheme() {
        applyHighlightedColors(
            background: Color.dynamic(Color(0, 160, 240), Color(0, 100, 190)),
            iconBackground: Color.dynamic(Color(0, 130, 210), Color(0, 75, 15))
        )
    }

    /// Applies green color scheme to `VNotificationUIModel`.
    mutating public func applySuccessColorScheme() {
        applyHighlightedColors(
            background: Color.dynamic(Color(70, 190, 125), Color(40, 135, 75)),
            iconBackground: Color.dynamic(Color(40, 160, 95), Color(10, 105, 45))
        )
    }

    /// Applies yellow color scheme to `VNotificationUIModel`.
    mutating public func applyWarningColorScheme() {
        applyHighlightedColors(
            background: Color.dynamic(Color(255, 205, 95), Color(230, 160, 40)),
            iconBackground: Color.dynamic(Color(225, 175, 65), Color(200, 130, 10))
        )
    }

    /// Applies red color scheme to `VNotificationUIModel`.
    mutating public func applyErrorColorScheme() {
        applyHighlightedColors(
            background: Color.dynamic(Color(235, 95, 90), Color(205, 50, 45)),
            iconBackground:Color.dynamic(Color(205, 65, 60), Color(175, 20, 15))
        )
    }

    private mutating func applyHighlightedColors(
        background: Color,
        iconBackground: Color
    ) {
        backgroundColor = background

        iconBackgroundColor = iconBackground
    }
}

// MARK: - Helpers
extension VerticalEdge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        }
    }
}
