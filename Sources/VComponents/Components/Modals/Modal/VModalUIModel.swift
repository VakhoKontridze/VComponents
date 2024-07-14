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
@available(visionOS, unavailable)
public struct VModalUIModel {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel { .init() }
    
    /// Modal sizes.
    /// Set to `(0.9, 0.6)` container ratios in portrait.
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
    /// Corner radii . Set to to `15`s.
    public var cornerRadii: RectangleCornerRadii = .init(15)

    /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
    public var reversesLeftAndRightCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#else
        fatalError() // Not supported
#endif
    }()

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.cornerRadii = cornerRadii
        uiModel.reversesLeftAndRightCornersForRTLLanguages = reversesLeftAndRightCornersForRTLLanguages

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Dismiss Type
    /// Method of dismissing modal. Set to `default`.
    public var dismissType: DismissType = .default

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Appear animation. Set to `linear` with duration `0.05`.
    public var appearAnimation: BasicAnimation? = .init(curve: .linear, duration: 0.05)

    /// Disappear animation. Set to `easeIn` with duration `0.05`.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeIn, duration: 0.05)

    /// Scale effect during appear and disappear. Set to `1.01`.
    public var scaleEffect: CGFloat = 1.01
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Sizes
    /// Modal sizes.
    public typealias Sizes = ModalComponentSizes<Size>

    // MARK: Size
    /// Modal size.
    public typealias Size = StandardModalComponentSize

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Dismiss Type
    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet {
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
@available(visionOS, unavailable)
extension VModalUIModel {
    /// `VModalUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(15)

        return uiModel
    }
}
