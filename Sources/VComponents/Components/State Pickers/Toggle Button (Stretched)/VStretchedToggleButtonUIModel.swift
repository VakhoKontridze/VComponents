//
//  VStretchedToggleButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched Toggle Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VStretchedToggleButtonUIModel {
    // MARK: Properties - Global
    /// Height.
    /// Set to `48` on `iOS`.
    /// Set to `40` on `macOS`.
    public var height: CGFloat = {
#if os(iOS)
        48
#elseif os(macOS)
        40
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius.
    /// Set to `14` on `iOS`.
    /// Set to `12` on `macOS`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        14
#elseif os(macOS)
        12
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.makeDynamic((235, 235, 235, 1), (60, 60, 60, 1)),
            on: Color.makeDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.makeDynamic((220, 220, 220, 1), (90, 90, 90, 1)),
            pressedOn: Color.makeDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.makeDynamic((245, 245, 245, 1), (50, 50, 50, 1))
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(light: Color.black.opacity(0.1), dark: Color.black.opacity(0.15)),
            on: Color.makeDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.dynamic(light: Color.black.opacity(0.16), dark: Color.black.opacity(0.3)),
            pressedOn: Color.makeDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.dynamic(light: Color.black.opacity(0.05), dark: Color.black.opacity(0.1))
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Ratio to which background scales down on press. Se to `1`.
    public var backgroundPressedScale: CGFloat = 1

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins. Set to `(15, 3)`.
    public var labelMargins: LabelMargins = .init(horizontal: 15, vertical: 3)

    /// Title text and icon placement. Set to `iconAndTitle`.
    public var titleTextAndIconPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title text and icon. Set to `8`.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleTextAndIconSpacing: CGFloat = 8

    /// Ratio to which label scales down on press. Se to `1`.
    public var labelPressedScale: CGFloat = 1

    // MARK: Properties - Label - Text
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text colors.
    public var titleTextColors: StateColors = .init(
        off: Color.primary,
        on: Color.white,
        pressedOff: Color.primary,
        pressedOn: Color.white,
        disabled: Color.primary.opacity(0.3)
    )

    /// Title text font.
    /// Set to `semibold` `callout` on `iOS`.
    /// Set to `semibold` `16` on `macOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        Font.callout.weight(.semibold)
#elseif os(macOS)
        Font.system(size: 16, weight: .semibold) // No dynamic type on `macOS`
#else
        fatalError() // Not supported
#endif
    }()

    let titleTextDynamicTypeSizeMax: DynamicTypeSize = .accessibility3

    // MARK: Properties - Label - Icon
    /// Icon size.
    /// Set to `(18, 18)` on `iOS`.
    /// Set to `(16, 16)` on `macOS`.
    public var iconSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 18)
#elseif os(macOS)
        CGSize(dimension: 16)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon colors.
    ///
    /// Applied to all images. But should be used for vector images.
    /// In order to use bitmap images, set this to `clear`.
    public var iconColors: StateColors = .init(
        off: Color.primary,
        on: Color.white,
        pressedOff: Color.primary,
        pressedOn: Color.white,
        disabled: Color.primary.opacity(0.3)
    )

    /// Icon opacities. Set to `1`s.
    ///
    /// Applied to all images. But should be used for bitmap images.
    /// In order to use vector images, set this to `1`s.
    public var iconOpacities: StateOpacities = .init(1)

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

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
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias LabelMargins = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_OffOnPressedDisabled<CGFloat>
}
