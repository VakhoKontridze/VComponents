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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VBottomSheetUIModel {
    // MARK: Properties - Global
    var presentationHostUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()

        uiModel.keyboardResponsivenessStrategy = keyboardResponsivenessStrategy

        return uiModel
    }

    /// Color scheme. Set to `nil`.
    public var colorScheme: ColorScheme? = nil

    /// Bottom sheet sizes.
    /// Set to `1` ratio of container width, and `(0.6, 0.6, 0.9)` ratios of container height in portrait.
    /// Set to `0.7` ratio of container width and `0.9` ratio of container height in landscape.
    public var sizes: Sizes = .init(
        portrait: Size(
            width: .fraction(1),
            heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
        ),
        landscape: Size(
            width: .fraction(0.7),
            heights: .fraction(0.9)
        )
    )

    // MARK: Properties - Corners
    /// Corner radius. Set to `15`.
    public var cornerRadius: CGFloat = 15

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

        uiModel.roundedCorners = .topCorners
        uiModel.cornerRadius = cornerRadius

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
    public var dragIndicatorColor: Color = .dynamic(Color(200, 200, 200, 1), Color(100, 100, 100, 1))

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

    // MARK: Properties - Keyboard Responsiveness
    /// Keyboard responsiveness strategy. Set to `default`.
    ///
    /// Changing this property after modal is presented may cause unintended behaviors.
    public var keyboardResponsivenessStrategy: PresentationHostUIModel.KeyboardResponsivenessStrategy = .default

    /// Indicates if keyboard is dismissed when interface orientation changes. Set to `true`.
    public var dismissesKeyboardWhenInterfaceOrientationChanges: Bool = true

    // MARK: Properties - Dismiss Type
    /// Method of dismissing modal. Set to `default`.
    public var dismissType: DismissType = .default

    /// Velocity at which sheet snaps to next height, regardless of sufficient distance traveled. Set to `600` points/s.
    public var velocityToSnapToNextHeight: CGFloat = 600

    /// Ratio of distance to drag sheet downwards to initiate dismiss relative to min height. Set to `0.1`.
    public var pullDownDismissDistanceMinHeightRatio: CGFloat = 0.1

    func pullDownDismissDistance(
        heights: Heights,
        in containerHeight: CGFloat
    ) -> CGFloat {
        pullDownDismissDistanceMinHeightRatio * heights.min.toAbsolute(in: containerHeight)
    }

    // MARK: Properties - Dimming View
    /// Dimming view color.
    public var dimmingViewColor: Color = .clear

    // MARK: Properties - Shadow
    /// Shadow color.
    public var shadowColor: Color = Color(200, 200, 200, 0.5)

    /// Shadow radius. Set to `3`.
    public var shadowRadius: CGFloat = 3

    /// Shadow offset. Set to `(0, -3)`.
    public var shadowOffset: CGPoint = .init(x: 0, y: -3)

    // MARK: Properties - Transition
    /// Appear animation. Set to `easeInOut` with duration `0.3`.
    public var appearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    /// Disappear animation. Set to `easeInOut` with duration `0.3`.
    public var disappearAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.3)

    /// Pull-down dismiss animation. Set to `easeInOut` with duration `0.1`.
    public var pullDownDismissAnimation: BasicAnimation? = .init(curve: .easeInOut, duration: 0.1)

    /// Height snapping animation between `min`, `ideal`, and `max` states. Set to `interpolatingSpring`, with mass `1`, stiffness `300`, damping `30`, and initialVelocity `1`.
    public var heightSnapAnimation: Animation = .interpolatingSpring(mass: 1, stiffness: 300, damping: 30, initialVelocity: 1)
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Sizes
    /// Model that represents bottom sheet sizes.
    public typealias Sizes = ModalComponentSizes<Size>

    // MARK: Size
    /// Model that represents bottom sheet size.
    public struct Size: Equatable {
        // MARK: Properties
        /// Width.
        public var width: ModalComponentDimension

        /// Heights.
        public var heights: Heights

        // MARK: Initializers
        /// Initializes `BottomSheetSize`.
        public init(
            width: ModalComponentDimension,
            heights: Heights
        ) {
            self.width = width
            self.heights = heights
        }
    }

    // MARK: Heights
    /// Model that represents bottom sheet heights.
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
        private init(
            min: ModalComponentDimension,
            ideal: ModalComponentDimension,
            max: ModalComponentDimension
        ) {
            self.min = min
            self.ideal = ideal
            self.max = max
        }

        /// Initializes `Heights` with absolute values.
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

        /// Initializes `Heights` with absolute value.
        public static func absolute(
            _ value: CGFloat
        ) -> Self {
            self.init(
                min: .absolute(value),
                ideal: .absolute(value),
                max: .absolute(value)
            )
        }

        /// Initializes `Heights` with point values.
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

        /// Initializes `Heights` with fraction value.
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
    /// Dismiss type, such as `backTap`, or `pullDown`.
    @OptionSetRepresentation<Int>(accessLevelModifier: "public")
    public struct DismissType: OptionSet {
        // MARK: Options
        private enum Options: Int {
            case backTap
            case pullDown
        }

        // MARK: Options Initializers
        /// All dismiss methods.
        public static var all: Self { [.backTap, .pullDown] }

        /// Default value. Set to  `pullDown`.
        public static var `default`: Self { .pullDown }
    }

    // MARK: Methods
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
@available(macOS, unavailable)
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
