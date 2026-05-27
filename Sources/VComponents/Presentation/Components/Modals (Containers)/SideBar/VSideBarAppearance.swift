//
//  VSideBarAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VSideBarAppearance {
    // MARK: Properties - Global
    var modalPresenterLinkAppearance: ModalPresenterLinkAppearance {
        var appearance: ModalPresenterLinkAppearance = .init()
        appearance.alignment = presentationEdge.toAlignment
        appearance.preferredDimmingViewColor = preferredDimmingViewColor
        return appearance
    }
    
    /// Preferred dimming color, that overrides a shared color from `ModalPresenterRootAppearance`, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Edge from which side bar appears, and to which it disappears.
    ///
    /// Changing this property alone doesn't guarantee a proper behavior.
    /// Use `leading`, `trailing`, `top`, and `bottom` instances of `VSideBarAppearance` instead.
    public var presentationEdge: Edge = .leading

    /// Size group.
    public var sizeGroup: SizeGroup = {
#if os(iOS)
        SizeGroup(
            portrait: Size(
                width: .fraction(0.75),
                height: .fraction(1)
            ),
            landscape: Size(
                width: .fraction(0.5),
                height: .fraction(1)
            )
        )
#elseif os(macOS)
        SizeGroup(
            portrait: Size(
                width: .fraction(0.33),
                height: .fraction(1)
            ),
            landscape: Size(
                width: .zero,
                height: .zero
            )
        )
#else
        fatalError()
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radii.
    public var cornerRadii: RectangleCornerRadii = {
#if os(iOS)
        RectangleCornerRadii(
            trailingCorners: 15
        )
#elseif os(macOS)
        RectangleCornerRadii()
#else
        fatalError()
#endif
    }()

    /// Indicates if horizontal corners should switch to support RTL languages.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#elseif os(macOS)
        Color(nsColor: NSColor.windowBackgroundColor)
#else
        fatalError()
#endif
    }()

    var groupBoxAppearance: VGroupBoxAppearance {
        var appearance: VGroupBoxAppearance = .init()

        appearance.cornerRadii = cornerRadii
        appearance.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        appearance.backgroundColor = backgroundColor

        appearance.contentMargins = EdgeInsets()

        return appearance
    }

    // MARK: Properties - Content
    /// Content margins.
    public var contentMargins: EdgeInsets = .init()

    /// Edges on which content has safe area margins.
    public var contentSafeAreaEdges: Edge.Set = []

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear
    /// Appear animation.
    public var appearAnimation: Animation? = .easeInOut(duration: 0.3)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation.
    ///
    /// This is a standard disappear animation. Other dismiss methods, such as swipe, are handled elsewhere.
    public var disappearAnimation: Animation? = .easeInOut(duration: 0.3)

    // MARK: Properties - Transition - Swipe Dismiss
    /// Ratio of width to drag side bar by to initiate dismiss.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissDistanceWidthRatio: CGFloat = 0.1

    func swipeDismissDistance(in containerDimension: CGFloat) -> CGFloat { swipeDismissDistanceWidthRatio * containerDimension }

    /// Swipe dismiss animation.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissAnimation: Animation? = .easeInOut(duration: 0.2)

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
    public typealias Size = ModalComponentSize<AbsoluteFractionMeasurement, AbsoluteFractionMeasurement>

    /// Dismiss type.
    @OptionSetRepresentation
    nonisolated public struct DismissType: Sendable {
        // MARK: Options
        nonisolated private enum Options: Int {
            case backTap
            case swipe
        }

        // MARK: Options Initializers
        /// Default value.
        public static var `default`: Self {
#if os(iOS)
            .all
#elseif os(macOS)
            .swipe
#else
            fatalError()
#endif
        }
    }
}

#if canImport(UIKit) && !(os(tvOS) || os(watchOS))

@available(visionOS, unavailable)
extension VSideBarAppearance {
    /// Calculates automatic `contentSafeAreaEdges` based on interface orientation.
    public func defaultContentSafeAreaEdges(
        interfaceOrientation: UIInterfaceOrientation
    ) -> Edge.Set {
        switch presentationEdge {
        case .leading:
            if interfaceOrientation.isLandscape {
                return .leading
            } else {
                return .vertical
            }

        case .trailing:
            if interfaceOrientation.isLandscape {
                return .trailing
            } else {
                return .vertical
            }

        case .top:
            if interfaceOrientation.isLandscape {
                return .horizontal
            } else {
                return .top
            }

        case .bottom:
            if interfaceOrientation.isLandscape {
                return .horizontal
            } else {
                return .bottom
            }
        }
    }
}

#endif

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarAppearance {
    /// `VSideBarAppearance` that presents side bar from leading edge.
    ///
    /// Default configuration.
    public static var leading: Self {
        .init()
    }
    
    /// `VSideBarAppearance` that presents side bar from trailing edge.
    public static var trailing: Self {
        var appearance: Self = .init()

        appearance.presentationEdge = .trailing
        
        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                leadingCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }
    
    /// `VSideBarAppearance` that presents side bar from top edge.
    public static var top: Self {
        var appearance: Self = .init()
        
        appearance.presentationEdge = .top

        appearance.sizeGroup = {
#if os(iOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .fraction(1),
                    height: .fraction(0.75)
                )
            )
#elseif os(macOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .absolute(0),
                    height: .absolute(0)
                )
            )
#else
            fatalError()
#endif
        }()

        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                bottomCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }
    
    /// `VSideBarAppearance` that presents side bar from bottom edge.
    public static var bottom: Self {
        var appearance: Self = .init()
        
        appearance.presentationEdge = .bottom

        appearance.sizeGroup = {
#if os(iOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .fraction(1),
                    height: .fraction(0.75)
                )
            )
#elseif os(macOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .absolute(0),
                    height: .absolute(0)
                )
            )
#else
            fatalError()
#endif
        }()

        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                topCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarAppearance {
    /// `VSideBarAppearance` that insets content.
    public static var insettedContent: Self {
        var appearance: Self = .init()

        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}

nonisolated extension Edge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .leading: .leading
        case .bottom: .bottom
        case .trailing: .trailing
        }
    }
}
