//
//  VToggleUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Toggle UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VToggleUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        uiModel.animatesStateChange = false

        return uiModel
    }

    /// Toggle size.
    /// Set to `(51, 32)` on `iOS`.
    /// Set to `(38, 22)` on `macOS`.
    /// Set to `(34, 22)` on `watchOS`.
    public var size: CGSize = {
#if os(iOS)
        CGSize(width: 51, height: 31)
#elseif os(macOS)
        CGSize(width: 38, height: 22)
#elseif os(watchOS)
        CGSize(width: 34, height: 22)
#else
        fatalError() // Not supported
#endif
    }()

    /// Spacing between toggle and label.
    /// Set to `7` on `iOS`
    /// Set to `5` on `macOS`.
    /// Set to `5` on `watchOS`.
    public var toggleAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#elseif os(watchOS)
        5
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    var cornerRadius: CGFloat { size.height }

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.makeDynamic((235, 235, 235, 1), (60, 60, 60, 1)),
            on: Color.makeDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.makeDynamic((220, 220, 220, 1), (90, 90, 90, 1)),
            pressedOn: Color.makeDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.makeDynamic((240, 240, 240, 1), (50, 50, 50, 1))
        )
#elseif os(macOS)
        StateColors(
            off: Color.primary.opacity(0.1),
            on: Color.makeDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.primary.opacity(0.16),
            pressedOn: Color.makeDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.primary.opacity(0.03)
        )
#elseif os(watchOS)
        StateColors(
            off: Color.make((60, 60, 60, 1)),
            on: Color.make((25, 131, 255, 1)),
            pressedOff: Color.make((90, 90, 90, 1)),
            pressedOn: Color.make((36, 106, 186, 1)),
            disabled: Color.make((50, 50, 50, 1))
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    /// Set to `0` point on `iOS`.
    /// Set to `1` pixel on `macOS`.
    /// Set to `0` point on `watchOS`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#elseif os(watchOS)
        PointPixelMeasurement.points(0)
#else
        fatalError() // Not supported
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = {
#if os(iOS)
        StateColors.clearColors
#elseif os(macOS)
        StateColors(
            off: Color.makeDynamic((200, 200, 200, 1), (80, 80, 80, 1)),
            on: Color.clear,
            pressedOff: Color.makeDynamic((170, 170, 170, 1), (110, 110, 110, 1)),
            pressedOn: Color.clear,
            disabled: Color.makeDynamic((220, 220, 220, 1), (70, 70, 70, 1))
        )
#elseif os(watchOS)
        StateColors.clearColors
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Thumb
    /// Thumb dimension.
    /// Set to `(27, 27)` on `iOS`.
    /// Set to `(20, 20)` on `macOS`.
    /// Set to `(20, 20)` on `watchOS`.
    public var thumbSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 27)
#elseif os(macOS)
        CGSize(dimension: 20)
#elseif os(watchOS)
        CGSize(dimension: 20)
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb corner radius.
    /// Set to `13.5` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `10` on `watchOS`.
    public var thumbCornerRadius: CGFloat = {
#if os(iOS)
        13.5
#elseif os(macOS)
        10
#elseif os(watchOS)
        10
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb colors.
    public var thumbColors: StateColors = .init(
        off: Color.white,
        on: Color.white,
        pressedOff: Color.white,
        pressedOn: Color.white,
        disabled: Color.platformDynamic(light: Color.white, dark: Color.white.opacity(0.75))
    )

    // MARK: Properties - Label
    /// Indicates if label is clickable. Set to `true`.
    public var labelIsClickable: Bool = true

    // MARK: Properties - Label - Text
    /// Title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    public var titleTextLineType: TextLineType = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            .multiLine(alignment: .leading, lineLimit: 1...2)
        } else {
            .multiLine(alignment: .leading, lineLimit: 2)
        }
    }()

    /// Title text minimum scale factor. Set to `1`.
    public var titleTextMinimumScaleFactor: CGFloat = 1

    /// Title text colors.
    public var titleTextColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.primary,
            on: Color.primary,
            pressedOff: Color.primary,
            pressedOn: Color.primary,
            disabled: Color.primary.opacity(0.3)
        )
#elseif os(macOS)
        StateColors(
            off: Color.primary.opacity(0.85),
            on: Color.primary.opacity(0.85),
            pressedOff: Color.primary.opacity(0.85),
            pressedOn: Color.primary.opacity(0.85),
            disabled: Color.primary.opacity(0.85 * 0.3)
        )
#elseif os(watchOS)
        StateColors(
            off: Color.white,
            on: Color.white,
            pressedOff: Color.white,
            pressedOn: Color.white,
            disabled: Color.white.opacity(0.3)
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Title text font.
    /// Set to `subheadline` on `iOS`.
    /// Set to `body` on `macOS`.
    /// Set to `body` on `watchOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(macOS)
        Font.body
#elseif os(watchOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Transition
    /// Indicates if `stateChange` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesStateChangeAnimation: Bool = true

    /// State change animation. Set to `easeIn` with duration `0.1`.
    public var stateChangeAnimation: Animation? = .easeIn(duration: 0.1)

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `light`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light
#elseif os(watchOS)
    /// Haptic feedback type. Set to `click`.
    public var haptic: WKHapticType? = .click
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
}
