//
//  VCheckBoxModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V CheckBox Model
/// Model that describes UI
public struct VCheckBoxModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()

    public init() {}
}

// MARK:- Layout
extension VCheckBoxModel {
    public struct Layout {
        public var dimension: CGFloat = 16
        public var cornerRadius: CGFloat = 4
        
        public var borderWith: CGFloat = 1
        
        public var iconDimension: CGFloat = 9
        
        public var hitBox: CGFloat = toggleReference.layout.contentMarginLeading
        
        public var contentMarginLeading: CGFloat = 0
        
        public init() {}
    }
}

// MARK:- Colors
extension VCheckBoxModel {
    public struct Colors {
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: toggleReference.colors.fill.on,
            intermediate: toggleReference.colors.fill.on,
            disabled: ColorBook.primaryInverted
        )
        
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: .clear,
            intermediate: .clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        public var icon: StateColors = .init(
            off: .clear,
            on: toggleReference.colors.thumb.off,
            intermediate: toggleReference.colors.thumb.on,
            disabled: .clear
        )

        public var content: StateOpacities = .init(
            pressedOpacity: toggleReference.colors.content.pressedOpacity,
            disabledOpacity: toggleReference.colors.content.disabledOpacity
        )

        public var textContent: StateColors = .init(   // Only applicable during init with title
            off: toggleReference.colors.textContent.off,
            on: toggleReference.colors.textContent.on,
            intermediate: toggleReference.colors.textContent.on,
            disabled: toggleReference.colors.textContent.disabled
        )

        public init() {}
    }
}

extension VCheckBoxModel.Colors {
    public typealias StateColors = StateColorsOOID

    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VCheckBoxModel {
    public struct Fonts {
        public var title: Font = toggleReference.fonts.title    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VCheckBoxModel {
    public struct Animations {
        public var stateChange: Animation? = toggleReference.animations.stateChange
        
        public init() {}
    }
}

// MARK:- Misc
extension VCheckBoxModel {
    public struct Misc {
        public var contentIsClickable: Bool = toggleReference.misc.contentIsClickable
        
        public init() {}
    }
}

// MARK:- References
extension VCheckBoxModel {
    public static let toggleReference: VToggleModel = .init()
}
