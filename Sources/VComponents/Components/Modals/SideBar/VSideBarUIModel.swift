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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VSideBarUIModel {
    // MARK: Properties - Global
    /// Color scheme. Set to `nil`.
    ///
    /// Since this is a modal, color scheme cannot be applied directly. Use this property instead.
    public var colorScheme: ColorScheme? = nil

    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Edge from which side bar appears, and to which it disappears. Set to `default`.
    ///
    /// Changing this property in model alone doesn't guarantee proper sizes and rounding.
    /// Consider using `leading`, `trailing`, `top`, and `bottom` instances of `VSideBarUIModel`.
    public var presentationEdge: PresentationEdge = .default

    /// Side bar sizes. Set to `default`.
    /// Set to `0.75x1` container ratios in portrait.
    /// Set to `0.5x1` container ratios in landscape.
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
    /// Rounded corners. Set to `rightCorners`.
    public var roundedCorners: RectCorner = .rightCorners

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

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    /// Edges on which content has safe area margins. Set to `[]`.
    public var contentSafeAreaMargins: Edge.Set = []

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy? = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

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

    // MARK: Properties - Dismiss Type
    /// Method of dismissing side bar. Set to `default`.
    public var dismissType: DismissType = .default

    /// Ratio of distance to drag side bar backward to initiate dismiss relative to width. Set to `0.1`.
    public var dragBackDismissDistanceWidthRatio: CGFloat = 0.1

    func dragBackDismissDistance(in containerDimension: CGFloat) -> CGFloat { dragBackDismissDistanceWidthRatio * containerDimension }

    // MARK: Properties - Transition
    /// Appear animation.  Set to `easeInOut` with duration `0.3`.
    public var appearAnimation: BasicAnimation? = GlobalUIModel.Modals.slidingAppearAnimation

    /// Disappear animation.  Set to `easeInOut` with duration `0.3`.
    public var disappearAnimation: BasicAnimation? = GlobalUIModel.Modals.slidingDisappearAnimation

    /// Drag-back dismiss animation. Set to `easeInOut` with duration `0.2`.
    public var dragBackDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.2)
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Presentation Edge
    /// Enumeration that represents presentation edge, such as `leading`, `trailing`, `top`, or `bottom`.
    public enum PresentationEdge: Int, CaseIterable {
        // MARK: Cases
        /// Presentation form leading edge.
        case leading

        /// Presentation form trailing edge.
        case trailing

        /// Presentation form top edge.
        case top

        /// Presentation form bottom edge.
        case bottom

        // MARK: Properties
        var alignment: Alignment {
            switch self {
            case .leading: return .leading
            case .trailing: return .trailing
            case .top: return .top
            case .bottom: return .bottom
            }
        }

        // MARK: Initializers
        /// Default value. Set to `leading`.
        public static var `default`: Self { .leading }
    }

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
    /// Dismiss type, such as `backTap, or `dragBack`.
    public struct DismissType: OptionSet {
        // MARK: Options
        /// Back tap.
        public static let backTap: Self = .init(rawValue: 1 << 0)

        /// Drag-back.
        public static let dragBack: Self = .init(rawValue: 1 << 1)

        // MARK: Options Initializers
        /// All.
        public static var all: DismissType { [.backTap, .dragBack] }

        /// Default value. Set to `all`.
        public static var `default`: DismissType { .all }

        // MARK: Properties
        public let rawValue: Int

        // MARK: Initializers
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Factory (Misc)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
}

// MARK: - Factory (Presentation Edge)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    /// `VSideBarUIModel` that presents side bar from leading edge.
    ///
    /// Default configuration.
    public static var leading: Self {
        .init()
    }
    
    /// `VSideBarUIModel` that presents side bar from trailing edge.
    ///
    /// `roundedCorners` is set to `leftCorners`.
    ///
    /// Sets `roundedCorners` to `leftCorners`.
    public static var trailing: Self {
        var uiModel: Self = .init()
        
        uiModel.presentationEdge = .trailing
        
        uiModel.roundedCorners = .leftCorners
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from top edge.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizes` are set to `0.75x1` container ratios in portrait.
    /// And to `0.5x1` container ratios in landscape.
    ///
    /// `roundedCorners` is set to `bottomCorners`.
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
        
        uiModel.roundedCorners = .bottomCorners
        
        return uiModel
    }
    
    /// `VSideBarUIModel` that presents side bar from bottom edge.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizes` are set to `0.75x1` container ratios in portrait.
    /// And to `0.5x1` container ratios in landscape.
    ///
    /// `roundedCorners` is set to `topCorners`.
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
        
        uiModel.roundedCorners = .topCorners
        
        return uiModel
    }
}
