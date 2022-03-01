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
        
        /// Grabber indicaator size. Defaults to `50` width and `4` height.
        public var grabberSize: CGSize = .init(width: 50, height: 4)
        
        var hasGrabber: Bool { grabberSize.height > 0 }
        
        /// Grabber corner radius. Defaults to `2`.
        public var grabberCornerRadius: CGFloat = 2
        
        /// Header divider height. Defaults to `1`.
        public var headerDividerHeight: CGFloat = 1
        
        var hasDivider: Bool { headerDividerHeight > 0 }
        
        /// Close button dimension. Default to `32`.
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        
        /// Close button icon dimension. Default to `11`.
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        /// Grabber margins. Default to `10` top  and `5` bottom.
        public var grabberMargins: VerticalMargins = .init(
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
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
        
        // MARK: Vertical Margins
        /// Sub-model containing `top` and `bottom` margins.
        public typealias VerticalMargins = EdgeInsets_TB
        
        // MARK: Height Type
        /// Enum that describes height type, such as `fixed` or `dynamic`.
        public enum HeightType {
            // MARK: Cases
            /// Fixed height.
            case fixed(_ value: CGFloat)
            
            /// Dynamic height that changes between `min`, `ideal`, and `max`.
            case dynamic(min: CGFloat, ideal: CGFloat, max: CGFloat)
            
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
            
            // MARK: Initailizers
            /// Default value. Set to `0.3` ration of screen height as min, `0.75`as ideal, and `0.9` as max.
            public static var `default`: Self {
                .dynamic(
                    min: UIScreen.main.bounds.height * 0.3,
                    ideal: UIScreen.main.bounds.height * 0.75,
                    max: UIScreen.main.bounds.height * 0.9
                )
            }
        }
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = modalReference.colors.background
        
        /// Grabber color.
        public var grabber: Color = .init(componentAsset: "HalfModal.Grabber")
        
        /// Text header color.
        ///
        /// Only applicable when using init with title.
        public var headerText: Color = modalReference.colors.headerText
        
        /// Close button background colors.
        public var closeButtonBackground: StateColors = modalReference.colors.closeButtonBackground
        
        /// Close button icon colors and opacities.
        public var closeButtonIcon: StateColors = modalReference.colors.closeButtonIcon
        
        /// Header divider color.
        public var headerDivider: Color = .init(componentAsset: "HalfModal.Grabber")
        
        /// Blinding color.
        public var blinding: Color = modalReference.colors.blinding
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPD<Color>
        
        /// Sub-model containing colors for component states.
        public typealias StateColors_OLD = StateColors_EPD
        
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
        model.colors.icon = colors.closeButtonIcon
        
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
