//
//  VRadioButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button UI Model
/// Model that describes UI.
public struct VRadioButtonUIModel {
    // MARK: Properties
    fileprivate static let toggleReference: VToggleUIModel = .init()
    fileprivate static let checkBoxReference: VCheckBoxUIModel = .init()
    
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    /// Model that contains misc properties.
    public var misc: Misc = .init()

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
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
        
        /// Spacing between radio and label. Defaults to `5`.
        public var radioLabelSpacing: CGFloat = checkBoxReference.layout.checkBoxLabelSpacing
        
        /// Title line type. Defaults to `multiline` of `1...2` lines.
        public var titleLineType: TextLineType = checkBoxReference.layout.titleLineType
        
        /// Title minimum scale factor. Defaults to `1`.
        public var titleMinimumScaleFactor: CGFloat = checkBoxReference.layout.titleMinimumScaleFactor
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Fill colors.
        public var fill: StateColors = .init(
            off: ColorBook.layer,
            on: ColorBook.layer,
            pressedOff: ColorBook.layer,
            pressedOn: ColorBook.layer,
            disabled: ColorBook.layer
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            off: checkBoxReference.colors.border.off,
            on: toggleReference.colors.fill.on,
            pressedOff: checkBoxReference.colors.border.pressedOff,
            pressedOn: toggleReference.colors.fill.pressedOn,
            disabled: checkBoxReference.colors.border.disabled
        )
        
        /// Bullet colors.
        public var bullet: StateColors = .init(
            off: .clear,
            on: toggleReference.colors.fill.on,
            pressedOff: .clear,
            pressedOn: toggleReference.colors.fill.pressedOn,
            disabled: .clear
        )

        /// Title colors.
        public var title: StateColors = toggleReference.colors.title
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init`with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = toggleReference.colors.customLabelOpacities

        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>

        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_OffOnPressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using `init`with title.
        public var title: Font = toggleReference.fonts.title
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = toggleReference.animations.stateChange
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if label is clickable. Defaults to `true`.
        public var labelIsClickable: Bool = toggleReference.misc.labelIsClickable
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
}
