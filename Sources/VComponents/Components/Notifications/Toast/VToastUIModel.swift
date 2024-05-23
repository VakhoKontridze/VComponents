//
//  VToastUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VToastUIModel {
    // MARK: Properties - Global
    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.allowsHitTests = false
        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    /// Color scheme. Set to `nil`.
    public var colorScheme: ColorScheme? = nil

    /// Width type. Set to `default`.
    public var widthType: WidthType = .default

    /// Edge from which toast appears, and to which it disappears. Set to `bottom`.
    public var presentationEdge: VerticalEdge = .bottom

    /// Safe area inset from presented edge. Set to `10`.
    public var presentationEdgeSafeAreaInset: CGFloat = 10

    // MARK: Properties - Corners
    /// Corner radius type. Set to `default`.
    public var cornerRadiusType: CornerRadiusType = .default

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = .dynamic(Color(235, 235, 235), Color(60, 60, 60))

    // MARK: Properties - Text
    /// Text line type. Set to `singleLine`.
    public var textLineType: TextLineType = .singleLine

    /// Text minimum scale factor. Set to `0.75`.
    public var textMinimumScaleFactor: CGFloat = 0.75

    /// Text color.
    public var textColor: Color = .primary

    /// Text font. Set to `headline`.
    public var textFont: Font = .headline

    /// Text margins. Set to `(20, 12)`.
    public var textMargins: Margins = .init(
        horizontal: 20,
        vertical: 12
    )

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `none`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy = .none

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Display duration. Set to `3` seconds.
    public var duration: TimeInterval = 3

    /// Appear animation. Set to `easeOut` with duration `0.2`.
    public var appearAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)

    /// Disappear animation. Set to `easeIn` with duration `0.2`.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback type. Set to `nil`.
    public var haptic: UINotificationFeedbackGenerator.FeedbackType? = nil
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Width Type
    /// Enumeration that represents width type, such as `wrapped`, `stretched`, `fixedPoint`, or `fixedFraction`.
    public enum WidthType {
        // MARK: Cases
        /// Toast only takes required width, and container wraps it's content.
        ///
        /// Margin can be specified to space out toast from the edges of the container.
        case wrapped(margin: CGFloat)

        /// Toast stretches to full width with an alignment.
        ///
        /// Alignment may not be sufficient to affect multi-line text contents.
        /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
        ///
        /// Margin can be specified to space out toast from the edges of the container.
        case stretched(alignment: HorizontalAlignment, margin: CGFloat)

        /// Toast takes specified width with an alignment.
        ///
        /// Alignment may not be sufficient to affect multi-line text contents.
        /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
        case fixedPoint(width: CGFloat, alignment: HorizontalAlignment)

        /// Toast takes specified width relative to container ratio, with an alignment.
        ///
        /// Alignment may not be sufficient to affect multi-line text contents.
        /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
        case fixedFraction(ratio: CGFloat, alignment: HorizontalAlignment)

        // MARK: Properties
        var marginHorizontal: CGFloat {
            switch self {
            case .wrapped(let margin): margin
            case .stretched(_, let margin): margin
            case .fixedPoint: 0
            case .fixedFraction: 0
            }
        }

        // MARK: Initializers
        /// Default value. Set to `wrapped` with `20` `margin`.
        public static var `default`: Self { .wrapped(margin: 20) }
    }

    // MARK: Corner Radius Type
    /// Enumeration that represents corner radius, such as `capsule` or `rounded`.
    public enum CornerRadiusType {
        // MARK: Cases
        /// Capsule.
        ///
        /// This case automatically calculates height and takes half of its value.
        case capsule

        /// Rounded.
        case rounded(cornerRadius: CGFloat)

        // MARK: Initializers
        /// Default value. Set to `rounded`.
        public static var `default`: Self { .capsule }
    }

    // MARK: Text Line Type
    /// Enumeration that represents text line, such as `singleLine` or `multiLine`.
    public enum TextLineType {
        // MARK: Cases
        /// Single-line.
        case singleLine

        /// Multi-line.
        case multiLine(alignment: TextAlignment, lineLimit: Int?)

        // MARK: Mapping
        var toVCoreTextLineType: VCore.TextLineType {
            switch self {
            case .singleLine:
                return .singleLine

            case .multiLine(let alignment, let lineLimit):
                return .multiLine(alignment: alignment, lineLimit: lineLimit)
            }
        }

        // MARK: Initializers
        /// Default value. Set to `singleLine`.
        public static var `default`: Self { .singleLine }
    }

    // MARK: Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias Margins = EdgeInsets_HorizontalVertical
}

// MARK: - Factory (Highlights)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VToastUIModel {
    /// `VToastUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.applySuccessColorScheme()
        
#if os(iOS)
        uiModel.haptic = .success
#endif
        
        return uiModel
    }
    
    /// `VToastUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.applyWarningColorScheme()
        
#if os(iOS)
        uiModel.haptic = .warning
#endif
        
        return uiModel
    }
    
    /// `VToastUIModel` that applies error color scheme.
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
extension VToastUIModel {
    /// Applies green color scheme to `VToastUIModel`.
    mutating public func applySuccessColorScheme() {
        backgroundColor = .dynamic(Color(70, 190, 125), Color(40, 135, 75))
    }
    
    /// Applies yellow color scheme to `VToastUIModel`.
    mutating public func applyWarningColorScheme() {
        backgroundColor = .dynamic(Color(255, 205, 95), Color(230, 160, 40))
    }
    
    /// Applies red color scheme to `VToastUIModel`.
    mutating public func applyErrorColorScheme() {
        backgroundColor = .dynamic(Color(235, 95, 90), Color(205, 50, 45))
    }
}
