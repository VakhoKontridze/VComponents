//
//  VSideBarUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VSideBarUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
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
        /// Edge from which side bar appears, and to which it disappears. Set to `default`.
        ///
        /// Changing this property in model alone doesn't guarantee proper sizes and rounding.
        /// Consider using `leading`, `trailing`, `top`, and `bottom` instances of `VSideBarUIModel`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Side bar sizes. Set to `default`.
        /// Set to `0.75x1` screen ratios in portrait.
        /// Set to`0.5x1` screen ratios in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(CGSize(width: 0.75, height: 1)),
            landscape: .fraction(CGSize(width: 0.5, height: 1))
        )
        
        /// Rounded corners. Set to `rightCorners`.
        public var roundedCorners: RectCorner = .rightCorners
        
        /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
        public var reversesLeftAndRightCornersForRTLLanguages: Bool = true
        
        /// Corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Content margins. Set to `zero`.
        public var contentMargins: Margins = .zero
        
        /// Edges ignored by container. Set to `[]`.
        public var ignoredContainerSafeAreaEdges: Edge.Set = []
        
        /// Edges ignored by keyboard. Set to `[]`.
        public var ignoredKeyboardSafeAreaEdges: Edge.Set = []
        
        /// Ratio of distance to drag side bar backward to initiate dismiss relative to width. Set to `0.1`.
        public var dragBackDismissDistanceWidthRatio: CGFloat = 0.1
        
        var dragBackDismissDistance: CGFloat { dragBackDismissDistanceWidthRatio * sizes._current.size.width }
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Presentation Edge
        /// Enum that represents presentation edge, such as `leading`, `trailing`, `top`, or `bottom`.
        public enum PresentationEdge: Int, CaseIterable {
            // MARK: Cases
            /// Presentation form leading edge.
            case leading
            
            /// Presentation form trailing edge.
            case trailing
            
            /// Presentation form top edge.
            case top
            
            /// Presentation form bottom edge.
            case bottom

            // MARK: Properties
            var alignment: Alignment {
                switch self {
                case .leading: return .leading
                case .trailing: return .trailing
                case .top: return .top
                case .bottom: return .bottom
                }
            }
            
            // MARK: Initializers
            /// Default value. Set to `leading`.
            public static var `default`: Self { .leading }
        }
        
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
        public var background: Color = ColorBook.layer
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Set to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Set to `zero`.
        public var shadowOffset: CGPoint = .zero
        
        /// Dimming view color.
        public var dimmingView: Color = GlobalUIModel.Common.dimmingViewColor
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation.  Set to `easeInOut` with duration `0.3`.
        public var appear: BasicAnimation? = GlobalUIModel.Modals.slidingAppearAnimation
        
        /// Disappear animation.  Set to `easeInOut` with duration `0.3`.
        public var disappear: BasicAnimation? = GlobalUIModel.Modals.slidingDisappearAnimation
        
        /// Drag-back dismiss animation. Set to `easeInOut` with duration `0.2`.
        public var dragBackDismiss: BasicAnimation? = .init(curve: .easeInOut, duration: 0.2)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing side bar. Set to `default`.
        public var dismissType: DismissType = .default
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as  `backTap, or `dragBack`.
        public struct DismissType: OptionSet {
            // MARK: Options
            /// Back tap.
            public static let backTap: Self = .init(rawValue: 1 << 0)
            
            /// Drag-back.
            public static let dragBack: Self = .init(rawValue: 1 << 1)
            
            // MARK: Options Initializers
            /// All.
            public static var all: DismissType { [.backTap, .dragBack] }
            
            /// Default value. Set to `all.`
            public static var `default`: DismissType { .all }
            
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
        uiModel.layout.reversesLeftAndRightCornersForRTLLanguages = layout.reversesLeftAndRightCornersForRTLLanguages
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.contentMargins = .zero
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
}

// MARK: - Factory (Misc)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = .init(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
}

// MARK: - Factory (Presentation Edge)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel.Layout.PresentationEdge {
    /// UI model for the presentation edge.
    public var uiModel: VSideBarUIModel {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that presents side bar from leading edge.
    ///
    /// Default configuration.
    public static var leading: Self {
        .init()
    }
    
    /// `VSideBarUIModel` that presents side bar from trailing edge.
    ///
    /// `roundedCorners` is set to `leftCorners`.
    ///
    /// Sets `roundedCorners` to `leftCorners`.
    public static var trailing: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .trailing
        
        uiModel.layout.roundedCorners = .leftCorners
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from top edge.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizes` are set to `0.75x1` screen ratios in portrait.
    /// And to`0.5x1` screen ratios in landscape.
    ///
    /// `roundedCorners` is set to `bottomCorners`.
    ///
    /// `contentMargins.bottom` is set to `25`.
    /// This is because, corner radius is applied to container, and not content.
    /// If you wish for `contentMargins.bottom` to be `0`, then make sure to apply corner radius to content itself.
    public static var top: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .top
        
        uiModel.layout.sizes = Layout.Sizes(
            portrait: .fraction(CGSize(width: 1, height: 0.5)),
            landscape: .fraction(CGSize(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .bottomCorners
        
        uiModel.layout.contentMargins.bottom = 25
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from bottom edge.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizes` are set to `0.75x1` screen ratios in portrait.
    /// And to`0.5x1` screen ratios in landscape.
    ///
    /// `roundedCorners` is set to `topCorners`.
    ///
    /// `contentMargins.top` is set to `25`.
    /// This is because, corner radius is applied to container, and not content.
    /// If you wish for `contentMargins.top` to be `0`, then make sure to apply corner radius to content itself.
    public static var bottom: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .bottom
        
        uiModel.layout.sizes = Layout.Sizes(
            portrait: .fraction(CGSize(width: 1, height: 0.5)),
            landscape: .fraction(CGSize(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .topCorners
        
        uiModel.layout.contentMargins.top = 25
        
        return uiModel
    }
}
