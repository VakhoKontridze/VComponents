//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Model Button
/// Model that describes UI
public struct VPlainButtonModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    public init() { }
}

// MARK:- Layout
extension VPlainButtonModel {
    public struct Layout {
        public var hitBoxHor: CGFloat = 5
        public var hitBoxVer: CGFloat = 5
        
        public init() {}
    }
}

// MARK:- Colors
extension VPlainButtonModel {
    public struct Colors {
        public var content: StateOpacities = .init(
            pressedOpacity: 0.5,
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(   // Only applicable during init with title
            enabled: ColorBook.accent,
            pressed: ColorBook.accent,
            disabled: ColorBook.accent
        )
        
        public init() {}
    }
}

extension VPlainButtonModel.Colors {
    public typealias StateColors = StateColorsEPD
    
    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VPlainButtonModel {
    public struct Fonts {
        public var title: Font = squareButtonReference.fonts.title    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- References
extension VPlainButtonModel {
    public static let squareButtonReference: VSquareButtonModel = .init()
}
