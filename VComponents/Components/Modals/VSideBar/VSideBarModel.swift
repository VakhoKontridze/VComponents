//
//  VSideBarModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Side Bar Model
/// Model that describes UI
public struct VSideBarModel {
    // MARK: Properties
    /// Reference to `VSheetModel`
    public static let sheetReference: VSheetModel = .init()
    
    /// Reference to `VModalModel`
    public static let modalReference: VModalModel = .init()
    
    /// Reference to `VHalfModalModel`
    public static let halfModalReference: VHalfModalModel = .init()
    
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes model with default values
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties
    public struct Layout {
        // MARK: Properties
        /// Side bar width. Defaults to `0.67` ratio of screen with.
        public var width: CGFloat = UIScreen.main.bounds.width * 0.67
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        
        var roundCorners: Bool { cornerRadius > 0 }
        
        /// Content margins. Defaults to `10` leading, `10` trailing, `10` top, and `10` bottom.
        public var contentMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin,
            bottom: sheetReference.layout.contentMargin
        )
        
        /// Indicates if side bar has margins for safe area on top edge. Defaults to `true`.
        public var hasSafeAreaMarginTop: Bool = true
        
        /// Indicates if side bar has margins for safe area on bottom edge. Defaults to `true`.
        public var hasSafeAreaMarginBottom: Bool = true
        
        var edgesToIgnore: Edge.Set {
            switch (hasSafeAreaMarginTop, hasSafeAreaMarginBottom) {
            case (false, false): return [.top, .bottom]
            case (false, true): return .top
            case (true, false): return .bottom
            case (true, true): return []
            }
        }
        
        /// Distance to drag side bar left to initiate dismiss. Default to `100`.
        public var translationToDismiss: CGFloat = 100
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins
        public typealias Margins = LayoutGroup_LTTB
    }

    // MARK: Colors
    /// Sub-model containing color properties
    public struct Colors {
        // MARK: Properties
        /// Background color
        public var background: Color = modalReference.colors.background
        
        /// Blinding color
        public var blinding: Color = modalReference.colors.blinding
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Defaults to `linear` with duration `0.2`.
        public var appear: BasicAnimation? = halfModalReference.animations.appear
        
        /// Disappear animation. Defaults to `linear` with duration `0.2`.
        public var disappear: BasicAnimation? = halfModalReference.animations.disappear
        
        // MARK: Initializers
        /// Initializes sub-model with default values
        public init() {}
    }
    
    // MARK: Sub-Models
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topRight, .bottomRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
}
