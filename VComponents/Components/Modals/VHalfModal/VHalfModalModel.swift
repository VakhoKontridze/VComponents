//
//  VHalfModalModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK: - V Half Modal Model
/// Model that describes UI.
public struct VHalfModalModel {
    // MARK: Properties
    /// Reference to `VSheetModel`.
    public static let sheetReference: VSheetModel = .init()
    
    /// Reference to `VModalModel`.
    public static let modalReference: VModalModel = .init()
    
    /// Reference to `VAccordionModel`.
    public static let accordionReference: VAccordionModel = .init()
    
    /// Reference to `VCloseButtonModel`.
    public static let closeButtonReference: VCloseButtonModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
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
        /// Height type. Defaults to `default`.
        public var height: HeightType = .default
        
        /// Edges ignored by keyboard. Defaults to `none`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        
        var roundCorners: Bool { cornerRadius > 0 }
        
        /// Resize indicaator size. Defaults to `50` width and `4` height.
        public var resizeIndicatorSize: CGSize = .init(width: 50, height: 4)
        
        var hasResizeIndicator: Bool { resizeIndicatorSize.height > 0 }
        
        /// Resize indicator corner radius. Defaults to `2`.
        public var resizeIndicatorCornerRadius: CGFloat = 2
        
        /// Header divider height. Defaults to `1`.
        public var headerDividerHeight: CGFloat = 1
        
        var hasDivider: Bool { headerDividerHeight > 0 }
        
        /// Close button dimension. Default to `32`.
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        
        /// Close button icon dimension. Default to `11`.
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        /// Resize indicator margins. Default to `10` top  and `5` bottom.
        public var resizeIndicatorMargins: VerticalMargins = .init(
            top: sheetReference.layout.contentMargin,
            bottom: sheetReference.layout.contentMargin/2
        )
        
        /// Header margins. Default to `10` leading, `10` trailing, `5` top, and `5` bottom.
        public var headerMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: sheetReference.layout.contentMargin/2,
            bottom: sheetReference.layout.contentMargin/2
        )
    
        /// Header divider margins. Default to `0` leading, `0` trailing, `5` top, and `5` bottom.
        public var headerDividerMargins: Margins = modalReference.layout.headerDividerMargins
        
        /// Content margins. Default to `10` leading, `10` trailing, `5` top, and `5` bottom.
        public var contentMargins: Margins = modalReference.layout.contentMargins
        
        /// Indicates if modal has margins for safe area on bottom edge. Defaults to `true`.
        public var hasSafeAreaMarginBottom: Bool = true
        
        var edgesToIgnore: Edge.Set {
            switch hasSafeAreaMarginBottom {
            case false: return .bottom
            case true: return []
            }
        }

        /// Header item spacing. Defaults to `10`.
        public var headerSpacing: CGFloat = modalReference.layout.headerSpacing
        
        /// Distance to drag modal downwards to initiate dismiss. Default to `100`.
        public var translationBelowMinHeightToDismiss: CGFloat = 100
        
        /// Navigation bar close button top margin. Defaults to `30`.
        ///
        /// If you decide to remove resize indicator or changing vertical margins, it's essential to change this property.
        public static var navBarCloseButtonMarginTop: CGFloat {
            let instance: Self = .init()
            
            return instance.resizeIndicatorMargins.top +
                instance.resizeIndicatorSize.height +
                instance.resizeIndicatorMargins.bottom +
                //instance.headerDividerMargins.top +
                //instance.headerDividerHeight +
                //instance.headerDividerMargins.bottom +
                instance.contentMargins.top +
                (UIView.navigationBarHeight - VCloseButtonModel.Layout().dimension) / 2
        }
        
        /// Navigation bar close button trailing margin. Defaults to `15`.
        public static var navBarCloseButtonMarginTrailing: CGFloat {
            VBaseViewModel.Layout().navBarMarginHorizontal
        }
        
        /// Navigation bar trailing item margin trailing. Defaults to `42`.
        ///
        /// Since close button is overlayed on modal, it's essential to create spacing between close button and `VBaseView`'s trailing items.
        public static var navBarTrailingItemMarginTrailing: CGFloat {
            VCloseButtonModel.Layout().dimension +
            Self().headerSpacing
        }
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = LayoutGroup_LTTB
        
        // MARK: Vertical Margins
        /// Sub-model containing `top` and `bottom` margins.
        public typealias VerticalMargins  = LayoutGroup_TB
        
        // MARK: Height Type
        /// Enum that describes height type, such as `fixed` or `dynamic`.
        public enum HeightType {
            // MARK: Cases
            /// Fixed height.
            case fixed(_ value: CGFloat)
            
            /// Dynamic height that changes between `min`, `ideal`, and `max`.
            case dynamic(min: CGFloat, ideal: CGFloat, max: CGFloat)
            
            /// Default value. Set to `0.3` ration of screen height as min, `0.75`as ideal, and `0.9` as max.
            public static var `default`: Self {
                .dynamic(
                    min: UIScreen.main.bounds.height * 0.3,
                    ideal: UIScreen.main.bounds.height * 0.75,
                    max: UIScreen.main.bounds.height * 0.9
                )
            }
            
            // MARK: Properties
            var min: CGFloat {
                switch self {
                case .fixed(let value): return value
                case .dynamic(let min, _, _): return min
                }
            }
            
            var ideal: CGFloat {
                switch self {
                case .fixed(let value): return value
                case .dynamic(_, let ideal, _): return ideal
                }
            }
            
            var max: CGFloat {
                switch self {
                case .fixed(let value): return value
                case .dynamic(_, _, let max): return max
                }
            }
            
            var isResizable: Bool {
                switch self {
                case .fixed: return false
                case .dynamic(let min, let ideal, let max): return min != ideal || ideal != max
                }
            }
        }
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = modalReference.colors.background
        
        /// Resize indicator color.
        public var resizeIndicator: Color = .init(componentAsset: "HalfModal.ResizeIndicator")
        
        /// Text header color.
        ///
        /// Only applicable when using init with title.
        public var headerText: Color = modalReference.colors.headerText
        
        /// Close button background colors.
        public var closeButtonBackground: StateColors = modalReference.colors.closeButtonBackground
        
        /// Close button icon colors and opacities.
        public var closeButtonIcon: StateColorsAndOpacities = modalReference.colors.closeButtonIcon
        
        /// Header divider color.
        public var headerDivider: Color = .init(componentAsset: "HalfModal.ResizeIndicator")
        
        /// Blinding color.
        public var blinding: Color = modalReference.colors.blinding
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_EPD
        
        // MARK: State Colors and Opaciites
        /// Sub-model containing colors and opacities for component states.
        public typealias StateColorsAndOpacities = StateColorsAndOpacities_EPD_PD
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header font.
        ///
        /// Only applicable when using init with title.
        public var header: Font = modalReference.fonts.header
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Defaults to `linear` with duration `0.2`.
        public var appear: BasicAnimation? = .init(curve: .linear, duration: 0.2)
        
        /// Disappear animation. Defaults to `linear` with duration `0.2`.
        public var disappear: BasicAnimation? = .init(curve: .linear, duration: 0.2)
        
        /// Height snapping animation between `min`, `ideal`, and `max` states. Defaults to `interpolatingSpring`, with mass `1`, stiffness `300`, damping `30`, and initialVelocity `1`.
        public var heightSnap: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)
        
        /// Dragging disappear animation. Defaults to `linear` with duration `0.1`.
        static var dragDisappear: BasicAnimation { .init(curve: .easeIn, duration: 0.1) }
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Defaults to `default`.
        public var dismissType: Set<DismissType> = .default
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Enum that decribes dismiss type, such as `leadingButton`, `trailingButton`, `backtap`, or `pullDown`.
        public enum DismissType: Int, CaseIterable {
            /// Leading.
            case leadingButton
            
            /// Trailing.
            case trailingButton
            
            /// Back tap.
            case backTap
            
            /// Dragging modal down.
            case pullDown
            
            /// Close button for when modal contains `VNavigationView` as content.
            case navigationViewCloseButton
        }
    }
    
    // MARK: Sub-Models
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = layout.roundCorners ? .custom([.topLeft, .topRight]) : .none
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
    
    var closeButtonSubModel: VCloseButtonModel {
        var model: VCloseButtonModel = .init()
        
        model.layout.dimension = layout.closeButtonDimension
        model.layout.iconDimension = layout.closeButtonIconDimension
        model.layout.hitBox.horizontal = 0
        model.layout.hitBox.vertical = 0
        
        model.colors.background = colors.closeButtonBackground
        model.colors.content = colors.closeButtonIcon
        
        return model
    }
}

// MARK: - Helpers
extension Set where Element == VHalfModalModel.Misc.DismissType {
    /// Default value. Set to `trailingButton` and `pullDown`.
    public static var `default`: Self { [.trailingButton, .pullDown] }
    
    var hasButton: Bool {
        contains(where: { [.leadingButton, .trailingButton].contains($0) })
    }
}
