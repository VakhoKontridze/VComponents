//
//  VModalAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(watchOS, unavailable)
public struct VModalAppearance: Equatable, Sendable {
    // MARK: Properties - Global
    var modalPresenterLinkAppearance: ModalPresenterLinkAppearance {
        var appearance: ModalPresenterLinkAppearance = .init()
        appearance.preferredDimmingViewColor = preferredDimmingViewColor
        return appearance
    }
    
    /// Preferred dimming color, that overrides a shared color from `ModalPresenterRootAppearance`, when only this modal is presented.
    public var preferredDimmingViewColor: Color?
    
    /// Size group.
    public var sizeGroup: SizeGroup = {
#if os(iOS)
        SizeGroup(
            portrait: Size(
                width: .fixed(dimension: .fraction(0.9)),
                height: .fixed(dimension: .fraction(0.6))
            ),
            landscape: Size(
                width: .fixed(dimension: .fraction(0.6)),
                height: .fixed(dimension: .fraction(0.9))
            )
        )
#elseif os(macOS)
        SizeGroup(
            portrait: Size(
                width: .fixed(dimension: .fraction(0.5)),
                height: .fixed(dimension: .fraction(0.8))
            ),
            landscape: Size(
                width: .zero,
                height: .zero
            )
        )
#elseif os(tvOS)
        SizeGroup(
            portrait: Size(
                width: .fixed(dimension: .fraction(0.85)),
                height: .fixed(dimension: .fraction(0.8))
            ),
            landscape: Size(
                width: .zero,
                height: .zero
            )
        )
#elseif os(visionOS)
        SizeGroup(
            portrait: Size(
                width: .fixed(dimension: .fraction(0.5)),
                height: .fixed(dimension: .fraction(0.8))
            ),
            landscape: Size(
                width: .zero,
                height: .zero
            )
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radii.
    public var cornerRadii: RectangleCornerRadii = .init(15)

    /// Indicates if horizontal corners should switch to support RTL languages.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#elseif os(macOS)
        Color(nsColor: NSColor.windowBackgroundColor)
#elseif os(tvOS)
        Color.dynamic(Color.white, Color.black)
#elseif os(visionOS)
        Color.black
#else
        fatalError() // Not supported
#endif
    }()

    var groupBoxAppearance: VGroupBoxAppearance {
        var appearance: VGroupBoxAppearance = .init()

        appearance.cornerRadii = cornerRadii
        appearance.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        appearance.backgroundColor = backgroundColor

        appearance.borderWidth = borderWidth
        appearance.borderColor = borderColor

        appearance.contentMargins = EdgeInsets()

        return appearance
    }

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border color.
    public var borderColor: Color = .clear

    // MARK: Properties - Content
    /// Content margins.
    public var contentMargins: EdgeInsets = .init()

    // MARK: Properties - Dismiss Type
    /// Method of dismissing modal.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear/Disappear
    /// Scale effect during appear and disappear.
    public var scaleEffect: CGFloat = 1.01

    // MARK: Properties - Transition - Appear
    /// Appear animation.
    public var appearAnimation: Animation? = .linear(duration: 0.05)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation.
    public var disappearAnimation: Animation? = .easeIn(duration: 0.05)

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius.
    public var shadowRadius: CGFloat = 10

    /// Shadow offset.
    public var shadowOffset: CGPoint = .zero

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// Size group.
    public typealias SizeGroup = ModalComponentSizeGroup<Size>

    /// Size.
    public typealias Size = ModalComponentSize<Dimension, Dimension>

    /// Dimension.
    public enum Dimension: Equatable, Sendable {
        // MARK: Cases
        /// Fixed dimension.
        case fixed(dimension: AbsoluteFractionMeasurement)

        /// Wrapped dimension.
        case wrapped(margin: AbsoluteFractionMeasurement)

        /// Stretched dimension.
        case stretched(margin: AbsoluteFractionMeasurement)

        // MARK: Properties
        var margin: AbsoluteFractionMeasurement {
            switch self {
            case .fixed: .absolute(0)
            case .wrapped(let margin): margin
            case .stretched(let margin): margin
            }
        }

        // MARK: Initializers
        static var zero: Self {
            .fixed(dimension: .absolute(0))
        }
    }

    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet, Equatable, Sendable {
        // MARK: Options
        private enum Options: Int {
            case backTap
        }

        // MARK: Options Initializers
        /// Default value.
        public static var `default`: Self { [] }
    }
}

@available(watchOS, unavailable)
extension VModalAppearance {
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

@available(watchOS, unavailable)
extension VModalAppearance {
    /// `VModalAppearance` that insets content.
    public static var insettedContent: Self {
        var appearance: Self = .init()
        
        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}
