//
//  VBottomSheetUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VBottomSheetUIModel {
    // MARK: Properties
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
        /// Bottom sheet sizes.
        /// Set to `1` ratio of screen width, and `0.6`, `0.6`, and `0.9` ratios of screen height in portrait.
        /// Set to `0.7` ratio of screen width and `0.9` ratio of screen height in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(BottomSheetSize(
                width: 1,
                heights: BottomSheetHeights(min: 0.6, ideal: 0.6, max: 0.9)
            )),
            landscape: .fraction(BottomSheetSize(
                width: 0.7,
                heights: BottomSheetHeights(0.9)
            ))
        )
        
        /// Corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Grabber indicator size. Set to `50x4`.
        ///
        /// To hide grabber, set to `zero`.
        public var grabberSize: CGSize = .init(width: 50, height: 4)
        
        /// Grabber corner radius. Set to `2`.
        public var grabberCornerRadius: CGFloat = 2
        
        /// Grabber margins. Set to `10` top  and `0` bottom.
        public var grabberMargins: VerticalMargins = .init(
            top: 10,
            bottom: 0
        )
        
        /// Header alignment. Set to `center`.
        public var headerAlignment: VerticalAlignment = .center
        
        /// Header margins. Set to `15` horizontal and `10` vertical.
        public var headerMargins: Margins = GlobalUIModel.Common.containerHeaderMargins
        
        /// Model for customizing close button layout. `size` is set to `30x30`, `iconSize` is set to `12x12`, and `hitBox` is set to `zero`.
        public var closeButtonSubUIModel: VRoundedButtonUIModel.Layout = {
            var uiModel: VRoundedButtonUIModel.Layout = .init()
            
            uiModel.size = .init(dimension: GlobalUIModel.Common.circularButtonGrayDimension)
            uiModel.iconSize = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
            uiModel.hitBox = .zero
            
            return uiModel
        }()
        
        /// Spacing between label and close button. Set to `10`.
        public var labelAndCloseButtonSpacing: CGFloat = GlobalUIModel.Modals.labelCloseButtonSpacing
        
        /// Divider height. Set to `2` scaled to screen.
        ///
        /// To hide divider, set to `0`, and remove header.
        public var dividerHeight: CGFloat = GlobalUIModel.Common.dividerHeight
        
        /// Divider margins. Set to `zero`.
        public var dividerMargins: Margins = .zero
        
        /// Content margins. Set to `zero`.
        public var contentMargins: Margins = .zero
        
        /// Indicates if sheet resizes content based on its visible frame. Set to `false`.
        ///
        /// Can be used for scrollable content.
        /// Optionally, add `bottom` to `contentSafeAreaEdges` to ensure that scrollable content always has bottom safe area inset.
        ///
        /// Has no effect on fixed bottom sheet.
        public var autoresizesContent: Bool = false
        
        /// Edges on which header has safe area edges. Set to `[]`.
        ///
        /// Can be used for full-sized modal, to prevent header from leaving safe area.
        public var headerSafeAreaEdges: Edge.Set = []
        
        /// Edges on which content has safe area edges. Set to `[]`.
        ///
        /// `autoresizesContent` must be set to `true` for scrollable content to always have bottom safe area inset.
        public var contentSafeAreaEdges: Edge.Set = []
        
        /// Keyboard edges ignored by modal. Set to `[]`.
        public var ignoredKeyboardSafeAreaEdges: Edge.Set = []
        
        /// Velocity at which sheet snaps to next height, regardless of sufficient distance traveled. Set to `600` points/s.
        public var velocityToSnapToNextHeight: CGFloat = 600
        
        /// Ratio of distance to drag sheet downwards to initiate dismiss relative to min height. Set to `0.1`.
        public var pullDownDismissDistanceMinHeightRatio: CGFloat = 0.1
        
        var pullDownDismissDistance: CGFloat { pullDownDismissDistanceMinHeightRatio * sizes._current.size.heights.min }
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that represents modal sizes.
        public typealias Sizes = ModalSizes<BottomSheetSize>
        
        // MARK: Bottom Sheet Size
        /// Bottom sheet size.
        public struct BottomSheetSize: Equatable, ScreenRelativeSizeMeasurement {
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
            
            // MARK: Screen Relative Size Measurement
            public static func relativeMeasurementToPoints(_ measurement: Self) -> Self {
                .init(
                    width: MultiplatformConstants.screenSize.width * measurement.width,
                    heights: BottomSheetHeights(
                        min: MultiplatformConstants.screenSize.height * measurement.heights.min,
                        ideal: MultiplatformConstants.screenSize.height * measurement.heights.ideal,
                        max: MultiplatformConstants.screenSize.height * measurement.heights.max
                    )
                )
            }
        }
        
        // MARK: Bottom Sheet Heights
        /// Bottom sheet heights.
        public struct BottomSheetHeights: Equatable {
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
            
            /// Indicates if model suggests fully fixed height.
            public var isFixed: Bool {
                min == ideal &&
                ideal == max
            }
            
            var minOffset: CGFloat { MultiplatformConstants.screenSize.height - min }
            
            var idealOffset: CGFloat { MultiplatformConstants.screenSize.height - ideal }
            
            var maxOffset: CGFloat { MultiplatformConstants.screenSize.height - max }
            
            var hiddenOffset: CGFloat { MultiplatformConstants.screenSize.height }
            
            // MARK: Initializers
            /// Initializes `Height` with values.
            public init(
                min: CGFloat,
                ideal: CGFloat,
                max: CGFloat
            ) {
                self.min = min
                self.ideal = ideal
                self.max = max
            }
            
            /// Initializes `Height` with value.
            public init(
                _ value: CGFloat
            ) {
                self.min = value
                self.ideal = value
                self.max = value
            }
        }
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
        
        // MARK: Vertical Margins
        /// Model that contains `top` and `bottom` margins.
        public typealias VerticalMargins = EdgeInsets_TopBottom
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Color scheme. Set to `nil`.
        ///
        /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
        public var colorScheme: ColorScheme? = nil
        
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Shadow color.
        public var shadow: Color = .clear
        
        /// Shadow radius. Set to `0`.
        public var shadowRadius: CGFloat = 0
        
        /// Shadow offset. Set to `zero`.
        public var shadowOffset: CGPoint = .zero
        
        /// Grabber color.
        public var grabber: Color = GlobalUIModel.Common.grabberColor
        
        /// Header title text color.
        public var headerTitleText: Color = ColorBook.primary
        
        /// Model for customizing close button colors.
        public var closeButtonSubUIModel: VRoundedButtonUIModel.Colors = {
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            
            uiModel.background = VRoundedButtonUIModel.Colors.StateColors(
                enabled: GlobalUIModel.Common.circularButtonLayerColorEnabled,
                pressed: GlobalUIModel.Common.circularButtonLayerColorPressed,
                disabled: .clear // Doesn't matter
            )
            uiModel.icon = VRoundedButtonUIModel.Colors.StateColors(GlobalUIModel.Common.circularButtonIconGrayColor)
            
            return uiModel
        }()
        
        /// Divider color.
        public var divider: Color = GlobalUIModel.Common.dividerColor
        
        /// Dimming view color.
        public var dimmingView: Color = GlobalUIModel.Common.dimmingViewColor
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>
    }
    
    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header title text font. Set to `bold` `headline` (`17`).
        public var headerTitleText: Font = GlobalUIModel.Modals.headerTitleTextFont
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Set to `easeInOut` with duration `0.3`.
        public var appear: BasicAnimation? = GlobalUIModel.Modals.slidingAppearAnimation
        
        /// Disappear animation. Set to `easeInOut` with duration `0.3`.
        public var disappear: BasicAnimation? = GlobalUIModel.Modals.slidingDisappearAnimation
        
        /// Pull-down dismiss animation. Set to `easeInOut` with duration `0.1`.
        public var pullDownDismiss: BasicAnimation? = .init(curve: .easeInOut, duration: 0.1)
        
        /// Height snapping animation between `min`, `ideal`, and `max` states. Set to `interpolatingSpring`, with mass `1`, stiffness `300`, damping `30`, and initialVelocity `1`.
        public var heightSnap: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)
        
        /// Model for customizing close button animations. `haptic` is se to `nil`.
        public var closeButtonSubUIModel: VRoundedButtonUIModel.Animations = {
            var uiModel: VRoundedButtonUIModel.Animations = .init()
            
#if os(iOS)
            uiModel.haptic = nil
#endif
            
            return uiModel
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Method of dismissing modal. Set to `default`.
        public var dismissType: DismissType = .default
        
        /// Indicates if bottom sheet can be resized by dragging outside the header. Set to `false`.
        ///
        /// Setting to `true` may cause issues with scrollable views.
        ///
        /// Has no effect on fixed bottom sheet.
        public var contentIsDraggable: Bool = false
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Dismiss Type
        /// Dismiss type, such as `leadingButton`, `trailingButton`, `backTap`, or `pullDown`.
        public struct DismissType: OptionSet {
            // MARK: Options
            /// Leading.
            public static let leadingButton: Self = .init(rawValue: 1 << 0)
            
            /// Trailing.
            public static let trailingButton: Self = .init(rawValue: 1 << 1)
            
            /// Back-tap.
            public static let backTap: Self = .init(rawValue: 1 << 2)
            
            /// Pull down.
            public static let pullDown: Self = .init(rawValue: 1 << 3)
            
            // MARK: Options Initializers
            /// Default value. Set to `trailingButton` and `.pullDown`.
            public static var `default`: Self { [.trailingButton, .pullDown] }
            
            /// All.
            public static var all: Self { [.leadingButton, .trailingButton, .backTap, .pullDown] }
            
            // MARK: Properties
            public let rawValue: Int
            
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
    
    // MARK: Sub UI Models
    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()
        
        uiModel.layout.roundedCorners = .topCorners
        uiModel.layout.cornerRadius = layout.cornerRadius
        uiModel.layout.contentMargins = .zero
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var closeButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout = layout.closeButtonSubUIModel
        
        uiModel.colors = colors.closeButtonSubUIModel
        
        uiModel.animations = animations.closeButtonSubUIModel
        
        return uiModel
    }
}

// MARK: - Factory
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel {
    /// `VBottomSheetUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = Layout.Margins(GlobalUIModel.Common.containerContentMargin)
        
        return uiModel
    }
    
    /// `VBottomSheetUIModel` that autoresizes content and inserts bottom safe area for scrollable content.
    public static var scrollableContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.autoresizesContent = true
        uiModel.layout.contentSafeAreaEdges.insert(.bottom)
        
        return uiModel
    }
    
    /// `VBottomSheetUIModel` that hides only leaves grabber.
    ///
    /// Grabber is still visible. To hide grabber, use `fullSizedContent`.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var onlyGrabber: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.grabberMargins = Layout.VerticalMargins(15)
        
        uiModel.misc.dismissType.remove(.leadingButton)
        uiModel.misc.dismissType.remove(.trailingButton)
        
        return uiModel
    }
    
    /// `VBottomSheetUIModel` that only leaves grabber, autoresizes content, and inserts bottom safe area for scrollable content.
    ///
    /// Grabber is still visible. To hide grabber, use `fullSizedContent`.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var scrollableContentOnlyGrabber: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.grabberMargins = Layout.VerticalMargins(15)
        uiModel.layout.autoresizesContent = true
        uiModel.layout.contentSafeAreaEdges.insert(.bottom)
        
        uiModel.misc.dismissType.remove(.leadingButton)
        uiModel.misc.dismissType.remove(.trailingButton)
        
        return uiModel
    }
    
    /// `VBottomSheetUIModel` that stretches content to full size.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var fullSizedContent: Self {
        var uiModel: Self = .onlyGrabber
        
        uiModel.layout.grabberSize.height = .zero
        
        return uiModel
    }
}
