//
//  VCheckBoxUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V CheckBox UI Model
/// Model that describes UI.
public struct VCheckBoxUIModel {
    // MARK: Properties
    fileprivate static let toggleReference: VToggleUIModel = .init()
    
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
        /// Checkbox dimension. Defaults to `16.`
        public var dimension: CGFloat = 16
        
        /// Checkbox corner radius. Defaults to `5.`
        public var cornerRadius: CGFloat = 4
        
        /// Checkbox border width. Defaults to `1.`
        public var borderWith: CGFloat = 1
        
        /// Checkmark icon dimension. Defaults to `9.`
        public var iconDimension: CGFloat = 9
        
        /// Hit box. Defaults to `5`.
        public var hitBox: CGFloat = toggleReference.layout.toggleLabelSpacing
        
        /// Spacing between checkbox and label. Defaults to `0`.
        public var checkBoxLabelSpacing: CGFloat = 0
        
        /// Title line type. Defaults to `multiline` of `1...2` lines.
        public var titleLineType: TextLineType = toggleReference.layout.titleLineType

        /// Title minimum scale factor. Defaults to `1`.
        public var titleMinimumScaleFactor: CGFloat = toggleReference.layout.titleMinimumScaleFactor
        
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
            on: toggleReference.colors.fill.on,
            indeterminate: toggleReference.colors.fill.on,
            pressedOff: ColorBook.layer,
            pressedOn: toggleReference.colors.fill.pressedOn,
            pressedIndeterminate: toggleReference.colors.fill.pressedOn,
            disabled: ColorBook.layer
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: .clear,
            indeterminate: .clear,
            pressedOff: .init(componentAsset: "CheckBox.Border.pressedOff"),
            pressedOn: .clear,
            pressedIndeterminate: .clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        /// Checkmark icon colors.
        public var checkmark: StateColors = .init(
            off: .clear,
            on: toggleReference.colors.thumb.off,
            indeterminate: toggleReference.colors.thumb.on,
            pressedOff: .clear,
            pressedOn: toggleReference.colors.thumb.pressedOn,
            pressedIndeterminate: toggleReference.colors.thumb.pressedOn,
            disabled: .clear
        )

        /// Title colors.
        public var title: StateColors = .init(
            off: ColorBook.primary,
            on: ColorBook.primary,
            indeterminate: ColorBook.primary,
            pressedOff: ColorBook.primary,
            pressedOn: ColorBook.primary,
            pressedIndeterminate: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom label opacities.
        ///
        /// Applicable only when `init` with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            off: 1,
            on: 1,
            indeterminate: 1,
            pressedOff: 1,
            pressedOn: 1,
            pressedIndeterminate: 1,
            disabled: 0.3
        )

        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_OffOnIndeterminatePressedDisabled<Color>

        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_OffOnIndeterminatePressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using `init` with title.
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
