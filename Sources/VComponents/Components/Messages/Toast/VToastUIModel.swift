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
        /// Toast horizontal margin. Set to `20`.
        public var toastHorizontalMargin: CGFloat = 20
        
        /// Corner radius type. Set to `default`.
        public var cornerRadiusType: CornerRadiusType = .default
        
        /// Text line type. Set to `default`.
        public var titleTextLineType: TextLineType = .default
        
        /// Text margins. Set to `20` horizontal and `12` vertical.
        public var textMargins: Margins = .init(
            horizontal: 20,
            vertical: 12
        )
        
        /// Edge from which toast appears, and to which it disappears. Set to `default`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Safe area inset from presented edge. Set to `20`.
        public var presentationEdgeSafeAreaInset: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Margins
        /// Model that contains `horizontal` and `vertical` margins.
        public typealias Margins = EdgeInsets_HorizontalVertical
        
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
        
        // MARK: Presentation Edge
        /// Enum that represents presentation edge, such as `top` or `bottom`.
        public enum PresentationEdge: Int, CaseIterable {
            // MARK: Cases
            /// Presentation from top.
            case top
            
            /// Presentation from bottom.
            case bottom
            
            // MARK: Initializers
            /// Default value. Set to `bottom`.
            public static var `default`: Self { .bottom }
        }
        
        // MARK: Corner Radius Type
        /// Model that represents corner radius, such as `capsule` or `rounded`.
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
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Text color.
        public var text: Color = ColorBook.primary
        
        /// Background color.
        public var background: Color = ColorBook.layerGray
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Text font. Set to system font of size `16` and weight `semibold`.
        ///
        /// Font is of type `UIFont`, as height must be calculated.
        public var text: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            
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
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
