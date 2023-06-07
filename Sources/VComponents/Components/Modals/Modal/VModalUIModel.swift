//
//  VModalUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VModalUIModel {
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
        /// Modal sizes.
        /// Set to `0.9x0.6` screen ratios in portrait.
        /// Set to reverse in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(CGSize(width: 0.9, height: 0.6)),
            landscape: .fraction(CGSize(width: 0.6, height: 0.9))
        )
        
        /// Rounded corners. Set to to `allCorners`.
        public var roundedCorners: RectCorner = .allCorners
        
        /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
        public var reversesLeftAndRightCornersForRTLLanguages: Bool = true
        
        /// Corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Header alignment. Set to `center`.
        public var headerAlignment: VerticalAlignment = .center
        
        /// Header margins. Set to `15` horizontal and `10` vertical.
        public var headerMargins: Margins = GlobalUIModel.Common.containerHeaderMargins
        
        /// Spacing between label and close button. Set to `10`.
        public var labelAndCloseButtonSpacing: CGFloat = GlobalUIModel.Modals.labelCloseButtonSpacing
        
        /// Divider height. Set to `2` scaled to screen.
        ///
        /// To hide divider, set to `0`, and remove header.
        public var dividerHeight: CGFloat = GlobalUIModel.Common.dividerHeight
        
        /// Divider margins. Set to `zero`.
        public var dividerMargins: Margins = .zero
        
        /// Content margins. Set to `zero`.
        public var contentMargins: Margins = .zero

        /// Container edges ignored by modal container. Set to `all`.
        ///
        /// Setting this property to `all` may cause container to ignore explicit `sizes`.
        public var ignoredContainerSafeAreaEdgesByContainer: Edge.Set = .all

        /// Keyboard edges ignored by modal container. Set to `all`.
        ///
        /// Setting this property to `all` may cause container to ignore explicit `sizes`.
        public var ignoredKeyboardSafeAreaEdgesByContainer: Edge.Set = .all

        /// Container edges ignored by modal content. Set to `[]`.
        public var ignoredContainerSafeAreaEdgesByContent: Edge.Set = []

        /// Keyboard edges ignored by modal content. Set to `[]`.
        public var ignoredKeyboardSafeAreaEdgesByContent: Edge.Set = []
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that represents modal sizes.
        public typealias Sizes = ModalSizes<CGSize>
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        /// Color scheme. Set to `nil`.
        ///
        /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
        public var colorScheme: ColorScheme? = nil
        
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Set to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Set to `zero`.
        public var shadowOffset: CGPoint = .zero
        
        /// Header title text color.
        public var headerTitleText: Color = ColorBook.primary
        
        /// Divider color.
        public var divider: Color = GlobalUIModel.Common.dividerColor
        
        /// Dimming view color.
        public var dimmingView: Color = GlobalUIModel.Common.dimmingViewColor
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header title text font. Set to `bold` `headline` (`17`).
        public var headerTitleText: Font = GlobalUIModel.Modals.headerTitleTextFont
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Set to `linear` with duration `0.05`.
        public var appear: BasicAnimation? = GlobalUIModel.Modals.poppingAppearAnimation
        
        /// Disappear animation. Set to `easeIn` with duration `0.05`.
        public var disappear: BasicAnimation? = GlobalUIModel.Modals.poppingDisappearAnimation
        
        /// Scale effect during appear and disappear. Set to `1.01`.
        public var scaleEffect: CGFloat = GlobalUIModel.Modals.poppingAnimationScaleEffect
        
        /// Blur during appear and disappear. Set to `3`.
        public var blur: CGFloat = GlobalUIModel.Modals.poppingAnimationBlur

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Set to `default`.
        public var dismissType: DismissType = .default
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as `leadingButton`, `trailingButton`, or `backTap`.
        public struct DismissType: OptionSet {
            // MARK: Options
            /// Leading.
            public static let leadingButton: Self = .init(rawValue: 1 << 0)
            
            /// Trailing.
            public static let trailingButton: Self = .init(rawValue: 1 << 1)
            
            /// Back-tap.
            public static let backTap: Self = .init(rawValue: 1 << 2)
            
            // MARK: Options Initializers
            /// All.
            public static var all: Self { [.leadingButton, .trailingButton, .backTap] }
            
            /// Default value. Set to `trailingButton`.
            public static var `default`: Self { .trailingButton }
            
            /// Indicates if dismiss type includes a button.
            public var hasButton: Bool {
                [.leadingButton, .trailingButton].contains(where: { contains($0) })
            }
            
            // MARK: Properties
            public let rawValue: Int
            
            // MARK: Initializers
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }
        }
    }
    
    // MARK: Sub UI Models
    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()
        
        uiModel.roundedCorners = layout.roundedCorners
        uiModel.reversesLeftAndRightCornersForRTLLanguages = layout.reversesLeftAndRightCornersForRTLLanguages
        uiModel.cornerRadius = layout.cornerRadius
        
        uiModel.backgroundColor = colors.background

        uiModel.contentMargins = .zero
        
        return uiModel
    }
    
    /// Model for customizing close button.
    /// `size` is set to `30x30`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `12x12`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var closeButtonSubUIModel: VRoundedButtonUIModel = {
        var uiModel: VRoundedButtonUIModel = .init()

        uiModel.size = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayDimension)

        uiModel.backgroundColors = VRoundedButtonUIModel.StateColors(
            enabled: GlobalUIModel.Common.circularButtonLayerColorEnabled,
            pressed: GlobalUIModel.Common.circularButtonLayerColorPressed,
            disabled: .clear // Doesn't matter
        )

        uiModel.iconSize = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
        uiModel.iconColors = VRoundedButtonUIModel.StateColors(GlobalUIModel.Common.circularButtonIconGrayColor)

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()
}

// MARK: - Factory
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VModalUIModel {
    /// `VModalUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = Layout.Margins(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
    
    /// `VModalUIModel` that stretches content to full size.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var fullSizedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.misc.dismissType.remove(.leadingButton)
        uiModel.misc.dismissType.remove(.trailingButton)
        
        return uiModel
    }
}
