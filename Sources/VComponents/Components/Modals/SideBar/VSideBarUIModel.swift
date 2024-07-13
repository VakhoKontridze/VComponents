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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VSideBarUIModel {
    // MARK: Properties - Global
    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }
    
    /// Color scheme. Set to `nil`.
    ///
    /// Component will automatically inherit color scheme from the context.
    /// But if it's overridden with modifiers, this property must be set.
    ///
    /// `SwiftUI` previews may have difficulty displaying correct `ColorScheme`.
    public var colorScheme: ColorScheme?

    /// Edge from which side bar appears, and to which it disappears. Set to `leading`.
    ///
    /// Changing this property in model alone doesn't guarantee proper sizes and rounding.
    /// Consider using `leading`, `trailing`, `top`, and `bottom` instances of `VSideBarUIModel`.
    public var presentationEdge: Edge = .leading

    /// Side bar sizes. Set to `default`.
    /// Set to `(0.75, 1)` container ratios in portrait.
    /// Set to `(0.5, 1)` container ratios in landscape.
    public var sizes: Sizes = .init(
        portrait: Size(
            width: .fraction(0.75),
            height: .fraction(1)
        ),
        landscape: Size(
            width: .fraction(0.5),
            height: .fraction(1)
        )
    )

    // MARK: Properties - Corners
    /// Corner radii . Set to to `(0, 0, 15, 15)`.
    public var cornerRadii: RectangleCornerRadii = .init(
        topLeading: 0,
        bottomLeading: 0,
        bottomTrailing: 15,
        topTrailing: 15
    )

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

    /// Edges on which content has safe area margins. Set to `[]`.
    public var contentSafeAreaEdges: Edge.Set = []

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Dimming View
    /// Dimming view color.
    public var dimmingViewColor: Color = .dynamic(Color(100, 100, 100, 0.3), Color.black.opacity(0.4))

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .clear

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar. Set to `default`.
    public var dismissType: DismissType = .default

    /// Ratio of distance to drag side bar backward to initiate dismiss relative to width. Set to `0.1`.
    public var dragBackDismissDistanceWidthRatio: CGFloat = 0.1

    func dragBackDismissDistance(in containerDimension: CGFloat) -> CGFloat { dragBackDismissDistanceWidthRatio * containerDimension }

    // MARK: Properties - Transition
    /// Appear animation.  Set to `easeInOut` with duration `0.3`.
    public var appearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    /// Disappear animation.  Set to `easeInOut` with duration `0.3`.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    /// Drag-back dismiss animation. Set to `easeInOut` with duration `0.1`.
    public var dragBackDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.1)

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Sizes
    /// Model that represents side bar sizes.
    public typealias Sizes = ModalComponentSizes<Size>

    // MARK: Size
    /// Model that represents side bar size.
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
            case dragBack
        }

        // MARK: Options Initializers
        /// All dismiss methods.
        public static var all: DismissType { [.backTap, .dragBack] }

        /// Default value. Set to `all`.
        public static var `default`: DismissType { .all }
    }
}

// MARK: - Safe Area
#if canImport(UIKit) && !(os(tvOS) || os(watchOS))

@available(macOS, unavailable)
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
@available(macOS, unavailable)
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
    /// `cornerRadii` is set to `(15, 15, 0, 0)`.
    public static var trailing: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .trailing
        
        uiModel.cornerRadii = RectangleCornerRadii(
            topLeading: 15,
            bottomLeading: 15,
            bottomTrailing: 0,
            topTrailing: 0
        )

        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from top edge.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizes` are set to `(0.75, 1)` container ratios in portrait.
    /// And to `(0.5, 1)` container ratios in landscape.
    ///
    /// `cornerRadii` is set to `(0, 15, 15, 0)`.
    public static var top: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .top

        uiModel.sizes = Sizes(
            portrait: Size(
                width: .fraction(1),
                height: .fraction(0.5)
            ),
            landscape: Size(
                width: .fraction(1),
                height: .fraction(0.75)
            )
        )
        
        uiModel.cornerRadii = RectangleCornerRadii(
            topLeading: 0,
            bottomLeading: 15,
            bottomTrailing: 15,
            topTrailing: 0
        )

        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from bottom edge.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizes` are set to `(0.75, 1)` container ratios in portrait.
    /// And to `(0.5, 1)` container ratios in landscape.
    ///
    /// `cornerRadii` is set to `(15, 0, 0, 15)`.
    public static var bottom: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .bottom
        
        uiModel.sizes = Sizes(
            portrait: Size(
                width: .fraction(1),
                height: .fraction(0.5)
            ),
            landscape: Size(
                width: .fraction(1),
                height: .fraction(0.75)
            )
        )
        
        uiModel.cornerRadii = RectangleCornerRadii(
            topLeading: 15,
            bottomLeading: 0,
            bottomTrailing: 0,
            topTrailing: 15
        )

        return uiModel
    }
}

// MARK: - Factory (Misc)
@available(macOS, unavailable)
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
