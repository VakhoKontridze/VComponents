//
//  VCapsuleButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Capsule Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
public struct VCapsuleButtonUIModel {
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
        /// Button height.
        /// Set to `32` on `iOS`.
        /// Set to `32` on `macOS`.
        /// Set to `48` on `watchOS`.
        public var height: CGFloat = {
#if os(iOS)
            return GlobalUIModel.Buttons.dimensionIOSSmall
#elseif os(macOS)
            return GlobalUIModel.Buttons.dimensionMacOSLarge
#elseif os(watchOS)
            return GlobalUIModel.Buttons.dimensionWatchOS
#else
            fatalError() // Not supported
#endif
        }()
        
        var cornerRadius: CGFloat { height / 2 }
        
        /// Border width. Set to `0`.
        ///
        /// To hide border, set to `0`.
        public var borderWidth: CGFloat = 0
        
        /// Label margins. Set to `15` horizontal and `3` vertical.
        public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMargins
        
        /// Title minimum scale factor. Set to `0.75`.
        public var titleMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor
        
        /// Icon size. Set to `16x16`.
        public var iconSize: CGSize = .init(dimension: GlobalUIModel.Buttons.iconDimensionSmall)
        
        /// Spacing between icon and title. Set to `8`.
        ///
        /// Applicable only if icon `init` with icon and title is used.
        public var iconTitleSpacing: CGFloat = GlobalUIModel.Buttons.iconTitleSpacing
        
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
        /// Set to `system` `semibold` `16` on `iOS`.
        /// Set to `system` `medium` `14` on `macOS`.
        /// Set to `system` `medium` `17` on `watchOS`.
        public var title: Font = {
#if os(iOS)
            return .system(size: 16, weight: .semibold)
#elseif os(macOS)
            return .system(size: 14, weight: .medium)
#elseif os(watchOS)
            return .system(size: 17, weight: .medium)
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
        
        /// Ratio to which label scales down on press.
        /// Set to `1` on `iOS`.
        /// Set to `1` on `macOS`.
        /// Set to `0.98` on `watchOS`.
        public var backgroundPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale
        
        /// Ratio to which label scales down on press.
        /// Set to `1` on `iOS`.
        /// Set to `1` on `macOS`.
        /// Set to `0.98` on `watchOS`.
        public var labelPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale
        
#if os(iOS)
        /// Haptic feedback style. Set to `light`.
        public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = GlobalUIModel.Buttons.haptic_iOS
#elseif os(watchOS)
        /// Haptic feedback type. Set to `nil`.
        public var haptic: WKHapticType? = GlobalUIModel.Buttons.haptic_watchOS
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
