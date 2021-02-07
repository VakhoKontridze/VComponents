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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VToastModel {
    public struct Layout {
        public var presentationEdge: PresentationEdge = .default
        public var presentationOffsetFromSafeEdge: CGFloat = 20
        
        public var maxWidth: CGFloat = UIScreen.main.bounds.width * 0.9
        
        public var cornerRadiusType: CornerRadiusType = .default
        
        public var contentPaddingHor: CGFloat = 20
        public var contentPaddingVer: CGFloat = 10
        
        public init() {}
    }
}

extension VToastModel.Layout {
    /// Enum that represents presentation edge, such as top or bottom
    public enum PresentationEdge: Int, CaseIterable {
        case top
        case bottom
        
        public static let `default`: Self = .bottom
    }
    
    /// Enum that represents corner radius, such as rounded or custom
    public enum CornerRadiusType {
        case rounded
        case custom(_ value: CGFloat)

        public static let `default`: Self = .rounded
    }
}

// MARK:- Colors
extension VToastModel {
    public struct Colors {
        public var text: Color = ColorBook.primary
        
        public var background: Color = textFieldReference.colors.background.enabled
        
        public init() {}
    }
}

// MARK:- Fonts
extension VToastModel {
    public struct Fonts {
        public var text: Font = .system(size: 16, weight: .semibold)
        
        public init() {}
    }
}

// MARK:- Animations
extension VToastModel {
    public struct Animations {
        public var duration: TimeInterval = 3
        
        public var appear: BasicAnimation? = .init(curve: .easeOut, duration: 0.2)
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.2)
        
        public init() {}
    }
}

// MARK:- References
extension VToastModel {
    public static let textFieldReference: VTextFieldModel = .init()
}
