//
//  VSideBarModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar Model
/// Model that describes UI.
public struct VSideBarModel {
    // MARK: Properties
    fileprivate static let sheetReference: VSheetModel = .init()
    fileprivate static let modalReference: VModalModel = .init()
    fileprivate static let bottomSheetReference: VBottomSheetModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Side bar sizes. Defaults to `default`.
        /// Set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
        /// Set to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
        public var sizes: Sizes = .init(
            portrait: .relative(.init(width: 0.75, height: 1)),
            landscape: .relative(.init(width: 0.5, height: 1))
        )
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        
        /// Content margins. Defaults to `15` leading, `15` trailing, `15` top, and `15` bottom.
        public var contentMargins: Margins = .init(sheetReference.layout.contentMargin)
        
        /// Edges on which content has safe area edges. Defaults to `all`.
        public var contentSafeAreaEdges: Edge.Set = .all
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Ratio of distance to drag side bar backward to initiate dismiss relative to width. Defaults to `0.1`.
        public var dragBackDismissDistanceWidthRatio: CGFloat = 0.1
        
        var dragBackDismissDistance: CGFloat { dragBackDismissDistanceWidthRatio * sizes._current.size.width }
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that describes modal sizes.
        public typealias Sizes = ModalSizes<CGSize>
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = modalReference.colors.background
        
        /// Shadow color.
        public var shadow: Color = modalReference.colors.shadow
        
        /// Shadow radius. Defaults to `0`.
        public var shadowRadius: CGFloat = modalReference.colors.shadowRadius
        
        /// Shadow offset. Defaults to `zero`.
        public var shadowOffset: CGSize = modalReference.colors.shadowOffset
        
        /// Blinding color.
        public var blinding: Color = modalReference.colors.blinding
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation.  Defaults to `easeInOut` with duration `0.3`.
        public var appear: BasicAnimation? = bottomSheetReference.animations.appear
        
        /// Disappear animation.  Defaults to `easeInOut` with duration `0.3`.
        public var disappear: BasicAnimation? = bottomSheetReference.animations.disappear
        
        /// Drag-back dissapear animation. Defaults to `easeInOut` with duration `0.1`.
        public var dragBackDissapear: BasicAnimation? = bottomSheetReference.animations.pullDownDisappear
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }
    
    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing side bar. Defaults to `default`.
        public var dismissType: DismissType = .default
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as  `backTap, or `dragBack`.
        public struct DismissType: OptionSet {
            // MARK: Properties
            public let rawValue: Int
            
            /// Back tap.
            public static var backTap: DismissType { .init(rawValue: 1 << 0) }
            
            /// Drag-back.
            public static var dragBack: DismissType { .init(rawValue: 1 << 1) }
            
            /// All.
            public static var all: DismissType { [.backTap, .dragBack] }
            
            /// Default value. Set to `all.`
            public static var `default`: DismissType { .all }
            
            // MARK: Initializers
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }
        }
    }
    
    // MARK: Sub-Models
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = [.topRight, .bottomRight]
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
}
