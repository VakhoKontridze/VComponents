//
//  VCarouselAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.07.24.
//

import SwiftUI
import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
public struct VCarouselAppearance {
    // MARK: Properties - Global
    /// Indicates if scrolling is enabled.
    public var isScrollingEnabled: Bool = true

    // MARK: Properties - Cards
    /// Cards alignment.
    public var cardsAlignment: VerticalAlignment = .center

    /// Spacing between cards.
    public var cardsSpacing: CGFloat = {
#if os(iOS)
        15
#elseif os(macOS)
        15
#elseif os(watchOS)
        7.5
#elseif os(visionOS)
        15
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Card - Global
    /// Card horizontal margin.
    ///
    /// This property determines margins around the selected card.
    public var cardMarginHorizontal: CGFloat = {
#if os(iOS)
        30
#elseif os(macOS)
        30
#elseif os(watchOS)
        15
#elseif os(visionOS)
        30
#else
        fatalError()
#endif
    }()

    /// Card top margin.
    public var cardMarginTop: CGFloat = 0

    /// Card bottom margin.
    public var cardMarginBottom: CGFloat = 0

    /// Card height scales.
    public var cardHeightScales: CardStateDimensions = .init(1)

    /// Card opacities.
    public var cardOpacities: CardStateOpacities = .init(1)

    // MARK: Properties - Card - Shadow
    /// Card shadow color.
    public var cardShadowColor: Color = .clear

    /// Card shadow radius.
    public var cardShadowRadius: CGFloat = 0

    /// Card shadow offset.
    public var cardShadowOffset: CGPoint = .zero

    // MARK: Properties - Transition - Selection
    /// Indicates if `appliesSelectionAnimation` is applied.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesSelectionAnimation: Bool = true

    /// State change animation.
    public var selectionAnimation: Animation? = .default

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Types
    /// State-bound dimensions.
    public typealias CardStateDimensions = GenericStateModel_DeselectedSelected<CGFloat>

    /// State-bound opacities.
    public typealias CardStateOpacities = GenericStateModel_DeselectedSelected<CGFloat>
}
