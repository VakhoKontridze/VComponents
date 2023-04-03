//
//  VRoundedButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rounded Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
public struct VRoundedButtonUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button dimension.
        /// Set to `56x56` on `iOS`.
        /// Set to `28x28` on `macOS`.
        /// Set to `65x56` on `watchOS`.
        public var size: CGSize = GlobalUIModel.Buttons.sizeRoundedButton
        
        /// Corner radius.
        /// Set to `16` on `iOS`.
        /// Set to `6` on `macOS`.
        /// Set to `16` on `watchOS`.
        public var cornerRadius: CGFloat = {
#if os(iOS)
            return 16
#elseif os(macOS)
            return 6
#elseif os(watchOS)
            return 16
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Border width. Set to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Set to `3`s.
        public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMarginsRoundedButton
        
        /// Title minimum scale factor. Set to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Icon size.
        /// Set to `20x20` on `iOS`.
        /// Set to `14x14` on `macOS`.
        /// Set to `20x20` on `watchOS`.
        public var iconSize: CGSize = {
#if os(iOS)
            return CGSize(dimension: 20)
#elseif os(macOS)
            return CGSize(dimension: 14)
#elseif os(watchOS)
            return CGSize(dimension: 20)
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Hit box. Set to `zero`.
        public var hitBox: HitBox = .zero
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Label Margins
        /// Model that contains `horizontal` and `vertical` margins.
        public typealias LabelMargins = EdgeInsets_HorizontalVertical
        
        // MARK: Hit Box
        /// Model that contains `horizontal` and `vertical` hit boxes.
        public typealias HitBox = EdgeInsets_HorizontalVertical
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background colors.
        public var background: StateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            pressed: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.controlLayerBlueDisabled
        )
        
        /// Border colors.
        public var border: StateColors = .clearColors
        
        /// Title colors.
        public var title: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon colors.
        ///
        /// Applied to all images. But should be used for vector images.
        /// In order to use bitmap images, set this to `clear`.
        public var icon: StateColors = .init(ColorBook.primaryWhite)
        
        /// Icon opacities. Set to `1`s.
        ///
        /// Applied to all images. But should be used for bitmap images.
        /// In order to use vector images, set this to `1`s.
        public var iconOpacities: StateOpacities = .init(1)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font.
        /// Set to `semibold` `subheadline` (`15`) on `iOS`.
        /// Set to `body` (`13`) on `macOS`.
        /// Set to `semibold` `body` (`17`) on `watchOS`.
        public var title: Font = {
#if os(iOS)
            return Font.subheadline.weight(.semibold)
#elseif os(macOS)
            return Font.body
#elseif os(watchOS)
            return Font.body.weight(.semibold)
#else
            fatalError() // Not supported
#endif
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Indicates if button animates state change. Defaults to `true`.
        public var animatesStateChange: Bool = true
        
        /// Ratio to which label scales down on press. Set to `1`.
        public var backgroundPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale
        
        /// Ratio to which label scales down on press. Set to `1`.
        public var labelPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale
        
#if os(iOS)
        /// Haptic feedback style. Set to `light`.
        public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = GlobalUIModel.Buttons.hapticIOS
#elseif os(watchOS)
        /// Haptic feedback type. Set to `click`.
        public var haptic: WKHapticType? = GlobalUIModel.Buttons.hapticWatchOS
#endif
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Sub UI Models
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()
        
        uiModel.animations.animatesStateChange = animations.animatesStateChange
        
        return uiModel
    }
}
