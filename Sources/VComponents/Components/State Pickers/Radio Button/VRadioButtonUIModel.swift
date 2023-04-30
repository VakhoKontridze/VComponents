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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VRadioButtonUIModel {
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
        /// Radio button dimension. Set to `16.`
        public var dimension: CGFloat = GlobalUIModel.StatePickers.dimension
        
        /// Radio button corner radius. Set to `1.`
        public var borderWidth: CGFloat = 1
        
        /// Bullet dimension. Set to `8`.
        public var bulletDimension: CGFloat = 8
        
        /// Hit box. Set to `5`.
        public var hitBox: CGFloat = GlobalUIModel.StatePickers.componentAndLabelSpacing // Actual spacing is 0
        
        /// Spacing between radio button and label. Set to `0`.
        public var radioButtonAndLabelSpacing: CGFloat = 0
        
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
        public var fill: StateColors = .init(ColorBook.layer)
        
        /// Border colors.
        public var border: StateColors = .init(
            off: ColorBook.borderGray,
            on: ColorBook.controlLayerBlue,
            pressedOff: ColorBook.borderGrayPressed,
            pressedOn: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.borderGrayDisabled
        )
        
        /// Bullet colors.
        public var bullet: StateColors = .init(
            off: .clear,
            on: ColorBook.controlLayerBlue,
            pressedOff: .clear,
            pressedOn: ColorBook.controlLayerBluePressed,
            disabled: .clear
        )
        
        /// Title text colors.
        public var titleText: StateColors = .init(
            off: GlobalUIModel.StatePickers.titleColor,
            on: GlobalUIModel.StatePickers.titleColor,
            pressedOff: GlobalUIModel.StatePickers.titleColor,
            pressedOn: GlobalUIModel.StatePickers.titleColor,
            disabled: GlobalUIModel.StatePickers.titleColorDisabled
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
