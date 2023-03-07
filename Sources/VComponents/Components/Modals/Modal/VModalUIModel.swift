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
public struct VModalUIModel {
    // MARK: Properties
    fileprivate static let sheetReference: VSheetUIModel = .init()
    fileprivate static let disclosureGroupReference: VDisclosureGroupUIModel = .init()
    
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
        /// Set to `0.9` ratio of screen width and `0.6` ratio of screen height in portrait.
        /// Set to reverse in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(.init(width: 0.9, height: 0.6)),
            landscape: .fraction(.init(width: 0.6, height: 0.9))
        )
        
        /// Rounded corners. Defaults to to `allCorners`.
        public var roundedCorners: UIRectCorner = .allCorners
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = sheetReference.layout.cornerRadius
        
        /// Header alignment. Defaults to `center`.
        public var headerAlignment: VerticalAlignment = .center
        
        /// Header margins. Defaults to `15` horizontal, `10` vertical.
        public var headerMargins: Margins = disclosureGroupReference.layout.headerMargins
        
        /// Model for customizing close button layout. `dimension` defaults to `30`, `iconSize` defaults to `12` by `12`, and `hitBox` defaults to `zero`.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var closeButtonSubUIModel: VRoundedButtonUIModel.Layout = disclosureGroupReference.layout.chevronButtonSubUIModel
        
        /// Spacing between label and close button. Defaults to `10`.
        public var labelCloseButtonSpacing: CGFloat = 10
        
        /// Divider height. Defaults to `0.67`.
        ///
        /// To hide divider, set to `0`.
        public var dividerHeight: CGFloat = disclosureGroupReference.layout.dividerHeight
    
        /// Divider margins. Defaults to `.zero`.
        public var dividerMargins: Margins = .zero
        
        /// Content margins. Defaults to `zero`.
        public var contentMargins: Margins = disclosureGroupReference.layout.contentMargins
        
        /// Edges on which header has safe area edges. Defaults to `[]`.
        ///
        /// Can be used for full-sized modal, to prevent header from leaving safe area.
        public var headerSafeAreaEdges: Edge.Set = []
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeyboardSafeAreaEdges: Edge.Set = []
        
        // MARK: Initializers
        /// Initializes model with default values.
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
        // MARK: Properties
        /// Background color.
        public var background: Color = sheetReference.colors.background
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Defaults to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Defaults to `zero`.
        public var shadowOffset: CGSize = .zero
        
        /// Header title color.
        ///
        /// Only applicable when using `init` with title.
        public var headerTitle: Color = ColorBook.primary

        /// Model for customizing close button colors.
        ///
        /// Not all properties will have an effect, and setting them may be futile.
        public var closeButtonSubUIModel: VRoundedButtonUIModel.Colors = { 
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            uiModel.background = disclosureGroupReference.colors.chevronButtonSubUIModel.background
            uiModel.icon = .init(.init(componentAsset: "Modal.CloseButton.Icon.enabled"))
            return uiModel
        }()
        
        /// Divider color.
        public var divider: Color = disclosureGroupReference.colors.divider
        
        /// Dimming view color.
        public var dimmingView: Color = .init(componentAsset: "Modal.DimmingView")
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font.
        ///
        /// Only applicable when using `init` with title.
        public var header: Font = .system(size: 17, weight: .bold)
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Defaults to `linear` with duration `0.05`.
        public var appear: BasicAnimation? = .init(curve: .linear, duration: 0.05)
        
        /// Disappear animation. Defaults to `easeIn` with duration `0.05`.
        public var disappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)
        
        /// Scale effect during appear and disappear. Defaults to `1.01`.
        public var scaleEffect: CGFloat = 1.01
        
        /// Opacity level during appear and disappear. Defaults to `0.5`.
        public var opacity: Double = 0.5
        
        /// Blur during appear and disappear. Defaults to `3`.
        public var blur: CGFloat = 3
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Defaults to `default`.
        public var dismissType: DismissType = .default
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as `leadingButton`, `trailingButton`, or `backTap`.
        public struct DismissType: OptionSet {
            // MARK: Options
            /// Leading.
            public static var leadingButton: DismissType { .init(rawValue: 1 << 0) }
            
            /// Trailing.
            public static var trailingButton: DismissType { .init(rawValue: 1 << 1) }
            
            /// Back-tap.
            public static var backTap: DismissType { .init(rawValue: 1 << 2) }
            
            // MARK: Options Initializers
            /// All.
            public static var all: DismissType { [.leadingButton, .trailingButton, .backTap] }
            
            /// Default value. Set to `trailingButton`.
            public static var `default`: DismissType { .trailingButton }
            
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
    var sheetSubUIModel: VSheetUIModel {
        var uiModel: VSheetUIModel = .init()
        
        uiModel.layout.roundedCorners = layout.roundedCorners
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.contentMargin = 0
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var closeButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout = layout.closeButtonSubUIModel
        
        uiModel.colors = colors.closeButtonSubUIModel
        
        return uiModel
    }
}

// MARK: - Factory
extension VModalUIModel {
    /// `VModalUIModel` that insets content.
    public static var insettedContent: VModalUIModel {
        var uiModel: VModalUIModel = .init()
        
        uiModel.layout.contentMargins = .init(VSheetUIModel.Layout().contentMargin)
        
        return uiModel
    }
    
    /// `VModalUIModel` that stretches content to full size.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var fullSizedContent: VModalUIModel {
        var uiModel: VModalUIModel = .init()
        
        uiModel.misc.dismissType.remove(.leadingButton)
        uiModel.misc.dismissType.remove(.trailingButton)
        
        return uiModel
    }
}
