//
//  VToastAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VToastAppearance {
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
        portrait: .wrapped(margin: .absolute(15)),
        landscape: .wrapped(maxWidth: .fraction(0.5), margin: .absolute(15))
    )

    /// Margin from presented edge.
    public var marginPresentedEdge: CGFloat = 10

    /// Edge from which toast appears, and to which it disappears.
    public var presentationEdge: VerticalEdge = .bottom

    // MARK: Properties - Corners
    /// Corner radius type.
    public var cornerRadiusType: CornerRadiusType = .default

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = .dynamic(Color(235, 235, 235), Color(60, 60, 60))

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border color.
    public var borderColor: Color = .clear

    // MARK: Properties - Toast Content
    /// Body horizontal alignment.
    public var bodyHorizontalAlignment: HorizontalAlignment = .center

    /// Body margins.
    public var bodyMargins: EdgeInsets = .init(
        horizontal: 20,
        vertical: 12
    )

    // MARK: Properties - Toast Content - Text
    /// Text line type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var textLineType: TextLineType = .singleLine

    /// Text minimum scale factor.
    public var textMinimumScaleFactor: CGFloat = 0.75

    /// Text color.
    public var textColor: Color = .primary

    /// Text font.
    public var textFont: Font = .headline

    /// Text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var textDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear
    /// Appear animation.
    public var appearAnimation: Animation? = .easeOut(duration: 0.2)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation.
    ///
    /// This is a standard disappear animation. Other dismiss methods, such as swipe, are handled elsewhere.
    public var disappearAnimation: Animation? = .easeIn(duration: 0.2)

    // MARK: Properties - Transition - Timeout Dismiss
    /// Timeout duration.
    ///
    /// Has no effect unless `dismissType` includes `timeout`.
    public var timeoutDuration: TimeInterval = 3

    // MARK: Properties - Transition - Swipe Dismiss
    /// Ratio of height to drag toast by to initiate dismiss.
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

    /// Width.
    nonisolated public struct Width: Equatable, Sendable {
        // MARK: Properties
        let storage: Storage

        var margin: AbsoluteFractionMeasurement {
            switch storage {
            case .fixed: .absolute(0)

            case .wrapped(let margin): margin
            case .wrappedMaxWidth(_, let margin): margin

            case .stretched(let margin): margin
            }
        }

        // MARK: Initializers
        init(
            _ storage: Storage
        ) {
            self.storage = storage
        }

        /// Fixed width.
        public static func fixed(
            width: AbsoluteFractionMeasurement
        ) -> Self {
            self.init(
                .fixed(
                    width: width
                )
            )
        }

        /// Wrapped width.
        public static func wrapped(
            margin: AbsoluteFractionMeasurement
        ) -> Self {
            self.init(
                .wrapped(
                    margin: margin
                )
            )
        }

        /// Wrapped width.
        public static func wrapped(
            maxWidth: AbsoluteFractionMeasurement,
            margin: AbsoluteFractionMeasurement
        ) -> Self {
            self.init(
                .wrappedMaxWidth(
                    maxWidth: maxWidth,
                    margin: margin
                )
            )
        }

        /// Stretched width.
        public static func stretched(
            margin: AbsoluteFractionMeasurement
        ) -> Self {
            self.init(
                .stretched(
                    margin: margin
                )
            )
        }

        // MARK: Storage
        nonisolated enum Storage: Equatable {
            case fixed(width: AbsoluteFractionMeasurement)

            case wrapped(margin: AbsoluteFractionMeasurement)
            case wrappedMaxWidth(maxWidth: AbsoluteFractionMeasurement, margin: AbsoluteFractionMeasurement)

            case stretched(margin: AbsoluteFractionMeasurement)
        }
    }

    /// Corner radius.
    nonisolated public enum CornerRadiusType: Equatable, Sendable {
        // MARK: Cases
        /// Capsule.
        ///
        /// This case automatically calculates height and takes half of its value.
        case capsule

        /// Rounded.
        case rounded(cornerRadius: CGFloat)

        // MARK: Initializers
        /// Default value.
        public static var `default`: Self { .capsule }
    }

    /// Text line type.
    nonisolated public enum TextLineType: Equatable, Sendable {
        // MARK: Cases
        /// Single-line.
        case singleLine

        /// Multi-line.
        case multiLine(alignment: TextAlignment, lineLimit: Int?)

        // MARK: Mapping
        var toVCoreTextLineType: VCore.TextLineType {
            switch self {
            case .singleLine:
                .singleLine

            case .multiLine(let alignment, let lineLimit):
                .multiLine(alignment: alignment, lineLimit: lineLimit)
            }
        }

        // MARK: Initializers
        /// Default value.
        public static var `default`: Self { .singleLine }
    }

    /// Dismiss type.
    @OptionSetRepresentation<Int>
    nonisolated public struct DismissType: Equatable, Sendable {
        // MARK: Options
        nonisolated private enum Options: Int {
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
extension VToastAppearance {
    /// `VToastAppearance` that applies blue color scheme.
    public static var info: Self {
        var appearance: Self = .init()
        
        appearance.applyInfoColorScheme()
        appearance.sensoryFeedback = .success
        
        return appearance
    }

    /// `VToastAppearance` that applies green color scheme.
    public static var success: Self {
        var appearance: Self = .init()
        
        appearance.applySuccessColorScheme()
        appearance.sensoryFeedback = .success
        
        return appearance
    }
    
    /// `VToastAppearance` that applies yellow color scheme.
    public static var warning: Self {
        var appearance: Self = .init()
        
        appearance.applyWarningColorScheme()
        appearance.sensoryFeedback = .warning
        
        return appearance
    }
    
    /// `VToastAppearance` that applies error color scheme.
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
extension VToastAppearance {
    /// Applies blue color scheme to `VToastAppearance`.
    mutating public func applyInfoColorScheme() {
        backgroundColor = Color.platformDynamic(Color(0, 150, 230), Color(0, 100, 190))
    }

    /// Applies green color scheme to `VToastAppearance`.
    mutating public func applySuccessColorScheme() {
        backgroundColor = Color.platformDynamic(Color(70, 190, 125), Color(40, 135, 75))
    }
    
    /// Applies yellow color scheme to `VToastAppearance`.
    mutating public func applyWarningColorScheme() {
        backgroundColor = Color.platformDynamic(Color(255, 205, 95), Color(230, 160, 40))
    }
    
    /// Applies red color scheme to `VToastAppearance`.
    mutating public func applyErrorColorScheme() {
        backgroundColor = Color.platformDynamic(Color(235, 95, 90), Color(205, 50, 45))
    }
}

nonisolated extension VerticalEdge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        }
    }
}
