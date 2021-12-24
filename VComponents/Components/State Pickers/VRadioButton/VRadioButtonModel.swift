//
//  VRadioButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Radio Button Model
/// Model that describes UI.
public struct VRadioButtonModel {
    // MARK: Properties
    /// Reference to `VToggleModel`.
    public static let toggleRefrence: VToggleModel = .init()
    
    /// Reference to `VCheckBoxModel`.
    public static let checkBoxReference: VCheckBoxModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()

    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Radio button dimension. Defaults to `16.`
        public var dimension: CGFloat = checkBoxReference.layout.dimension
        
        /// Radio button corner radius. Defaults to `5.`
        public var borderWith: CGFloat = checkBoxReference.layout.borderWith
        
        /// Bullet dimension. Defaults to `8`.
        public var bulletDimension: CGFloat = 8
        
        /// Hit box. Defaults to `5`.
        public var hitBox: CGFloat = checkBoxReference.layout.hitBox
        
        /// Content leading margin. Defaults to `5`.
        public var contentMarginLeading: CGFloat = checkBoxReference.layout.contentMarginLeading
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Fill colors.
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: ColorBook.primaryInverted,
            pressedOff: ColorBook.primaryInverted,
            pressedOn: ColorBook.primaryInverted,
            disabled: ColorBook.primaryInverted
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            off: toggleRefrence.colors.fill.off,
            on: toggleRefrence.colors.fill.on,
            pressedOff: toggleRefrence.colors.fill.pressedOff,
            pressedOn: toggleRefrence.colors.fill.pressedOn,
            disabled: toggleRefrence.colors.fill.disabled
        )
        
        /// Bullet colors.
        public var bullet: StateColors = .init(
            off: .clear,
            on: toggleRefrence.colors.fill.on,
            pressedOff: toggleRefrence.colors.fill.pressedOff,
            pressedOn: toggleRefrence.colors.fill.pressedOn,
            disabled: .clear
        )

        /// Content opacities.
        public var content: StateOpacities = toggleRefrence.colors.content

        /// Text content colors.
        ///
        /// Only applicable when using init with title.
        public var textContent: StateColors = .init(
            off: toggleRefrence.colors.textContent.off,
            on: toggleRefrence.colors.textContent.on,
            pressedOff: toggleRefrence.colors.textContent.pressedOff,
            pressedOn: toggleRefrence.colors.textContent.pressedOn,
            disabled: toggleRefrence.colors.textContent.disabled
        )

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_OOD

        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = StateOpacities_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using init with title.
        public var title: Font = toggleRefrence.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = toggleRefrence.animations.stateChange
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = toggleRefrence.misc.contentIsClickable
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
