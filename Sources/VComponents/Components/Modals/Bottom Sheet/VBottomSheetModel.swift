//
//  VBottomSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet Model
/// Model that describes UI.
public struct VBottomSheetModel {
    // MARK: Properties
    /// Reference to `VSheetModel`.
    public static let sheetReference: VSheetModel = .init()
    
    /// Reference to `VModalModel`.
    public static let modalReference: VModalModel = .init()
    
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
        /// Height. Defaults to `default`.
        public var height: Height = .default
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        
        /// Grabber indicaator size. Defaults to `50` width and `4` height.
        public var grabberSize: CGSize = .init(width: 50, height: 4)
        
        /// Grabber corner radius. Defaults to `2`.
        public var grabberCornerRadius: CGFloat = 2
        
        /// Grabber margins. Default to `10` top  and `0` bottom.
        public var grabberMargins: VerticalMargins = .init(
            top: 10,
            bottom: 0
        )
        
        /// Header margins. Default to `15` leading, `15` trailing, `10` top, and `10` bottom.
        public var headerMargins: Margins = modalReference.layout.headerMargins
        
        /// Close button dimension. Default to `32`.
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        
        /// Close button icon dimension. Default to `11`.
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        /// Spacing between label and close button. Defaults to `10`.
        public var labelCloseButtonSpacing: CGFloat = modalReference.layout.labelCloseButtonSpacing
        
        /// Header divider height. Defaults to `1`.
        public var headerDividerHeight: CGFloat = modalReference.layout.headerDividerHeight
    
        /// Header divider margins. Default to `.zero`.
        public var headerDividerMargins: Margins = modalReference.layout.headerDividerMargins
        
        /// Content margins. Default to `15` leading, `15` trailing, `15` top, and `15` bottom.
        public var contentMargins: Margins = modalReference.layout.contentMargins
        
        /// Indicates if sheet resizes content based on its visible frame. Defaults to `false`.
        ///
        /// Can be used for scrollable content.
        public var autoresizesContent: Bool = false
        
        /// Indicates if sheet has margins for safe area on bottom edge. Defaults to `false`.
        ///
        /// `autoresizesContent` must be set to `true`.
        public var hasSafeAreaMarginBottom: Bool = true
        
        /// Velocity at which sheet snaps to next height, regardless of sufficient distance traveled. Defaults to `600` points/s.
        public var velocityToSnapToNextHeight: CGFloat = 600
        
        /// Distance to drag sheet downwards to initiate dismiss. Default to `0.1` ratio of min height.
        public var pullDownDismissDistance: CGFloat = Height.default.min * 0.1
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
        
        // MARK: Vertical Margins
        /// Sub-model containing `top` and `bottom` margins.
        public typealias VerticalMargins = EdgeInsets_TB
        
        // MARK: Height
        /// Models that describes heights.
        public struct Height {
            // MARK: Properties
            /// Minimum height.
            public var min: CGFloat
            
            /// Ideal height.
            public var ideal: CGFloat
            
            /// Maximum height.
            public var max: CGFloat
            
            /// Indicates if model allows resizing.
            public var isResizable: Bool {
                min != ideal ||
                ideal != max
            }
            
            /// Indicates if values support a valid layout.
            ///
            /// If not, layout would invalidate itself, and refuse to draw.
            public var isLayoutValid: Bool {
                min <= ideal &&
                ideal <= max
            }
            
            // Offsets start from 0 at the top
            var minOffset: CGFloat { max - min }
            var idealOffset: CGFloat { max - ideal }
            var maxOffset: CGFloat { max - max }
            
            // MARK: Initializers
            /// Initializes `Height`.
            public init(min: CGFloat, ideal: CGFloat, max: CGFloat) {
                self.min = min
                self.ideal = ideal
                self.max = max
            }
            
            /// Initializes `Height` with fixed values.
            public static func fixed(_ value: CGFloat) -> Self {
                .init(
                    min: value,
                    ideal: value,
                    max: value
                )
            }
            
            /// Default value. Set to `0.6` ratio of screen height as min, `0.6`as ideal, and `0.9` as max.
            public static var `default`: Self {
                .init(
                    min: UIScreen.main.bounds.height * 0.6,
                    ideal: UIScreen.main.bounds.height * 0.6,
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
        public var grabber: Color = .init(componentAsset: "BottomSheet.Grabber")
        
        /// Title header color.
        ///
        /// Only applicable when using `init`with title.
        public var headerTitle: Color = modalReference.colors.headerTitle
        
        /// Close button background colors.
        public var closeButtonBackground: StateColors = modalReference.colors.closeButtonBackground
        
        /// Close button icon colors and opacities.
        public var closeButtonIcon: StateColors = modalReference.colors.closeButtonIcon
        
        /// Header divider color.
        public var headerDivider: Color = modalReference.colors.headerDivider
        
        /// Blinding color.
        public var blinding: Color = modalReference.colors.blinding
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPD<Color>
        
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
        /// Only applicable when using `init`with title.
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
        
        /// Pull-down disappear animation. Defaults to `linear` with duration `0.1`.
        public var pullDownDisappear: BasicAnimation? = .init(curve: .easeIn, duration: 0.1)
        
        /// Height snapping animation between `min`, `ideal`, and `max` states. Defaults to `interpolatingSpring`, with mass `1`, stiffness `300`, damping `30`, and initialVelocity `1`.
        public var heightSnap: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Defaults to `default`.
        public var dismissType: DismissType = .default
        
        /// Indicates if sheet can be resized by dragging outside the header. Defaults to `false`.
        ///
        /// Setting to `true` may cause issues with scrollable views.
        public var isContentDraggable: Bool = false
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as `leadingButton`, `trailingButton`, `backTap`, or `pullDown`.
        public struct DismissType: OptionSet {
            // MARK: Properties
            public let rawValue: Int
            
            /// Leading.
            public static var leadingButton: DismissType { .init(rawValue: 1 << 0) }
            
            /// Trailing.
            public static var trailingButton: DismissType { .init(rawValue: 1 << 1) }
            
            /// Backtap.
            public static var backTap: DismissType { .init(rawValue: 1 << 2) }
            
            /// Pull down.
            public static var pullDown: DismissType { .init(rawValue: 1 << 3) }
            
            /// All.
            public static var all: DismissType { [.leadingButton, .trailingButton, .backTap, .pullDown] }
            
            /// Default value. Set to `trailingButton` and `.pullDown`.
            public static var `default`: DismissType { [.trailingButton, .pullDown] }
            
            /// Indicates if dismiss type inclues a button.
            public var hasButton: Bool {
                [.leadingButton, .trailingButton].contains(where: { contains($0) })
            }
            
            // MARK: Initializers
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }
        }
    }
    
    // MARK: Sub-Models
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = [.topLeft, .topRight]
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
