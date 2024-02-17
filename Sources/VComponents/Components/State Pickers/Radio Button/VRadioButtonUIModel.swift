//
//  VRadioButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VRadioButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        uiModel.animatesStateChange = false

        return uiModel
    }
    
    /// Radio button dimension.
    /// Set to `22` on `iOS`.
    /// Set to `16` on `macOS`
    public var dimension: CGFloat = {
#if os(iOS)
        22
#elseif os(macOS)
        16
#else
        fatalError() // Not supported
#endif
    }()

    /// Spacing between radio button and label. 
    /// Set to `7` on `iOS`
    /// Set to `5` on `macOS`.
    public var radioButtonAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(Color.primaryInverted)
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            on: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            pressedOff: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            pressedOn: Color.dynamic(light: Color.white, dark: Color.black.opacity(0.2)),
            disabled: Color.makeDynamic((250, 250, 250, 1), (0, 0, 0, 0.05))
        )
#else
        fatalError() // Not supported
#endif
    }()


    // MARK: Properties - Border
    /// Border width.
    /// Set to `1.5` on `iOS`.
    /// Set to `1` on `macOS`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = {
#if os(iOS)
        1.5
#elseif os(macOS)
        1
#else
        fatalError() // Not supported
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = .init(
        off: Color.makePlatformDynamic((200, 200, 200, 1), (100, 100, 100, 1)),
        on: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
        pressedOff: Color.makePlatformDynamic((170, 170, 170, 1), (130, 130, 130, 1)),
        pressedOn: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
        disabled: Color.makePlatformDynamic((230, 230, 230, 1), (70, 70, 70, 1))
    )

    // MARK: Properties - Bullet
    /// Bullet dimension. 
    /// Set to `12` on `iOS`.
    /// Set to `8` on `macOS`.
    public var bulletDimension: CGFloat = {
#if os(iOS)
        12
#elseif os(macOS)
        8
#else
        fatalError() // Not supported
#endif
    }()

    /// Bullet colors.
    public var bulletColors: StateColors = .init(
        off: Color.clear,
        on: Color.makePlatformDynamic((24, 126, 240, 1), (25, 131, 255, 1)),
        pressedOff: Color.clear,
        pressedOn: Color.makePlatformDynamic((31, 104, 182, 1), (36, 106, 186, 1)),
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
#else
        fatalError() // Not supported
#endif
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
    /// Radio button hit box. Set to `zero`.
    public var radioButtonHitBox: HitBox = .zero

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
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
}
