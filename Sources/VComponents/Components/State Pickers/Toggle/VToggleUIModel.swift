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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
        /// Toggle size.
        /// Set to `51x32` on `iOS`, similarly to native toggle.
        /// Set to `38x22` on `macOS`, similarly to native toggle.
        public var size: CGSize = {
#if os(iOS)
            return CGSize(width: 51, height: 31)
#elseif os(macOS)
            return CGSize(width: 38, height: 22)
#else
            fatalError() // Not supported
#endif
        }()
        
        var cornerRadius: CGFloat { size.height }
        
        /// Thumb dimension.
        /// Set to `27` on `iOS`, similarly to native toggle.
        /// Set to `20` on `macOS`, similarly to native toggle.
        public var thumbDimension: CGFloat = {
#if os(iOS)
            return 27
#elseif os(macOS)
            return 20
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Spacing between toggle and label. Set to `5`.
        public var toggleLabelSpacing: CGFloat = GlobalUIModel.StatePickers.statePickerLabelSpacing
        
        /// Title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
        public var titleTextLineType: TextLineType = GlobalUIModel.StatePickers.titleTextLineType
        
        /// Title minimum scale factor. Set to `1`.
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
        /// Title font.
        /// Set to `subheadline` (`15`) on `iOS`.
        /// Set to `body` (`13`) on `macOS`.
        public var title: Font = GlobalUIModel.StatePickers.font
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
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
