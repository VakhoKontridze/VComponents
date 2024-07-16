//
//  VBottomSheetUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VBottomSheetUIModel {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()
        uiModel.alignment = .top
        return uiModel
    }

    /// Bottom sheet sizes.
    /// Set to `[1, (0.6, 0.6, 0.9)]` fractions in portrait and `(0.7, 0.9)` fractions in landscape on `iOS`.
    /// Set to `(0.8, 0.8)` fractions on `macOS`.
    public var sizes: Sizes = {
#if os(iOS)
        Sizes(
            portrait: Size(
                width: .fraction(1),
                heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
            ),
            landscape: Size(
                width: .fraction(0.7),
                heights: .fraction(0.9)
            )
        )
#elseif os(macOS)
        Sizes(
            portrait: Size(
                width: .fraction(0.8),
                heights: .fraction(0.8)
            ),
            landscape: Size(
                width: .absolute(0),
                heights: .absolute(0)
            )
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius. Set to `15`.
    public var cornerRadius: CGFloat = 15

    var cornerRadii: RectangleCornerRadii {
        .init(
            topCorners: cornerRadius
        )
    }

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
        uiModel.reversesHorizontalCornersForRTLLanguages = false // No need

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    // MARK: Properties - Drag Indicator
    /// Drag indicator size. Set to `(50, 4)`.
    ///
    /// To hide drag indicator, set to `zero`.
    public var dragIndicatorSize: CGSize = .init(width: 50, height: 4)

    /// Drag indicator corner radius. Set to `2`.
    public var dragIndicatorCornerRadius: CGFloat = 2

    /// Drag indicator color.
    public var dragIndicatorColor: Color = .dynamic(Color(200, 200, 200), Color(100, 100, 100))

    /// Drag indicator margins. Set to `(15, 15)`.
    public var dragIndicatorMargins: VerticalMargins = .init(15)

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    /// Edges on which content has safe area margins. Set to `[]`.
    public var contentSafeAreaEdges: Edge.Set = []

    /// Indicates if sheet resizes content based on its visible frame. Set to `false`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// Can be used for scrollable content.
    /// Optionally, add `bottom` to `contentSafeAreaEdges` to ensure that scrollable content always has bottom safe area inset.
    public var autoresizesContent: Bool = false

    /// Indicates if bottom sheet can be resized by dragging outside the header. Set to `false`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// Setting to `true` may cause issues with scrollable views.
    ///
    /// Has no effect on fixed bottom sheet.
    public var contentIsDraggable: Bool = false

    // MARK: Properties - Dismiss Type
    /// Method of dismissing modal. Set to `default`.
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
    /// Ratio of distance to drag bottom sheet by, past the min height, relative to it, to initiate dismiss. Set to `0.1`.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissDistanceMinHeightRatio: CGFloat = 0.1

    func swipeDismissDistance(
        heights: Heights,
        in containerHeight: CGFloat
    ) -> CGFloat {
        swipeDismissDistanceMinHeightRatio * heights.min.toAbsolute(in: containerHeight)
    }

    /// Swipe dismiss animation. Set to `easeInOut` with duration `0.15`.
    ///
    /// Has no effect unless `dismissType` includes `swipe`.
    public var swipeDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.15)

    // MARK: Properties - Transition - Snap
    /// Velocity at which sheet snaps to next height, regardless of sufficient distance traveled. Set to `600` points/s.
    public var velocityToSnapToNextHeight: CGFloat = 600

    /// Height snapping animation between `min`, `ideal`, and `max` states. Set to `interpolatingSpring`, with mass `1`, stiffness `300`, damping `30`, and initialVelocity `1`.
    public var heightSnapAnimation: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)

    // MARK: Properties - Keyboard Responsiveness
    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = .init(200, 200, 200, 0.5)

    /// Shadow radius. Set to `3`.
    public var shadowRadius: CGFloat = 3

    /// Shadow offset. Set to `(0, -3)`.
    public var shadowOffset: CGPoint = .init(x: 0, y: -3)

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Sizes
    /// Bottom sheet sizes.
    public typealias Sizes = ModalComponentSizeGroup<Size>

    // MARK: Size
    /// Bottom sheet size.
    @MemberwiseInitializable(
        comment: "/// Initializes `Size`."
    )
    public struct Size: Equatable {
        /// Width.
        public var width: ModalComponentDimension

        /// Heights.
        public var heights: Heights
    }

    // MARK: Heights
    /// Bottom sheet heights.
    @MemberwiseInitializable(accessLevelModifier: .private)
    public struct Heights: Equatable { // Values mustn't be variable to ensure that all are the same `case`s
        // MARK: Properties
        /// Minimum height.
        public let min: ModalComponentDimension

        /// Ideal height.
        public let ideal: ModalComponentDimension

        /// Maximum height.
        public let max: ModalComponentDimension

        /// Indicates if model allows resizing.
        public var isResizable: Bool {
            min.value != ideal.value ||
            ideal.value != max.value
        }

        /// Indicates if model suggests fully fixed height.
        public var isFixed: Bool {
            min.value == ideal.value &&
            ideal.value == max.value
        }

        func minOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - min.toAbsolute(in: containerHeight) }

        func idealOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - ideal.toAbsolute(in: containerHeight) }

        func maxOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - max.toAbsolute(in: containerHeight) }

        func hiddenOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight }

        // MARK: Initializers
        /// Initializes `Heights` with dimensions.
        public static func absolute(
            min: CGFloat,
            ideal: CGFloat,
            max: CGFloat
        ) -> Self {
            self.init(
                min: .absolute(min),
                ideal: .absolute(ideal),
                max: .absolute(max)
            )
        }

        /// Initializes `Heights` with dimensions.
        public static func absolute(
            _ value: CGFloat
        ) -> Self {
            self.init(
                min: .absolute(value),
                ideal: .absolute(value),
                max: .absolute(value)
            )
        }

        /// Initializes `Heights` with dimension fractions, relative to container.
        public static func fraction(
            min: CGFloat,
            ideal: CGFloat,
            max: CGFloat
        ) -> Self {
            self.init(
                min: .fraction(min),
                ideal: .fraction(ideal),
                max: .fraction(max)
            )
        }

        /// Initializes `Heights` with dimension fractions, relative to container.
        public static func fraction(
            _ value: CGFloat
        ) -> Self {
            self.init(
                min: .fraction(value),
                ideal: .fraction(value),
                max: .fraction(value)
            )
        }
    }

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Vertical Margins
    /// Model that contains `top` and `bottom` margins.
    public typealias VerticalMargins = EdgeInsets_TopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: Dismiss Type
    /// Dismiss type.
    @OptionSetRepresentation<Int>
    public struct DismissType: OptionSet {
        // MARK: Options
        private enum Options: Int {
            case backTap
            case swipe
        }

        // MARK: Options Initializers
        /// Default value. Set to  `swipe`.
        public static var `default`: Self { .swipe }
    }
}

// MARK: - Wrapped Content
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VBottomSheetUIModel {
    /// Calculates bottom sheet height that wraps content.
    ///
    /// It's important to ensure that large content doesn't overflow beyond the container edges.
    /// Use `ScrollView` or `List` whenever appropriate.
    public func contentWrappingHeight(
        contentHeight: CGFloat,
        safeAreaInsets: EdgeInsets
    ) -> CGFloat {
        let dragIndicatorHeight: CGFloat = {
            guard dragIndicatorSize.height > 0 else { return 0 }
            return dragIndicatorSize.height + dragIndicatorMargins.verticalSum
        }()

        let contentSafeAreaEdgesVerticalSum: CGFloat = {
            var result: CGFloat = 0
            if contentSafeAreaEdges.contains(.top) { result += safeAreaInsets.top }
            if contentSafeAreaEdges.contains(.bottom) { result += safeAreaInsets.bottom }
            return result
        }()

        return
            dragIndicatorHeight +
            contentMargins.verticalSum +
            contentSafeAreaEdgesVerticalSum +
            contentHeight
    }
}

// MARK: - Factory
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VBottomSheetUIModel {
    /// `VBottomSheetUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(15)
        
        return uiModel
    }

    /// `VBottomSheetUIModel` that hides drag indicator.
    ///
    /// It's worth considering setting `contentIsDraggable` to `true`.
    public static var noDragIndicator: Self {
        var uiModel: Self = .init()

        uiModel.dragIndicatorSize.height = 0

        return uiModel
    }
}
