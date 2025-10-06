//
//  VNotificationAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 15.07.24.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VNotificationAppearance: Equatable, Sendable {
    // MARK: Properties - Global
    var modalPresenterLinkAppearance: ModalPresenterLinkAppearance {
        var appearance: ModalPresenterLinkAppearance = .init()
        appearance.alignment = presentationEdge.toAlignment
        appearance.preferredDimmingViewColor = preferredDimmingViewColor
        return appearance
    }
    
    /// Preferred dimming color, that overrides a shared color from `ModalPresenterRootAppearance`, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Width group.
    public var widthGroup: WidthGroup = .init(
        portrait: .stretched(margin: .absolute(15)),
        landscape: .fixed(width: .fraction(0.5))
    )

    /// Edge from which notification appears, and to which it disappears.
    public var presentationEdge: VerticalEdge = .top

    /// Margin from presented edge.
    public var marginPresentedEdge: CGFloat = 5

    // MARK: Properties - Corners
    /// Corner radius.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.secondarySystemBackground)
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border color.
    public var borderColor: Color = .clear

    // MARK: Properties - Notification Content
    /// Body margins.
    public var bodyMargins: EdgeInsets = .init(15)

    /// Spacing between image, and title and messages texts.
    public var imageAndTextsSpacing: CGFloat = 12

    /// Spacing between tile and message.
    public var titleTextAndMessageTextSpacing: CGFloat = 2

    // MARK: Properties - Notification Content - Image
    /// Indicates if image is resizable.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isImageResizable: Bool = true

    /// Image content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var imageContentMode: ContentMode? = .fit

    /// Image size.
    public var imageSize: CGSize? = .init(dimension: 22)

    /// Image color.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var imageColor: Color? = .primary

    /// Image opacity.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var imageOpacity: CGFloat?

    /// Image font.
    ///
    /// Can be used for setting different weight to SF symbol images.
    /// To achieve this, `isImageResizable` should be set to `false`, and `imageSize` should be set to `nil`.
    public var imageFont: Font?

    /// Image `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var imageDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Notification Content - Image Background
    /// Image background size.
    public var imageBackgroundSize: CGSize = .init(dimension: 44)

    /// Image background corner radius.
    public var imageBackgroundCornerRadius: CGFloat = 10

    /// Image background color.
    public var imageBackgroundColor: Color = {
#if os(iOS)
        Color.dynamic(
            Color(uiColor: UIColor.secondarySystemBackground).darken(by: 0.05),
            Color(22, 22, 22)
        )
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Notification Content - Text
    /// Title text frame alignment.
    public var titleTextFrameAlignment: HorizontalAlignment = .leading

    /// Title text line type...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Title text minimum scale factor.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text color.
    public var titleTextColor: Color = .primary

    /// Title text font.
    public var titleTextFont: Font = .callout.weight(.semibold)

    /// Title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Notification Content - Message
    /// Message text frame alignment.
    public var messageTextFrameAlignment: HorizontalAlignment = .leading

    /// Message line type...2` lines.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextLineType: TextLineType = .multiLine(
        alignment: .leading,
        lineLimit: 1...2
    )

    /// Message text minimum scale factor.
    public var messageTextMinimumScaleFactor: CGFloat = 0.75

    /// Message text color.
    public var messageTextColor: Color = .primary

    /// Message text font.
    public var messageTextFont: Font = .callout

    /// Message text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var messageTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear
    /// Appear animation.
    public var appearAnimation: Animation? = .easeOut(duration: 0.2)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation.
    ///
    /// This is a standard disappear animation. Other dismiss methods, such as pull-down, are handled elsewhere.
    public var disappearAnimation: Animation? = .easeIn(duration: 0.2)

    // MARK: Properties - Transition - Timeout Dismiss
    /// Timeout duration.
    ///
    /// Has no effect unless `dismissType` includes `timeout`.
    public var timeoutDuration: TimeInterval = 5

    // MARK: Properties - Transition - Swipe Dismiss
    /// Ratio of height to drag notification by to initiate dismiss.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissDistanceHeightRatio: CGFloat = 0.2

    func swipeDismissDistance(in containerDimension: CGFloat) -> CGFloat { swipeDismissDistanceHeightRatio * containerDimension }

    /// Swipe dismiss animation.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissAnimation: Animation? = .easeInOut(duration: 0.2)

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius.
    public var shadowRadius: CGFloat = 20

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
    /// Width group.
    public typealias WidthGroup = ModalComponentSizeGroup<Width>

    /// Notification width.
    public enum Width: Equatable, Sendable {
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
    }

    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet, Equatable, Sendable {
        // MARK: Options
        private enum Options: Int {
            case timeout
            case swipe
        }

        // MARK: Options Initializers
        /// Default value.
        public static var `default`: DismissType { .all }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VNotificationAppearance {
    /// `VNotificationAppearance` that applies blue color scheme.
    public static var info: Self {
        var appearance: Self = .init()

        appearance.applyInfoColorScheme()
        appearance.sensoryFeedback = .success

        return appearance
    }

    /// `VNotificationAppearance` that applies green color scheme.
    public static var success: Self {
        var appearance: Self = .init()

        appearance.applySuccessColorScheme()
        appearance.sensoryFeedback = .success

        return appearance
    }

    /// `VNotificationAppearance` that applies yellow color scheme.
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.applyWarningColorScheme()
        appearance.sensoryFeedback = .warning

        return appearance
    }

    /// `VNotificationAppearance` that applies error color scheme.
    public static var error: Self {
        var appearance: Self = .init()

        appearance.applyErrorColorScheme()
        appearance.sensoryFeedback = .error

        return appearance
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VNotificationAppearance {
    /// Applies blue color scheme to `VNotificationAppearance`.
    mutating public func applyInfoColorScheme() {
        backgroundColor = Color.platformDynamic(Color(0, 150, 230), Color(0, 100, 190))

        imageBackgroundColor = Color.platformDynamic(Color(0, 120, 200), Color(0, 75, 15))
    }

    /// Applies green color scheme to `VNotificationAppearance`.
    mutating public func applySuccessColorScheme() {
        backgroundColor = Color.platformDynamic(Color(70, 190, 125), Color(40, 135, 75))

        imageBackgroundColor = Color.platformDynamic(Color(40, 160, 95), Color(10, 105, 45))
    }

    /// Applies yellow color scheme to `VNotificationAppearance`.
    mutating public func applyWarningColorScheme() {
        backgroundColor = Color.platformDynamic(Color(255, 205, 95), Color(230, 160, 40))

        imageBackgroundColor = Color.platformDynamic(Color(225, 175, 65), Color(200, 130, 10))
    }

    /// Applies red color scheme to `VNotificationAppearance`.
    mutating public func applyErrorColorScheme() {
        backgroundColor = Color.platformDynamic(Color(235, 95, 90), Color(205, 50, 45))

        imageBackgroundColor = Color.platformDynamic(Color(205, 65, 60), Color(175, 20, 15))
    }
}

extension VerticalEdge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        }
    }
}
