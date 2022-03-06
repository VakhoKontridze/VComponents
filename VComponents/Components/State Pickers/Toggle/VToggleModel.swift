//
//  VToggleRightContentModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Toggle Model
/// Model that describes UI.
public struct VToggleModel {
    // MARK: Properties
    /// Reference to `VPrimaryButtonModel`.
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    
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
        /// Toggle size. Defaults to `51` width and `32` height, similarly to native toggle.
        public var size: CGSize = .init(width: 51, height: 31)
        
        var cornerRadius: CGFloat { size.height }
        
        /// Thumb dimension. Defaults to `27`, similarly to native toggle.
        public var thumbDimension: CGFloat = 27
        
        /// Content leading margin. Defaults to `5`.
        public var contentMarginLeading: CGFloat = 5
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumnStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumnStartPoint - spacing
            return offset
        }
        
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
            off: .init(componentAsset: "Toggle.Fill.off"),
            on: primaryButtonReference.colors.background.enabled,
            pressedOff: .init(componentAsset: "Toggle.Fill.pressedOff"),
            pressedOn: primaryButtonReference.colors.background.pressed,
            disabled: .init(componentAsset: "Toggle.Fill.disabled")
        )
        
        /// Thumb colors.
        public var thumb: StateColors = .init(
            off: .init(componentAsset: "Toggle.Thumb"),
            on: .init(componentAsset: "Toggle.Thumb"),
            pressedOff: .init(componentAsset: "Toggle.Thumb"),
            pressedOn: .init(componentAsset: "Toggle.Thumb"),
            disabled: .init(componentAsset: "Toggle.Thumb")
        )
        
        /// Title colors.
        public var title: StateColors = .init(
            off: ColorBook.primary,
            on: ColorBook.primary,
            pressedOff: ColorBook.primary,
            pressedOn: ColorBook.primary,
            disabled: ColorBook.secondary
        )
        
        /// Custom content opacities.
        ///
        /// Applicable only when init with content is used.
        /// When using a custom content, it's subviews cannot be configured with indivudual colors,
        /// so instead, a general opacity is being applied.
        public var customContentOpacities: StateOpacities = .init(
            off: 1,
            on: 1,
            pressedOff: 1,
            pressedOn: 1,
            disabled: 0.5
        )
        
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
        /// Only applicable when using init with title.
        public var title: Font = .system(size: 15)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = .easeIn(duration: 0.1)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if content is clickable. Defaults to `true`.
        public var contentIsClickable: Bool = true
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
