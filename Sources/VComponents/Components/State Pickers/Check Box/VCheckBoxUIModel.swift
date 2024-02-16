//
//  VCheckBoxUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V CheckBox UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VCheckBoxUIModel {
    // MARK: Properties - Global
    /// Checkbox dimension. Set to `16`.
    public var dimension: CGFloat = 16

    /// Spacing between checkbox and label. Set to `0`.
    public var checkBoxAndLabelSpacing: CGFloat = 0

    // MARK: Properties - Corners
    /// Checkbox corner radius. Set to `5`.
    public var cornerRadius: CGFloat = 4

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.primaryInverted,
            on: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            indeterminate: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.primaryInverted,
            pressedOn: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            pressedIndeterminate: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.primaryInverted
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            on: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            indeterminate: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
            pressedOff: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            pressedOn: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            pressedIndeterminate: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
            disabled: Color.makeDynamic((250, 250, 250, 1), (0, 0, 0, 0.05))
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Border
    /// Border width. Set to `1`.
    public var borderWidth: CGFloat = 1

    /// Border colors.
    public var borderColors: StateColors = .init(
        off: Color.makePlatformDynamic((200, 200, 200, 1), (100, 100, 100, 1)),
        on: Color.clear,
        indeterminate: Color.clear,
        pressedOff: Color.makePlatformDynamic((170, 170, 170, 1), (130, 130, 130, 1)),
        pressedOn: Color.clear,
        pressedIndeterminate: Color.clear,
        disabled: Color.makePlatformDynamic((230, 230, 230, 1), (70, 70, 70, 1))
    )

    // MARK: Properties - Checkmark
    /// Checkmark icon (on).
    public var checkmarkIconOn: Image = ImageBook.checkmarkOn

    /// Checkmark icon (indeterminate).
    public var checkmarkIconIndeterminate: Image = ImageBook.checkmarkIndeterminate

    /// Checkmark icon dimension. Set to `9`.
    public var checkmarkIconDimension: CGFloat = 9

    /// Checkmark icon colors.
    public var checkmarkIconColors: StateColors = .init(
        off: Color.clear,
        on: Color.white,
        indeterminate: Color.white,
        pressedOff: Color.clear,
        pressedOn: Color.white,
        pressedIndeterminate: Color.white,
        disabled: Color.clear
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
        let enabled: Color = {
#if os(iOS)
            Color.primary
#elseif os(macOS)
            Color.primary.opacity(0.85)
#else
            fatalError() // Not supported
#endif
        }()

        let disabled: Color = {
#if os(iOS)
            Color.primary.opacity(0.3)
#elseif os(macOS)
            Color.primary.opacity(0.3).opacity(0.85)
#else
            fatalError() // Not supported
#endif
        }()

        return StateColors(
            off: enabled,
            on: enabled,
            indeterminate: enabled,
            pressedOff: enabled,
            pressedOn: enabled,
            pressedIndeterminate: enabled,
            disabled: disabled
        )
    }()

    /// Title text font.
    /// Set to `subheadline` on `iOS`.
    /// Set to `body` on `macOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(macOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Hit Box
    /// Checkbox hit box. Set to `5`.
    public var checkboxHitBox: HitBox = .init(5) // Actual spacing is 0

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

    // MARK: Hit Box
    /// Model that contains `leading`, `trailing`, `top` and `bottom` hit boxes.
    public typealias HitBox = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnIndeterminatePressedDisabled<Color>
}
