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
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()

    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VCheckBoxModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Checkbox dimension. Defaults to `16.`
        public var dimension: CGFloat = 16
        
        /// Checkbox corner radius. Defaults to `5.`
        public var cornerRadius: CGFloat = 4
        
        /// Checkbox border width. Defaults to `1.`
        public var borderWith: CGFloat = 1
        
        /// Checkmark icon dimension. Defaults to `9.`
        public var iconDimension: CGFloat = 9
        
        /// Hit box. Defaults to `5`.
        public var hitBox: CGFloat = toggleReference.layout.contentMarginLeading
        
        /// Content leading margin. Defaults to `0`.
        public var contentMarginLeading: CGFloat = 0
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VCheckBoxModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Fill colors
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: toggleReference.colors.fill.on,
            intermediate: toggleReference.colors.fill.on,
            disabled: ColorBook.primaryInverted
        )
        
        /// Border colors
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: ColorBook.clear,
            intermediate: ColorBook.clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        /// Checkmark icon colors
        public var icon: StateColors = .init(
            off: ColorBook.clear,
            on: toggleReference.colors.thumb.off,
            intermediate: toggleReference.colors.thumb.on,
            disabled: ColorBook.clear
        )

        /// Content opacities
        public var content: StateOpacities = .init(
            pressedOpacity: toggleReference.colors.content.pressedOpacity,
            disabledOpacity: toggleReference.colors.content.disabledOpacity
        )

        /// Text content colors
        ///
        /// Only applicable when using init with title
        public var textContent: StateColors = .init(
            off: toggleReference.colors.textContent.off,
            on: toggleReference.colors.textContent.on,
            intermediate: toggleReference.colors.textContent.on,
            disabled: toggleReference.colors.textContent.disabled
        )

        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VCheckBoxModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsOOID

    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacitiesPD
}

// MARK:- Fonts
extension VCheckBoxModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using init with title
        public var title: Font = toggleReference.fonts.title
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VCheckBoxModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = toggleReference.animations.stateChange
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VCheckBoxModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = toggleReference.misc.contentIsClickable
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VCheckBoxModel {
    /// Reference to `VToggleModel`
    public static let toggleReference: VToggleModel = .init()
}
