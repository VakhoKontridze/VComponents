//
//  VModalUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal UI Model
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VModalUIModel {
    // MARK: Properties - Global
    /// Color scheme. Set to `nil`.
    ///
    /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
    public var colorScheme: ColorScheme? = nil

    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.handlesKeyboardResponsiveness = handlesKeyboardResponsiveness
        uiModel.focusedViewKeyboardSafeAreInset = focusedViewKeyboardSafeAreInset

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Modal sizes.
    /// Set to `0.9x0.6` screen ratios in portrait.
    /// Set to reverse in landscape.
    public var sizes: Sizes = .init(
        portrait: .fraction(CGSize(width: 0.9, height: 0.6)),
        landscape: .fraction(CGSize(width: 0.6, height: 0.9))
    )

    // MARK: Properties - Corners
    /// Rounded corners. Set to to `allCorners`.
    public var roundedCorners: RectCorner = .allCorners

    /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
    public var reversesLeftAndRightCornersForRTLLanguages: Bool = true

    /// Corner radius. Set to `15`.
    public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = ColorBook.layer

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.roundedCorners = roundedCorners
        uiModel.reversesLeftAndRightCornersForRTLLanguages = reversesLeftAndRightCornersForRTLLanguages
        uiModel.cornerRadius = cornerRadius

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Header
    /// Header alignment. Set to `center`.
    public var headerAlignment: VerticalAlignment = .center

    /// Header margins. Set to `15` horizontal and `10` vertical.
    public var headerMargins: Margins = GlobalUIModel.Common.containerHeaderMargins

    /// Spacing between header label and close button. Set to `10`.
    public var headerLabelAndCloseButtonSpacing: CGFloat = GlobalUIModel.Modals.labelCloseButtonSpacing

    // MARK: Properties - Header - Title
    /// Header title text color.
    public var headerTitleTextColor: Color = ColorBook.primary

    /// Header title text font. Set to `bold` `headline` (`17`).
    public var headerTitleTextFont: Font = GlobalUIModel.Modals.headerTitleTextFont

    // MARK: Properties - Header - Close Button
    /// Model for customizing close button.
    /// `size` is set to `30x30`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `12x12`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var closeButtonSubUIModel: VRoundedButtonUIModel = {
        var uiModel: VRoundedButtonUIModel = .init()

        uiModel.size = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayDimension)

        uiModel.backgroundColors = VRoundedButtonUIModel.StateColors(
            enabled: GlobalUIModel.Common.circularButtonLayerColorEnabled,
            pressed: GlobalUIModel.Common.circularButtonLayerColorPressed,
            disabled: .clear // Doesn't matter
        )

        uiModel.iconSize = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
        uiModel.iconColors = VRoundedButtonUIModel.StateColors(GlobalUIModel.Common.circularButtonIconGrayColor)

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    // MARK: Properties - Divider
    /// Divider height. Set to `2` pixels.
    ///
    /// To hide divider, set to `0`, and remove header.
    public var dividerHeight: PointPixelMeasurement = .pixels(GlobalUIModel.Common.dividerHeightPx)

    /// Divider color.
    public var dividerColor: Color = GlobalUIModel.Common.dividerColor

    /// Divider margins. Set to `zero`.
    public var dividerMargins: Margins = .zero

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    // MARK: Properties - Safe Area
    /// Indicates if modal handles keyboard responsiveness. Set to `true`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var handlesKeyboardResponsiveness: Bool = true

    /// Keyboard safe area inset on focused view. Set to `20`.
    public var focusedViewKeyboardSafeAreInset: CGFloat = 20

    // MARK: Properties - Dismiss Type
    /// Method of dismissing modal. Set to `default`.
    public var dismissType: DismissType = .default

    // MARK: Properties - Dimming View
    /// Dimming view color.
    public var dimmingViewColor: Color = GlobalUIModel.Common.dimmingViewColor

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Appear animation. Set to `linear` with duration `0.05`.
    public var appearAnimation: BasicAnimation? = GlobalUIModel.Modals.poppingAppearAnimation

    /// Disappear animation. Set to `easeIn` with duration `0.05`.
    public var disappearAnimation: BasicAnimation? = GlobalUIModel.Modals.poppingDisappearAnimation

    /// Scale effect during appear and disappear. Set to `1.01`.
    public var scaleEffect: CGFloat = GlobalUIModel.Modals.poppingAnimationScaleEffect
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Sizes
    /// Model that represents modal sizes.
    public typealias Sizes = ModalSizes<CGSize>

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Dismiss Type
    /// Dismiss type, such as `leadingButton`, `trailingButton`, or `backTap`.
    public struct DismissType: OptionSet {
        // MARK: Options
        /// Leading.
        public static let leadingButton: Self = .init(rawValue: 1 << 0)

        /// Trailing.
        public static let trailingButton: Self = .init(rawValue: 1 << 1)

        /// Back-tap.
        public static let backTap: Self = .init(rawValue: 1 << 2)

        // MARK: Options Initializers
        /// All.
        public static var all: Self { [.leadingButton, .trailingButton, .backTap] }

        /// Default value. Set to `trailingButton`.
        public static var `default`: Self { .trailingButton }

        /// Indicates if dismiss type includes a button.
        public var hasButton: Bool {
            [.leadingButton, .trailingButton].contains(where: { contains($0) })
        }

        // MARK: Properties
        public let rawValue: Int

        // MARK: Initializers
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Factory
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VModalUIModel {
    /// `VModalUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
    
    /// `VModalUIModel` that stretches content to full size.
    ///
    /// It's recommended that you do not use header title or label with this configuration.
    public static var fullSizedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.dismissType.remove(.leadingButton)
        uiModel.dismissType.remove(.trailingButton)
        
        return uiModel
    }
}
