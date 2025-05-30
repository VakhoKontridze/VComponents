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
public struct VBottomSheetUIModel: Sendable {
    // MARK: Properties - Global
    var presentationHostSubUIModel: PresentationHostUIModel {
        var uiModel: PresentationHostUIModel = .init()
        uiModel.alignment = .top
        uiModel.preferredDimmingViewColor = preferredDimmingViewColor
        return uiModel
    }
    
    /// Preferred dimming color, that overrides a shared color from Presentation Host layer, when only this modal is presented.
    public var preferredDimmingViewColor: Color?

    /// Bottom sheet size group.
    /// Set to `[1, (0.6, 0.6, 0.9)]` `fraction`s in portrait and `(0.7, 0.9)` `fraction`s in landscape on `iOS`.
    /// Set to `(0.8, 0.8)` `fraction`s on `macOS`.
    public var sizeGroup: SizeGroup = {
#if os(iOS)
        SizeGroup(
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
        SizeGroup(
            portrait: Size(
                width: .fraction(0.8),
                heights: .fraction(0.8)
            ),
            landscape: Size(
                width: .zero,
                heights: .zero
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
        swipeDismissDistanceMinHeightRatio * heights.min.toAbsolute(dimension: containerHeight)
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
    public var shadowColor: Color = .black.opacity(0.15)

    /// Shadow radius. Set to `10`.
    public var shadowRadius: CGFloat = 10

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Size Group
    /// Bottom sheet size group..
    public typealias SizeGroup = ModalComponentSizeGroup<Size>

    // MARK: Size
    /// Bottom sheet size.
    @MemberwiseInitializable(
        comment: "/// Initializes `Size`."
    )
    public struct Size: Equatable, Sendable {
        /// Width.
        public var width: AbsoluteFractionMeasurement

        /// Heights.
        public var heights: Heights
    }

    // MARK: Heights
    /// Bottom sheet heights.
    ///
    /// Values used here may not represent actual values used in Bottom Sheet.
    /// If `ideal` is greater than `max`, it will be clamped to `max`.
    /// If `min` is greater than `ideal`, it will be clamped to `ideal`.
    public struct Heights: Equatable, Sendable {
        // MARK: Properties - Values
        /// Minimum height.
        public var min: AbsoluteFractionMeasurement

        /// Ideal height.
        public var ideal: AbsoluteFractionMeasurement

        /// Maximum height.
        public var max: AbsoluteFractionMeasurement

        // MARK: Properties - Flags
        func isResizable(
            in containerHeight: CGFloat
        ) -> Bool {
            min.toAbsolute(dimension: containerHeight) != ideal.toAbsolute(dimension: containerHeight) ||
            ideal.toAbsolute(dimension: containerHeight) != max.toAbsolute(dimension: containerHeight)
        }

        func isFixed(
            in containerHeight: CGFloat
        ) -> Bool {
            min.toAbsolute(dimension: containerHeight) == ideal.toAbsolute(dimension: containerHeight) &&
            ideal.toAbsolute(dimension: containerHeight) == max.toAbsolute(dimension: containerHeight)
        }

        // MARK: Properties - Offsets
        func minOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - min.toAbsolute(dimension: containerHeight) }

        func idealOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - ideal.toAbsolute(dimension: containerHeight) }

        func maxOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight - max.toAbsolute(dimension: containerHeight) }

        func hiddenOffset(in containerHeight: CGFloat) -> CGFloat { containerHeight }

        // MARK: Initializers
        /// Initializes `Heights` with values.
        public init(
            min: AbsoluteFractionMeasurement,
            ideal: AbsoluteFractionMeasurement,
            max: AbsoluteFractionMeasurement
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

        /// Initializes `Heights` with absolute values.
        public static func absolute(
            _ value: CGFloat
        ) -> Self {
            self.init(
                min: .absolute(value),
                ideal: .absolute(value),
                max: .absolute(value)
            )
        }

        /// Initializes `Heights` with fractional values, relative to container.
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

        /// Initializes `Heights` with fractional values, relative to container.
        public static func fraction(
            _ value: CGFloat
        ) -> Self {
            self.init(
                min: .fraction(value),
                ideal: .fraction(value),
                max: .fraction(value)
            )
        }

        static var zero: Self {
            .absolute(0)
        }
        
        // MARK: Value Fixing
        func withFixedValues(
            in containerHeight: CGFloat
        ) -> Self {
            let maxFixed: AbsoluteFractionMeasurement = max
            
            let idealFixed: AbsoluteFractionMeasurement = {
                if ideal.toAbsolute(dimension: containerHeight) <= maxFixed.toAbsolute(dimension: containerHeight) {
                    return ideal
                } else {
                    return maxFixed
                }
            }()
            
            let minFixed: AbsoluteFractionMeasurement = {
                if min.toAbsolute(dimension: containerHeight) <= idealFixed.toAbsolute(dimension: containerHeight) {
                    return min
                } else {
                    return idealFixed
                }
            }()
            
            return Self(
                min: minFixed,
                ideal: idealFixed,
                max: maxFixed
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
    public struct DismissType: OptionSet, Sendable {
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

// MARK: - V Bottom Sheet UI Model + Content Wrapping Height
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
