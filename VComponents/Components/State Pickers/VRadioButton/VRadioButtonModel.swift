//
//  VRadioButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Radio Button Model
/// Model that describes UI
public struct VRadioButtonModel {
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
extension VRadioButtonModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Radio button dimension. Defaults to `16.`
        public var dimension: CGFloat = checkBoxReference.layout.dimension
        
        /// Radio button corner radius. Defaults to `5.`
        public var borderWith: CGFloat = checkBoxReference.layout.borderWith
        
        /// Bullet dimension. Defaults to `8`.
        public var bulletDimension: CGFloat = 8
        
        /// Hit box. Defaults to `5`.
        public var hitBox: CGFloat = checkBoxReference.layout.hitBox
        
        /// Content leading margin. Defaults to `5`
        public var contentMarginLeading: CGFloat = checkBoxReference.layout.contentMarginLeading
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VRadioButtonModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Fill colors
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted
        )
        
        /// Border colors
        public var border: StateColors = .init(
            off: checkBoxReference.colors.border.off,
            on: checkBoxReference.colors.fill.on,
            disabled: checkBoxReference.colors.border.disabled
        )
        
        /// Bullet colors
        public var bullet: StateColors = .init(
            off: ColorBook.clear,
            on: checkBoxReference.colors.fill.on,
            disabled: ColorBook.clear
        )

        /// Content opacities
        public var content: StateOpacities = checkBoxReference.colors.content

        /// Text content colors
        ///
        /// Only applicable when using init with title
        public var textContent: StateColors = .init(
            off: checkBoxReference.colors.textContent.off,
            on: checkBoxReference.colors.textContent.on,
            disabled: checkBoxReference.colors.textContent.disabled
        )

        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VRadioButtonModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_OOD

    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacities_PD
}

// MARK:- Fonts
extension VRadioButtonModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using init with title
        public var title: Font = toggleRefrence.fonts.title
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VRadioButtonModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = toggleRefrence.animations.stateChange
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VRadioButtonModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = toggleRefrence.misc.contentIsClickable
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VRadioButtonModel {
    /// Reference to `VToggleModel`
    public static let toggleRefrence: VToggleModel = .init()
    
    /// Reference to `VCheckBoxModel`
    public static let checkBoxReference: VCheckBoxModel = .init()
}
