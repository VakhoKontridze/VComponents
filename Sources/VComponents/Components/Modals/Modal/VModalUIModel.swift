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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VModalUIModel {
    // MARK: Properties - Global
    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    /// Color scheme. Set to `nil`.
    ///
    /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
    public var colorScheme: ColorScheme? = nil

    /// Modal sizes.
    /// Set to `0.9x0.6` container ratios in portrait.
    /// Set to reverse in landscape.
    public var sizes: Sizes = .init(
        portrait: Size(
            width: .fraction(0.9),
            height: .fraction(0.6)
        ),
        landscape: Size(
            width: .fraction(0.6),
            height: .fraction(0.9)
        )
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
    public var backgroundColor: Color = ColorBook.background

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.roundedCorners = roundedCorners
        uiModel.reversesLeftAndRightCornersForRTLLanguages = reversesLeftAndRightCornersForRTLLanguages
        uiModel.cornerRadius = cornerRadius

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy? = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

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
    public typealias Sizes = ModalComponentSizes<Size>

    // MARK: Size
    /// Model that represents modal size.
    public typealias Size = StandardModalComponentSize

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Dismiss Type
    /// Dismiss type, such as `backTap`.
    @OptionSetRepresentation<UInt64>(accessLevelModifier: "public")
    public struct DismissType {
        // MARK: Options
        private enum Options: Int {
            case backTap
        }

        // MARK: Options Initializers
        /// All dismiss methods.
        public static var all: Self { [.backTap] }

        /// Default value. Set to `[]`.
        public static var `default`: Self { [] }
    }

    // MARK: Methods
    /// Calculates modal height that wraps content.
    ///
    /// It's important to ensure that large content doesn't overflow beyond the container edges.
    /// Use `ScrollView` or `List` whenever appropriate.
    public func contentWrappingHeight(
        contentHeight: CGFloat
    ) -> CGFloat {
        contentMargins.verticalSum +
        contentHeight
    }
}

// MARK: - Factory
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
}
