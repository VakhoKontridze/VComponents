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
@available(iOS 15.0, *)
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
        /// Consider using `left`, `right`, `top`, and `bottom` instances of `VSideBarUIModel`.
        public var presentationEdge: PresentationEdge = .default
        
        /// Side bar sizes. Set to `default`.
        /// Set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
        /// Set to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(.init(width: 0.75, height: 1)),
            landscape: .fraction(.init(width: 0.5, height: 1))
        )
        
        /// Rounded corners. Set to `rightCorners`.
        public var roundedCorners: UIRectCorner = .rightCorners
        
        /// Corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Content margins. Set to `zero`.
        public var contentMargins: Margins = .zero
        
        /// Edges on which content has safe area edges. Set to `all`.
        public var contentSafeAreaEdges: Edge.Set = .all
        
        /// Edges ignored by keyboard. Set to `[]`.
        public var ignoredKeyboardSafeAreaEdges: Edge.Set = []
        
        /// Ratio of distance to drag side bar backward to initiate dismiss relative to width. Set to `0.1`.
        public var dragBackDismissDistanceWidthRatio: CGFloat = 0.1
        
        var dragBackDismissDistance: CGFloat { dragBackDismissDistanceWidthRatio * sizes._current.size.width }
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Presentation Edge
        /// Enum that represents presentation edge, such as `left`, `right`, `top`, or `bottom`.
        public enum PresentationEdge: Int, CaseIterable {
            // MARK: Cases
            /// Presentation form left.
            case left
            
            /// Presentation form right.
            case right
            
            /// Presentation form top.
            case top
            
            /// Presentation form bottom.
            case bottom
            
            // MARK: Initializers
            /// Default value. Set to `left`.
            public static var `default`: Self { .left }
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
        public var shadowOffset: CGSize = .zero
        
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
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.contentMargin = 0
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
}

// MARK: - Factory (Misc)
@available(iOS 15.0, *)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = .init(VSheetUIModel.Layout().contentMargin)
        
        return uiModel
    }
}

// MARK: - Factory (Presentation Edge)
@available(iOS 15.0, *)
extension VSideBarUIModel.Layout.PresentationEdge {
    /// UI model for the presentation edge.
    public var uiModel: VSideBarUIModel {
        switch self {
        case .left: return .left
        case .right: return .right
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

@available(iOS 15.0, *)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that presents side bar from left.
    ///
    /// Default configuration.
    public static var left: Self {
        .init()
    }
    
    /// `VSideBarUIModel` that presents side bar from right.
    ///
    /// `roundedCorners` is set to `leftCorners`.
    ///
    /// Sets `roundedCorners` to `leftCorners`.
    public static var right: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .right
        
        uiModel.layout.roundedCorners = .leftCorners
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from top.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizes` are set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
    /// And to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
    ///
    /// `roundedCorners` is set to `bottomCorners`.
    ///
    /// `contentMargins.bottom` is set to `25`.
    ///
    /// `contentSafeAreaEdges` is set to all but `bottom`.
    public static var top: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .top
        
        uiModel.layout.sizes = .init(
            portrait: .fraction(.init(width: 1, height: 0.5)),
            landscape: .fraction(.init(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .bottomCorners
        
        uiModel.layout.contentMargins.bottom = 25
        uiModel.layout.contentSafeAreaEdges = .all.subtracting(.bottom)
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from bottom.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizes` are set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
    /// And to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
    ///
    /// `roundedCorners` is set to `topCorners`.
    ///
    /// `contentMargins.top` is set to `25`.
    ///
    /// `contentSafeAreaEdges` is set to all but `top`.
    public static var bottom: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.presentationEdge = .bottom
        
        uiModel.layout.sizes = .init(
            portrait: .fraction(.init(width: 1, height: 0.5)),
            landscape: .fraction(.init(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .topCorners
        
        uiModel.layout.contentMargins.top = 25
        uiModel.layout.contentSafeAreaEdges = .all.subtracting(.top)
        
        return uiModel
    }
}
