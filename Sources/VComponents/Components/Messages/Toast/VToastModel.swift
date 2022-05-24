//
//  VToastModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast Model
/// Model that describes UI.
public struct VToastModel {
    // MARK: Properties
    fileprivate static let textFieldReference: VTextFieldModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Toast sizes.
        /// Set to `0.8` ratio of screen width in portrait.
        /// Set to `0.8` ratio of screen width in landscape.
        public var sizes: Sizes = .init(
            portrait: .relative(.init(width: 0.8)),
            landscape: .relative(.init(width: 0.8))
        )
        
        /// Corner radius type. Defaults to `default`.
        public var cornerRadiusType: CornerRadiusType = .default
        
        /// TItle margins. Defaults to `20` horizontal and `10` vertical.
        public var titleMargins: Margins = .init(
            horizontal: 20,
            vertical: 10
        )
        
        /// Edge from which toast appears, and to which it disappears. Defaults to `default`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Safe area inset from presented edge. Defaults to `20`.
        public var presentationEdgeSafeAreaInset: CGFloat = 20
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that describes toast sizes.
        public typealias Sizes = ModalSizes<ToastSize>
        
        // MARK: Toast Size
        /// Toast size.
        public struct ToastSize {
            // MARK: Properties
            /// Width.
            public var width: CGFloat
            
            // MARK: Initializers
            /// Initializes `ToastSize`.
            public init(
                width: CGFloat
            ) {
                self.width = width
            }
        }
        
        // MARK: Margins
        /// Sub-model containing `horizontal` and `vertical` margins.
        public typealias Margins = EdgeInsets_HV
        
        // MARK: Presentation Edge
        /// Enum that represents presentation edge, such as `top` or `bottom`.
        public enum PresentationEdge: Int, CaseIterable {
            // MARK: Cases
            /// Presentation from top.
            case top
            
            /// Presentation from bottom.
            case bottom
            
            // MARK: Initailizers
            /// Default value. Set to `bottom`.
            public static var `default`: Self { .bottom }
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

            // MARK: Initailizers
            /// Default value. Set to `rounded`.
            public static var `default`: Self { .capsule }
        }
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Title color.
        public var title: Color = ColorBook.primary
        
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
        /// Title font. Defaults to system font of size `16` and weight `semibold`.
        public var title: Font = .system(size: 16, weight: .semibold)
        
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
