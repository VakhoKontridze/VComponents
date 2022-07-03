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
public struct VToastUIModel {
    // MARK: Properties
    fileprivate static let textFieldReference: VTextFieldUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Toast horizontal margin. Defaults to `20`.
        public var toastHorizontalMargin: CGFloat = 20
        
        /// Corner radius type. Defaults to `default`.
        public var cornerRadiusType: CornerRadiusType = .default
        
        /// Text margins. Defaults to `20` horizontal and `12` vertical.
        public var textMargins: Margins = .init(
            horizontal: 20,
            vertical: 12
        )
        
        /// Edge from which toast appears, and to which it disappears. Defaults to `default`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Safe area inset from presented edge. Defaults to `20`.
        public var presentationEdgeSafeAreaInset: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias Margins = EdgeInsets_HV
        
        // MARK: Presentation Edge
        /// Model that represents presentation edge, such as `top` or `bottom`.
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
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Text color.
        public var text: Color = ColorBook.primary
        
        /// Background color.
        public var background: Color = textFieldReference.colors.background.enabled
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Text font. Defaults to system font of size `16` and weight `semibold`.
        ///
        /// Font is of type `UIFont`, as height must be calculated.
        public var text: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Display duration. Defaults to `3` seconds.
        public var duration: TimeInterval = 3
        
        /// Appear animation. Defaults to `easeOut` with duration `0.2`.
        public var appear: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)
        
        /// Disappear animation. Defaults to `easeIn` with duration `0.2`.
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
