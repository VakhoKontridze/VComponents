//
//  VSideBarUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VSideBarUIModel: Sendable {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()
        uiModel.alignment = presentationEdge.toAlignment
        uiModel.preferredDimmingViewColor = preferredDimmingViewColor
        return uiModel
    }
    
    /// Preferred dimming color, that overrides a shared color from Presentation Host layer, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Edge from which side bar appears, and to which it disappears. Set to `leading`.
    ///
    /// Changing this property alone doesn't guarantee a proper behavior.
    /// Use `leading`, `trailing`, `top`, and `bottom` instances of `VSideBarUIModel` instead.
    public var presentationEdge: Edge = .leading

    /// Side bar size group.
    /// Set to `(0.75, 1)` `fraction`s in portrait and `(0.5, 1)` fraction in landscape on `iOS`.
    /// Set to `(0.33, 1)` `fraction`s on `macOS`.
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
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radii.
    /// Set to to `(0, 0, 15, 15)` on `iOS`.
    /// Set to to `0`s on `macOS`.
    public var cornerRadii: RectangleCornerRadii = {
#if os(iOS)
        RectangleCornerRadii(
            trailingCorners: 15
        )
#elseif os(macOS)
        RectangleCornerRadii()
#else
        fatalError() // Not supported
#endif
    }()

    /// Indicates if horizontal corners should switch to support RTL languages. Set to `true`.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#elseif os(macOS)
        Color(nsColor: NSColor.windowBackgroundColor)
#else
        fatalError() // Not supported
#endif
    }()

    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.cornerRadii = cornerRadii
        uiModel.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    /// Edges on which content has safe area margins. Set to `[]`.
    public var contentSafeAreaEdges: Edge.Set = []

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar. Set to `default`.
    public var dismissType: DismissType = .default

    // MARK: Properties - Transition - Appear
    /// Appear animation. Set to `easeInOut` with duration `0.3`.
    public var appearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    // MARK: Properties - Transition - Disappear
    /// Disappear animation. Set to `easeInOut` with duration `0.3`.
    ///
    /// This is a standard disappear animation. Other dismiss methods, such as swipe, are handled elsewhere.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    // MARK: Properties - Transition - Swipe Dismiss
    /// Ratio of width to drag side bar by to initiate dismiss. Set to `0.1`.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissDistanceWidthRatio: CGFloat = 0.1

    func swipeDismissDistance(in containerDimension: CGFloat) -> CGFloat { swipeDismissDistanceWidthRatio * containerDimension }

    /// Swipe dismiss animation. Set to `easeInOut` with duration `0.2`.
    ///
    /// Transition is non-interactive. Threshold has to be passed for dismiss to occur.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.2)

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius. Set to `10`.
    public var shadowRadius: CGFloat = 10

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Size Group
    /// Side bar size group.
    public typealias SizeGroup = ModalComponentSizeGroup<Size>

    // MARK: Size
    /// Side bar size.
    public typealias Size = ModalComponentSize<AbsoluteFractionMeasurement, AbsoluteFractionMeasurement>

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Dismiss Type
    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet, Sendable {
        // MARK: Options
        private enum Options: Int {
            case backTap
            case swipe
        }

        // MARK: Options Initializers
        /// Default value.
        /// Set to `all` on `iOS`.
        /// Set to `swipe` on `macOS`.
        public static var `default`: DismissType {
#if os(iOS)
            .all
#elseif os(macOS)
            .swipe
#else
            fatalError() // Not supported
#endif
        }
    }
}

// MARK: - V Side Bar UI Model + Default Content Safe Area Edges
#if canImport(UIKit) && !(os(tvOS) || os(watchOS))

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarUIModel {
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

// MARK: - Factory (Presentation Edge)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that presents side bar from leading edge.
    ///
    /// Default configuration.
    public static var leading: Self {
        .init()
    }
    
    /// `VSideBarUIModel` that presents side bar from trailing edge.
    ///
    /// `cornerRadii` is set to `(15, 15, 0, 0)` on `iOS`.
    /// `cornerRadii` is set to `0`s on `macOS`.
    public static var trailing: Self {
        var uiModel: Self = .init()

        uiModel.presentationEdge = .trailing
        
        uiModel.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                leadingCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError() // Not supported
#endif
        }()

        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from top edge.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizeGroup` is set to `(1, 0.5)` `fraction`s in portrait and `(1, 0.75)` `fraction`s in landscape on `iOS`.
    /// `sizeGroup` is set to `(1, 0.5)` `fraction`s on `macOS`.
    ///
    /// `cornerRadii` is set to `(0, 15, 15, 0)` on `iOS`.
    /// `cornerRadii` is set to `0`s on `macOS`.
    public static var top: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .top

        uiModel.sizeGroup = {
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
            fatalError() // Not supported
#endif
        }()

        uiModel.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                bottomCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError() // Not supported
#endif
        }()

        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from bottom edge.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizeGroup` is set to `(1, 0.5)` `fraction`s in portrait and `(1, 0.75)` `fraction`s in landscape on `iOS`.
    /// `sizeGroup` is set to `(1, 0.5)` `fraction`s on `macOS`.
    ///
    /// `cornerRadii` is set to `(15, 0, 0, 15)` on `iOS`.
    /// `cornerRadii` is set to `0`s on `macOS`.
    public static var bottom: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .bottom

        uiModel.sizeGroup = {
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
            fatalError() // Not supported
#endif
        }()

        uiModel.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                topCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError() // Not supported
#endif
        }()

        return uiModel
    }
}

// MARK: - Factory (Misc)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()

        uiModel.contentMargins = Margins(15)

        return uiModel
    }
}

// MARK: - Helpers
extension Edge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .leading: .leading
        case .bottom: .bottom
        case .trailing: .trailing
        }
    }
}
