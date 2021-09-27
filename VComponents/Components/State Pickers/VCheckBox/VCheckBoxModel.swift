//
//  VCheckBoxModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - V CheckBox Model
/// Model that describes UI
public struct VCheckBoxModel {
    // MARK: Properties
    /// Reference to `VToggleModel`
    public static let toggleReference: VToggleModel = .init()
    
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

    // MARK: Initializers
    /// Initializes model with default values
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties
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
        public var hitBox: CGFloat = toggleReference.layout.contentMarginLeading
        
        /// Content leading margin. Defaults to `0`.
        public var contentMarginLeading: CGFloat = 0
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties
    public struct Colors {
        // MARK: Properties
        /// Fill colors
        public var fill: StateColors = .init(
            off: ColorBook.primaryInverted,
            on: toggleReference.colors.fill.on,
            indeterminate: toggleReference.colors.fill.on,
            disabled: ColorBook.primaryInverted
        )
        
        /// Border colors
        public var border: StateColors = .init(
            off: .init(componentAsset: "CheckBox.Border.off"),
            on: ColorBook.clear,
            indeterminate: ColorBook.clear,
            disabled: .init(componentAsset: "CheckBox.Border.disabled")
        )
        
        /// Checkmark icon colors
        public var icon: StateColors = .init(
            off: ColorBook.clear,
            on: toggleReference.colors.thumb.off,
            indeterminate: toggleReference.colors.thumb.on,
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
            indeterminate: toggleReference.colors.textContent.on,
            disabled: toggleReference.colors.textContent.disabled
        )

        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states
        public typealias StateColors = StateColors_OOID

        // MARK: State Opacities
        /// Sub-model containing opacities for component states
        public typealias StateOpacities = StateOpacities_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `15`.
        ///
        /// Only applicable when using init with title
        public var title: Font = toggleReference.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = toggleReference.animations.stateChange
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties
    public struct Misc {
        // MARK: Properties
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = toggleReference.misc.contentIsClickable
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }
}
