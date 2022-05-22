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
        /// Bottom sheet sizes. Defaults to `default`.
        public var sizes: Sizes = .default
        
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
        
        /// Close button dimension. Default to `30`.
        public var closeButtonDimension: CGFloat = modalReference.layout.closeButtonDimension
        
        /// Close button icon dimension. Default to `12`.
        public var closeButtonIconDimension: CGFloat = modalReference.layout.closeButtonIconDimension
        
        /// Spacing between label and close button. Defaults to `10`.
        public var labelCloseButtonSpacing: CGFloat = modalReference.layout.labelCloseButtonSpacing
        
        /// Header divider height. Defaults to `2/3`.
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
        
        /// Ratio of distance to drag sheet downwards to initiate dismiss relative to min height. Default to `0.1`.
        public var pullDownDismissDistanceMinHeightRatio: CGFloat = 0.1
        
        var pullDownDismissDistance: CGFloat { pullDownDismissDistanceMinHeightRatio * sizes.current.size.heights.min }
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that describes bottom sheet sizes.
        public struct Sizes {
            // MARK: Properties
            /// Portrait size configuration.
            public let portrait: SizeConfiguration
            
            /// Landscape size configuration.
            public let landscape: SizeConfiguration
            
            /// Current size configuration based on interface orientation.
            public var current: SizeConfiguration {
                switch _IntefaceOrientation() {
                case nil: return portrait
                case .portrait: return portrait
                case .landscape: return landscape
                }
            }
            
            // MARK: Initializers
            /// Initializes `Sizes` with size configurations.
            public init(portrait: SizeConfiguration, landscape: SizeConfiguration) {
                self.portrait = portrait
                self.landscape = landscape
            }
            
            /// Default value. Set to `1` ratio of screen width, and `0.6`, `0.6`, and `0.9` ratios of screen height in portrait, and `0.7` ratio of screen width and `0.9` ratio of screen height in landscape.
            public static var `default`: Sizes {
                .init(
                    portrait: .relative(.init(
                        width: 1,
                        heights: .init(min: 0.6, ideal: 0.6, max: 0.9)
                    )),
                    landscape: .relative(.init(
                        width: 0.7,
                        heights: .fixed(0.95)
                    ))
                )
            }
            
            // MARK: Single Size Configuration
            /// Enum that describes state, either `point` or `relative`.
            public enum SizeConfiguration {
                // MARK: Cases
                /// Size configuration with fixed sizes represented in points.
                case point(BottomSheetSize)
                
                /// Size configuration with ratios relative to screen sizes.
                case relative(BottomSheetSize)
                
                // MARK: Properties
                /// Size configuration represented in points.
                ///
                /// `point` configuration is returned directly,
                /// while `relative` configurations are multiplied by the screen size.
                public var size: BottomSheetSize {
                    switch self {
                    case .point(let size):
                        return size
                    
                    case .relative(let size):
                        return .init(
                            width: UIScreen.main.bounds.size.width * size.width,
                            heights: .init(
                                min: UIScreen.main.bounds.size.height * size.heights.min,
                                ideal: UIScreen.main.bounds.size.height * size.heights.ideal,
                                max: UIScreen.main.bounds.size.height * size.heights.max
                            )
                        )
                    }
                }
            }
            
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
                
                /// Indicates if values support a valid layout.
                ///
                /// If not, layout would invalidate itself, and refuse to draw.
                public var isLayoutValid: Bool {
                    min <= ideal &&
                    ideal <= max
                }
                
                var minOffset: CGFloat { max - min } // Offsets start from 0 at the top
                var idealOffset: CGFloat { max - ideal } // Offsets start from 0 at the top
                var maxOffset: CGFloat { max - max } // Offsets start from 0 at the top
                
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
        
        /// Shadow color.
        public var shadow: Color = modalReference.colors.shadow
        
        /// Shadow radius. Defaults to `0`.
        public var shadowRadius: CGFloat = modalReference.colors.shadowRadius
        
        /// Shadow offset. Defaults to `zero`.
        public var shadowOffset: CGSize = modalReference.colors.shadowOffset
        
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
        /// Appear animation. Defaults to `easeInOut` with duration `0.3`.
        public var appear: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        
        /// Disappear animation. Defaults to `easeInOut` with duration `0.3`.
        public var disappear: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)
        
        /// Pull-down disappear animation. Defaults to `easeInOut` with duration `0.1`.
        public var pullDownDisappear: BasicAnimation? = .init(curve: .easeInOut, duration: 0.1)
        
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
