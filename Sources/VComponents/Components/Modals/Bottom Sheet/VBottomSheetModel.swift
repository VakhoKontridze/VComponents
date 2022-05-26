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
    fileprivate static let sheetReference: VSheetModel = .init()
    fileprivate static let modalReference: VModalModel = .init()
    fileprivate static let closeButtonReference: VCloseButtonModel = .init()
    
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
        /// Bottom sheet sizes.
        /// Set to `1` ratio of screen width, and `0.6`, `0.6`, and `0.9` ratios of screen height in portrait.
        /// Set to `0.7` ratio of screen width and `0.9` ratio of screen height in landscape.
        public var sizes: Sizes = .init(
            portrait: .relative(.init(
                width: 1,
                heights: .init(min: 0.6, ideal: 0.6, max: 0.9)
            )),
            landscape: .relative(.init(
                width: 0.7,
                heights: .fixed(0.9)
            ))
        )
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = modalReference.layout.cornerRadius
        
        /// Grabber indicaator size. Defaults to `50` width and `4` height.
        public var grabberSize: CGSize = .init(width: 50, height: 4)
        
        /// Grabber corner radius. Defaults to `2`.
        public var grabberCornerRadius: CGFloat = 2
        
        /// Grabber margins. Defaults to `10` top  and `0` bottom.
        public var grabberMargins: VerticalMargins = .init(
            top: 10,
            bottom: 0
        )
        
        /// Header alignment. Defaults to `center`.
        public var headerAlignment: VerticalAlignment = modalReference.layout.headerAlignment
        
        /// Header margins. Defaults to `15` horizontal, `10` vertical.
        public var headerMargins: Margins = modalReference.layout.headerMargins
        
        /// Close button dimension. Defaults to `30`.
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        
        /// Close button icon dimension. Defaults to `12`.
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        /// Spacing between label and close button. Defaults to `10`.
        public var labelCloseButtonSpacing: CGFloat = modalReference.layout.labelCloseButtonSpacing
        
        /// Divider height. Defaults to `2/3`.
        public var dividerHeight: CGFloat = modalReference.layout.dividerHeight
    
        /// Divider margins. Defaults to `.zero`.
        public var dividerMargins: Margins = modalReference.layout.dividerMargins
        
        /// Content margins. Defaults to `15`'s.
        public var contentMargins: Margins = modalReference.layout.contentMargins
        
        /// Indicates if sheet resizes content based on its visible frame. Defaults to `false`.
        ///
        /// Can be used for scrollable content.
        /// Optionally, add `bottom` to `contentSafeAreaEdges` to ensure that scrollable content always has bottom safe area inset.
        public var autoresizesContent: Bool = false
        
        /// Edges on which content has safe area edges. Defaults to `[]`.
        ///
        /// `autoresizesContent` must be set to `true` for scrollable content to always have bottom safe area inset.
        public var contentSafeAreaEdges: Edge.Set = []
        
        /// Edges ignored by keyboard. Defaults to `[]`.
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        /// Velocity at which sheet snaps to next height, regardless of sufficient distance traveled. Defaults to `600` points/s.
        public var velocityToSnapToNextHeight: CGFloat = 600
        
        /// Ratio of distance to drag sheet downwards to initiate dismiss relative to min height. Defaults to `0.1`.
        public var pullDownDismissDistanceMinHeightRatio: CGFloat = 0.1
        
        var pullDownDismissDistance: CGFloat { pullDownDismissDistanceMinHeightRatio * sizes._current.size.heights.min }
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that describes modal sizes.
        public typealias Sizes = ModalSizes<BottomSheetSize>
        
        // MARK: Bottom Sheet Size
        /// Bottom sheet size.
        public struct BottomSheetSize {
            // MARK: Properties
            /// Width.
            public var width: CGFloat
            
            /// Heights.
            public var heights: BottomSheetHeights
            
            // MARK: Initializers
            /// Initializes `BottomSheetSize`.
            public init(
                width: CGFloat,
                heights: BottomSheetHeights
            ) {
                self.width = width
                self.heights = heights
            }
        }
        
        // MARK: Bottom Sheet Heights
        /// Bottom Sheet Heights
        public struct BottomSheetHeights {
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
            
            var minOffset: CGFloat {
                switch isResizable {
                case false: return (UIScreen.main.bounds.height - min) / 2
                case true: return UIScreen.main.bounds.height - min
                }
            }
            
            var idealOffset: CGFloat {
                switch isResizable {
                case false: return (UIScreen.main.bounds.height - ideal) / 2
                case true: return UIScreen.main.bounds.height - ideal
                }
            }
            
            var maxOffset: CGFloat {
                switch isResizable {
                case false: return (UIScreen.main.bounds.height - max) / 2
                case true: return UIScreen.main.bounds.height - max
                }
            }
            
            var hiddenOffset: CGFloat {
                switch isResizable {
                case false: return UIScreen.main.bounds.height - maxOffset
                case true: return UIScreen.main.bounds.height
                }
            }
            
            // MARK: Initializers
            /// Initializes `Height`.
            public init(min: CGFloat, ideal: CGFloat, max: CGFloat) {
                assert(min <= ideal, "`VBottomSheet`'s `min` height must be less than or equal to `ideal` height")
                assert(ideal <= max, "`VBottomSheet`'s `ideal` height must be less than or equal to `max` height")
                
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
        }
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LTTB
        
        // MARK: Vertical Margins
        /// Sub-model containing `top` and `bottom` margins.
        public typealias VerticalMargins = EdgeInsets_TB
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
        
        /// Dimming view color.
        public var dimmingView: Color = modalReference.colors.dimmingView
        
        /// Grabber color.
        public var grabber: Color = .init(componentAsset: "BottomSheet.Grabber")
        
        /// Header title color.
        ///
        /// Only applicable when using `init`with title.
        public var headerTitle: Color = modalReference.colors.headerTitle
        
        /// Close button background colors.
        public var closeButtonBackground: StateColors = modalReference.colors.closeButtonBackground
        
        /// Close button icon colors.
        public var closeButtonIcon: StateColors = modalReference.colors.closeButtonIcon
        
        /// Divider color.
        public var divider: Color = modalReference.colors.divider
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_EPD<Color>
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
        /// Appear animation. Defaults to `easeInOut` with duration `0.3`.
        public var appear: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        
        /// Disappear animation. Defaults to `easeInOut` with duration `0.3`.
        public var disappear: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        
        /// Pull-down dismiss animation. Defaults to `easeInOut` with duration `0.1`.
        public var pullDownDismiss: BasicAnimation? = .init(curve: .easeInOut, duration: 0.1)
        
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
