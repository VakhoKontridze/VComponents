//
//  VAlertUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VAlertUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Alert sizes.
        /// Set to `0.75` ratio of screen width in portrait.
        /// Set to `0.5` ratio of screen width in landscape.
        public var sizes: Sizes = .init(
            portrait: .fraction(AlertSize(width: 0.75)),
            landscape: .fraction(AlertSize(width: 0.5))
        )
        
        /// Rounded corners. Set to to `allCorners`.
        public var roundedCorners: RectCorner = .allCorners
        
        /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
        public var reversesLeftAndRightCornersForRTLLanguages: Bool = true
        
        /// Corner radius. Set to `20`.
        public var cornerRadius: CGFloat = 20
        
        /// Additional margins applied to title text, message text, and content as a whole. Set to `15` leading, `15` trailing,`15` top, and `10` bottom.
        public var titleTextMessageTextAndContentMargins: Margins = .init(
            leading: GlobalUIModel.Common.containerContentMargin,
            trailing: GlobalUIModel.Common.containerContentMargin,
            top: GlobalUIModel.Common.containerContentMargin,
            bottom: 10
        )
        
        /// Title text line type. Set to `singleLine`.
        public var titleTextLineType: TextLineType = .singleLine
        
        /// Title text margins. Set to `0` leading, `0` trailing, `5` top, and `3` bottom.
        public var titleTextMargins: Margins = .init(
            leading: 0,
            trailing: 0,
            top: 5,
            bottom: 3
        )
        
        /// Message line type. Set to `multiline` with `center` alignment and `1...5` lines.
        public var messageTextLineType: TextLineType = {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                return .multiLine(alignment: .center, lineLimit: 1...5)
            } else {
                return .multiLine(alignment: .center, lineLimit: 5)
            }
        }()
        
        /// Message text margins. Set to `0` leading, `0` trailing, `3` top, and `5` bottom.
        public var messageTextMargins: Margins = .init(
            leading: 0,
            trailing: 0,
            top: 3,
            bottom: 5
        )
        
        /// Content margins  Set to `0` leading, `0` trailing, `10` top, and `0` bottom.
        public var contentMargins: Margins = .init(
            leading: 0,
            trailing: 0,
            top: 10,
            bottom: 0
        )
        
        /// Button height. Set to  `40`.
        public var buttonHeight: CGFloat = 40
        
        /// Button corner radius. Set to `10`.
        public var buttonCornerRadius: CGFloat = 10
        
        /// Button margins. Set to `15` leading, `15` trailing, `10` top, and `15` bottom.
        public var buttonMargins: Margins = .init(
            leading: GlobalUIModel.Common.containerContentMargin,
            trailing: GlobalUIModel.Common.containerContentMargin,
            top: 10,
            bottom: GlobalUIModel.Common.containerContentMargin
        )
        
        /// Spacing between horizontal buttons.  Set to `10`.
        public var horizontalButtonSpacing: CGFloat = 10
        
        /// Spacing between vertical buttons.  Set to `5`.
        public var verticalButtonSpacing: CGFloat = 5

        /// Container edges ignored by modal container. Set to `[]`.
        ///
        /// Setting this property to `all` may cause container to ignore explicit `sizes`.
        public var ignoredContainerSafeAreaEdgesByContainer: Edge.Set = []

        /// Keyboard edges ignored by modal container. Set to `[]`.
        ///
        /// Setting this property to `all` may cause container to ignore explicit `sizes`.
        public var ignoredKeyboardSafeAreaEdgesByContainer: Edge.Set = []

        /// Container edges ignored by modal content. Set to `[]`.
        public var ignoredContainerSafeAreaEdgesByContent: Edge.Set = []

        /// Keyboard edges ignored by modal content. Set to `[]`.
        public var ignoredKeyboardSafeAreaEdgesByContent: Edge.Set = []

        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Sizes
        /// Model that represents modal sizes.
        public typealias Sizes = ModalSizes<AlertSize>
        
        // MARK: Alert Size
        /// Alert size.
        public struct AlertSize: Equatable, ScreenRelativeSizeMeasurement {
            // MARK: Properties
            /// Width.
            public var width: CGFloat
            
            // MARK: Initializers
            /// Initializes `BottomSheetSize`.
            public init(
                width: CGFloat
            ) {
                self.width = width
            }
            
            // MARK: Screen Relative Size Measurement
            public static func relativeMeasurementToPoints(_ measurement: Self) -> Self {
                .init(
                    width: MultiplatformConstants.screenSize.width * measurement.width
                )
            }
        }
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
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
        
        /// Dimming view color.
        public var dimmingView: Color = GlobalUIModel.Common.dimmingViewColor
        
        /// Title text color.
        public var titleText: Color = ColorBook.primary
        
        /// Message text color.
        public var messageText: Color = ColorBook.primary
        
        /// Primary button background colors.
        public var primaryButtonBackground: ButtonStateColors = .init(
            enabled: ColorBook.controlLayerBlue,
            pressed: ColorBook.controlLayerBluePressed,
            disabled: ColorBook.controlLayerBlueDisabled
        )
        
        /// Primary button title colors.
        public var primaryButtonTitle: ButtonStateColors = .init(ColorBook.primaryWhite)
        
        /// Secondary button background colors.
        public var secondaryButtonBackground: ButtonStateColors = .init( // `clear` cannot be used, otherwise button won't register gestures
            enabled: ColorBook.layer,
            pressed: Color(module: "Alert.LayerColoredButton.Background.Pressed"),
            disabled: ColorBook.layer
        )
        
        /// Secondary button title colors.
        public var secondaryButtonTitle: ButtonStateColors = .init(
            enabled: ColorBook.accentBlue,
            pressed: ColorBook.accentBlue, // Looks better
            disabled: ColorBook.accentBluePressedDisabled
        )
        
        /// Destructive button background colors.
        public var destructiveButtonBackground: ButtonStateColors = .init( // `clear` cannot be used, otherwise button won't register gestures
            enabled: ColorBook.layer,
            pressed: Color(module: "Alert.LayerColoredButton.Background.Pressed"),
            disabled: ColorBook.layer
        )
        
        /// Destructive button title colors.
        public var destructiveButtonTitle: ButtonStateColors = .init(
            enabled: ColorBook.accentRed,
            pressed: ColorBook.accentRed, // Looks better
            disabled: ColorBook.accentRedPressedDisabled
        )
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        /// Model that contains colors for button states.
        public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
    }
    
    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title text font. Set to `bold` `headline` (`17`).
        public var titleText: Font = .headline.weight(.bold)
        
        /// Message text font. Set to `subheadline` (`15`).
        public var messageText: Font = .subheadline
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Appear animation. Set to `linear` with duration `0.05`.
        public var appear: BasicAnimation? = GlobalUIModel.Modals.poppingAppearAnimation
        
        /// Disappear animation. Set to `easeIn` with duration `0.05`.
        public var disappear: BasicAnimation? = GlobalUIModel.Modals.poppingDisappearAnimation
        
        /// Scale effect during appear and disappear. Set to `1.01`.
        public var scaleEffect: CGFloat = GlobalUIModel.Modals.poppingAnimationScaleEffect
        
        /// Blur during appear and disappear. Set to `3`.
        public var blur: CGFloat = GlobalUIModel.Modals.poppingAnimationBlur
        
#if os(iOS)
        /// Button haptic feedback style. Set to `nil`.
        public var buttonHaptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil
#endif
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
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
    
    var primaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()
        
        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius
        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.layout.titleTextMinimumScaleFactor /= 2
        }
        
        uiModel.colors.background = colors.primaryButtonBackground
        uiModel.colors.titleText = colors.primaryButtonTitle
        
#if os(iOS)
        uiModel.animations.haptic = animations.buttonHaptic
#endif
        
        return uiModel
    }
    
    var secondaryButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()
        
        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius
        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.layout.titleTextMinimumScaleFactor /= 2
        }
        
        uiModel.colors.background = colors.secondaryButtonBackground
        uiModel.colors.titleText = colors.secondaryButtonTitle
        
#if os(iOS)
        uiModel.animations.haptic = animations.buttonHaptic
#endif
        
        return uiModel
    }
    
    var destructiveButtonSubUIModel: VStretchedButtonUIModel {
        var uiModel: VStretchedButtonUIModel = .init()
        
        uiModel.layout.height = layout.buttonHeight
        uiModel.layout.cornerRadius = layout.buttonCornerRadius
        if #unavailable(iOS 15.0) { // Alternative to dynamic size upper limit
            uiModel.layout.titleTextMinimumScaleFactor /= 2
        }
        
        uiModel.colors.background = colors.destructiveButtonBackground
        uiModel.colors.titleText = colors.destructiveButtonTitle
        
#if os(iOS)
        uiModel.animations.haptic = animations.buttonHaptic
#endif
        
        return uiModel
    }
}
