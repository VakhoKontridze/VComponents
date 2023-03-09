//
//  VToggleUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Toggle UI Model
/// Model that describes UI.
public struct VToggleUIModel {
    // MARK: Properties
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
        /// Toggle size. Defaults to `51` width and `32` height, similarly to native toggle.
        public var size: CGSize = .init(width: 51, height: 31)
        
        var cornerRadius: CGFloat { size.height }
        
        /// Thumb dimension. Defaults to `27`, similarly to native toggle.
        public var thumbDimension: CGFloat = 27
        
        /// Spacing between toggle and label. Defaults to `5`.
        public var toggleLabelSpacing: CGFloat = GlobalUIModel.StatePickers.statePickerLabelSpacing
        
        /// Title text line type. Defaults to `multiline` with `leading` alignment and `1...2` lines.
        public var titleTextLineType: TextLineType = GlobalUIModel.StatePickers.titleTextLineType
        
        /// Title minimum scale factor. Defaults to `1`.
        public var titleMinimumScaleFactor: CGFloat = 1
        
        var animationOffset: CGFloat {
            let spacing: CGFloat = (size.height - thumbDimension)/2
            let thumbStartPoint: CGFloat = (size.width - thumbDimension)/2
            let offset: CGFloat = thumbStartPoint - spacing
            return offset
        }
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Fill colors.
        public var fill: StateColors = .init(
            off: ColorBook.layerGray,
            on: ColorBook.controlLayerBlue,
            pressedOff: ColorBook.layerGrayPressed,
            pressedOn: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.layerGrayDisabled
        )
        
        /// Thumb colors.
        public var thumb: StateColors = .init(ColorBook.white)
        
        /// Title colors.
        public var title: StateColors = .init(
            off: ColorBook.primary,
            on: ColorBook.primary,
            pressedOff: ColorBook.primary,
            pressedOn: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom label opacities. Defaults to `1` off, `1` on, `1` pressed off, `1` pressed on, and `0.3` disabled.
        ///
        /// Applicable only when `init` with label is used.
        /// When using a custom label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customLabelOpacities: StateOpacities = .init(
            off: 1,
            on: 1,
            pressedOff: 1,
            pressedOn: 1,
            disabled: GlobalUIModel.StatePickers.customLabelOpacityDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
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
        /// Only applicable when using `init` with title.
        public var title: Font = GlobalUIModel.StatePickers.font
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// State change animation. Defaults to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = GlobalUIModel.StatePickers.stateChangeAnimation
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if label is clickable. Defaults to `true`.
        public var labelIsClickable: Bool = true
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
