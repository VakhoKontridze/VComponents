//
//  VToastModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- V Toast Model
/// Model that describes UI
public struct VToastModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VToastModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Edge from which toast appears, and to which it disappears. Defaults to `default`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Distance from presented edge. Defaults to `20`.
        public var presentationOffsetFromSafeEdge: CGFloat = 20
        
        /// Max width. Defaults to `0.9` ration of screen width.
        public var maxWidth: CGFloat = UIScreen.main.bounds.width * 0.9
        
        /// Corner radius type. Defaults to `default`.
        public var cornerRadiusType: CornerRadiusType = .default
        
        /// Content margins. Defaults to `20` horizontal and `10` vertical
        public var contentMargins: Margins = .init(
            horizontal: 20,
            vertical: 20
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VToastModel.Layout {
    /// Enum that represents presentation edge, such as top or bottom
    public enum PresentationEdge: Int, CaseIterable {
        /// Presentation from top
        case top
        
        /// Presentation from bottom
        case bottom
        
        /// Default value. Set to `bottom`.
        public static let `default`: Self = .bottom
    }
    
    /// Enum that represents corner radius, such as rounded or custom
    public enum CornerRadiusType {
        /// Rounded corner radius
        ///
        /// This case automatically calculates height and takes half of its value.
        case rounded
        
        /// Custom
        case custom(_ value: CGFloat)

        /// Default value. Set to `rounded`.
        public static let `default`: Self = .rounded
    }
    
    /// Sub-model containing horizontal and vertical margins
    public typealias Margins = LayoutGroupHV
}

// MARK:- Colors
extension VToastModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Text color
        public var text: Color = ColorBook.primary
        
        /// Background color
        public var background: Color = textFieldReference.colors.background.enabled
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Fonts
extension VToastModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Text font. Defaults to system font of size `16` and weight `semibold`.
        public var text: Font = .system(size: 16, weight: .semibold)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VToastModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// Display duration. Defaults to `3` seconds.
        public var duration: TimeInterval = 3
        
        /// Appear animation. Defaults to `easeOut` with duration `0.2`.
        public var appear: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)
        
        /// Disappear animation. Defaults to `easeIn` with duration `0.2`.
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VToastModel {
    /// Reference to VTextFieldModel
    public static let textFieldReference: VTextFieldModel = .init()
}
