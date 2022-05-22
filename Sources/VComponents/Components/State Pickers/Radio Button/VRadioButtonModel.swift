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
    fileprivate static let toggleRefrence: VToggleModel = .init()
    fileprivate static let checkBoxReference: VCheckBoxModel = .init()
    
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
        
        /// Spacing between radio and label. Defaults to `5`.
        public var radioLabelSpacing: CGFloat = checkBoxReference.layout.checkBoxLabelSpacing
        
        /// Title label line limit. Defaults to `nil`.
        public var titleLabelLineLimit: Int? = checkBoxReference.layout.titleLabelLineLimit
        
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
            off: ColorBook.layer,
            on: ColorBook.layer,
            pressedOff: ColorBook.layer,
            pressedOn: ColorBook.layer,
            disabled: ColorBook.layer
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            off: checkBoxReference.colors.border.off,
            on: toggleRefrence.colors.fill.on,
            pressedOff: checkBoxReference.colors.border.pressedOff,
            pressedOn: toggleRefrence.colors.fill.pressedOn,
            disabled: checkBoxReference.colors.border.disabled
        )
        
        /// Bullet colors.
        public var bullet: StateColors = .init(
            off: .clear,
            on: toggleRefrence.colors.fill.on,
            pressedOff: .clear,
            pressedOn: toggleRefrence.colors.fill.pressedOn,
            disabled: .clear
        )

        /// Title colors.
        public var title: StateColors = toggleRefrence.colors.title
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init`with label is used.
        /// When using a custom label, it's subviews cannot be configured with indivudual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = toggleRefrence.colors.customLabelOpacities

        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_OOPD<Color>

        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_OOPD<CGFloat>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using `init`with title.
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
        /// Indicates if label is clickable. Defaults to `true`.
        public var labelIsClickable: Bool = toggleRefrence.misc.labelIsClickable
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
