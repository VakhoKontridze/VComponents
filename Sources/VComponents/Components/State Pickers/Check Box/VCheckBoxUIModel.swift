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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VCheckBoxUIModel {
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
        /// Checkbox dimension. Set to `16.`
        public var dimension: CGFloat = GlobalUIModel.StatePickers.dimension
        
        /// Checkbox corner radius. Set to `5.`
        public var cornerRadius: CGFloat = 4
        
        /// Checkbox border width. Set to `1.`
        public var borderWidth: CGFloat = 1
        
        /// Checkmark icon dimension. Set to `9.`
        public var checkmarkIconDimension: CGFloat = 9
        
        /// Hit box. Set to `5`.
        public var hitBox: CGFloat = GlobalUIModel.StatePickers.componentAndLabelSpacing // Actual spacing is 0
        
        /// Spacing between checkbox and label. Set to `0`.
        public var checkBoxAndLabelSpacing: CGFloat = 0
        
        /// Title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
        public var titleTextLineType: TextLineType = GlobalUIModel.StatePickers.titleTextLineType
        
        /// Title text minimum scale factor. Set to `1`.
        public var titleTextMinimumScaleFactor: CGFloat = 1
        
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
            off: ColorBook.layer,
            on: ColorBook.controlLayerBlue,
            indeterminate: ColorBook.controlLayerBlue,
            pressedOff: ColorBook.layer,
            pressedOn: ColorBook.controlLayerBluePressed,
            pressedIndeterminate: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.layer
        )
        
        /// Border colors.
        public var border: StateColors = .init(
            off: ColorBook.borderGray,
            on: .clear,
            indeterminate: .clear,
            pressedOff: ColorBook.borderGrayPressed,
            pressedOn: .clear,
            pressedIndeterminate: .clear,
            disabled: ColorBook.borderGrayDisabled
        )
        
        /// Checkmark icon colors.
        public var checkmark: StateColors = .init(
            off: .clear,
            on: ColorBook.white,
            indeterminate: ColorBook.white,
            pressedOff: .clear,
            pressedOn: ColorBook.white,
            pressedIndeterminate: ColorBook.white,
            disabled: .clear
        )
        
        /// Title text colors.
        public var titleText: StateColors = .init(
            off: GlobalUIModel.StatePickers.titleColor,
            on: GlobalUIModel.StatePickers.titleColor,
            indeterminate: GlobalUIModel.StatePickers.titleColor,
            pressedOff: GlobalUIModel.StatePickers.titleColor,
            pressedOn: GlobalUIModel.StatePickers.titleColor,
            pressedIndeterminate: GlobalUIModel.StatePickers.titleColor,
            disabled: GlobalUIModel.StatePickers.titleColorDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
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
        /// Title text font.
        /// Set to `subheadline` (`15`) on `iOS`.
        /// Set to `body` (`13`) on `macOS`.
        public var titleText: Font = GlobalUIModel.StatePickers.font
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Indicates if `stateChange` animation is applied. Defaults to `true`.
        ///
        /// Changing this property conditionally will cause view state to be reset.
        ///
        /// If  animation is set to `nil`, a `nil` animation is still applied.
        /// If this property is set to `false`, then no animation is applied.
        ///
        /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
        public var appliesStateChangeAnimation: Bool = true
        
        /// State change animation. Set to `easeIn` with duration `0.1`.
        public var stateChange: Animation? = GlobalUIModel.StatePickers.stateChangeAnimation
        
#if os(iOS)
        /// Haptic feedback style. Set to `light`.
        public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = GlobalUIModel.StatePickers.hapticIOS
#endif
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if label is clickable. Set to `true`.
        public var labelIsClickable: Bool = true
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
}
