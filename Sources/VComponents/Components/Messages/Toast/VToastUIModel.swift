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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VToastUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Width type. Set to `default`.
        public var widthType: WidthType = .default
        
        /// Corner radius type. Set to `default`.
        public var cornerRadiusType: CornerRadiusType = .default
        
        /// Text line type. Set to `default`.
        public var textLineType: TextLineType = .default
        
        /// Text margins. Set to `20` horizontal and `12` vertical.
        public var textMargins: Margins = .init(
            horizontal: 20,
            vertical: 12
        )
        
        /// Edge from which toast appears, and to which it disappears. Set to `default`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Safe area inset from presented edge. Set to `10`.
        public var presentationEdgeSafeAreaInset: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Width Type
        /// Enum that represents width type, such as `wrapped`, `stretched`, `fixedPoint`, or `fixedFraction`.
        public enum WidthType {
            // MARK: Cases
            /// Toast only takes required width, and container wraps it's content.
            ///
            /// Margin can be specified to space out toast from the edges of the screen.
            case wrapped(margin: CGFloat)
            
            /// Toast stretches to full width with an alignment.
            ///
            /// Alignment may not be sufficient to affect multi-line text contents.
            /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
            ///
            /// Margin can be specified to space out toast from the edges of the screen.
            case stretched(alignment: HorizontalAlignment, margin: CGFloat)
            
            /// Toast takes specified width with an alignment.
            ///
            /// Alignment may not be sufficient to affect multi-line text contents.
            /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
            case fixedPoint(width: CGFloat, alignment: HorizontalAlignment)
            
            /// Toast takes specified width relative to screen ratio, with an alignment.
            ///
            /// Alignment may not be sufficient to affect multi-line text contents.
            /// To achieve desired result, modify `alignment` in `TextLineType.multiline(..)`.
            case fixedFraction(ratio: CGFloat, alignment: HorizontalAlignment)
            
            // MARK: Initializers
            /// Default value. Set to `wrapped` with  `20` `margin`.
            public static var `default`: Self { .wrapped(margin: 20) }
        }
        
        // MARK: Corner Radius Type
        /// Enum that represents corner radius, such as `capsule` or `rounded`.
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
        /// Enum that represents text line, such as `singleLine` or `multiLine`.
        public enum TextLineType {
            // MARK: Cases
            /// Single-line.
            case singleLine
            
            /// Multi-line.
            case multiLine(alignment: TextAlignment, lineLimit: Int?)
            
            // MARK: Properties
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
        
        // MARK: Presentation Edge
        /// Enum that represents presentation edge, such as `top` or `bottom`.
        public enum PresentationEdge: Int, CaseIterable {
            // MARK: Cases
            /// Presentation from top.
            case top
            
            /// Presentation from bottom.
            case bottom

            // MARK: Properties
            var alignment: Alignment {
                switch self {
                case .top: return .top
                case .bottom: return .bottom
                }
            }
            
            // MARK: Initializers
            /// Default value. Set to `bottom`.
            public static var `default`: Self { .bottom }
        }
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = GlobalUIModel.Messages.layerGray
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Set to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Set to `zero`.
        public var shadowOffset: CGPoint = .zero
        
        /// Text color.
        public var text: Color = ColorBook.primary
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Text font. Set to `headline` (`17`).
        public var text: Font = .headline
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Display duration. Set to `3` seconds.
        public var duration: TimeInterval = 3
        
        /// Appear animation. Set to `easeOut` with duration `0.2`.
        public var appear: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)
        
        /// Disappear animation. Set to `easeIn` with duration `0.2`.
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)
        
#if os(iOS)
        /// Haptic feedback type. Set to `nil`.
        public var haptic: UINotificationFeedbackGenerator.FeedbackType? = nil
#endif
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}

// MARK: - Factory (Highlights)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VToastUIModel {
    /// `VToastUIModel` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .success
        
#if os(iOS)
        uiModel.animations.haptic = .success
#endif
        
        return uiModel
    }
    
    /// `VToastUIModel` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .warning
        
#if os(iOS)
        uiModel.animations.haptic = .warning
#endif
        
        return uiModel
    }
    
    /// `VToastUIModel` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.colors = .error
        
#if os(iOS)
        uiModel.animations.haptic = .error
#endif
        
        return uiModel
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VToastUIModel.Colors {
    /// `VToastUIModel.Colors` that applies green color scheme.
    public static var success: Self {
        var uiModel: Self = .init()
        
        uiModel.background = GlobalUIModel.Messages.layerGreen
        
        return uiModel
    }
    
    /// `VToastUIModel.Colors` that applies yellow color scheme.
    public static var warning: Self {
        var uiModel: Self = .init()
        
        uiModel.background = GlobalUIModel.Messages.layerYellow
        
        return uiModel
    }
    
    /// `VToastUIModel.Colors` that applies error color scheme.
    public static var error: Self {
        var uiModel: Self = .init()
        
        uiModel.background = GlobalUIModel.Messages.layerRed
        
        return uiModel
    }
}
