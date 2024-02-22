//
//  VCheckBoxUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VCore

// MARK: - V Check Box UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VCheckBoxUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        uiModel.animatesStateChange = false

        return uiModel
    }
    
    /// Checkbox dimension.
    /// Set to `(22, 22)` on `iOS`.
    /// Set to `(16, 16)` on `macOS`
    public var size: CGSize = {
#if os(iOS)
        CGSize(dimension: 22)
#elseif os(macOS)
        CGSize(dimension: 16)
#else
        fatalError() // Not supported
#endif
    }()

    /// Spacing between checkbox and label.
    /// Set to `7` on `iOS`
    /// Set to `5` on `macOS`.
    public var checkBoxAndLabelSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(macOS)
        5
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Checkbox corner radius.
    /// Set to `11` on `macOS`.
    /// Set to `4` on `macOS`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        11
#elseif os(macOS)
        4
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.primaryInverted,
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            indeterminate: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.primaryInverted,
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            pressedIndeterminate: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.primaryInverted
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            indeterminate: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.dynamic(Color.white, Color.black.opacity(0.2)),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            pressedIndeterminate: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.dynamic(Color(250, 250, 250), Color.black.opacity(0.05))
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
        off: Color.platformDynamic(Color(200, 200, 200), Color(100, 100, 100)),
        on: Color.clear,
        indeterminate: Color.clear,
        pressedOff: Color.platformDynamic(Color(170, 170, 170), Color(130, 130, 130)),
        pressedOn: Color.clear,
        pressedIndeterminate: Color.clear,
        disabled: Color.platformDynamic(Color(230, 230, 230), Color(70, 70, 70))
    )

    // MARK: Properties - Checkmark
    /// Checkmark icon (on).
    public var checkmarkIconOn: Image = ImageBook.checkmarkOn.renderingMode(.template)

    /// Checkmark icon (indeterminate).
    public var checkmarkIconIndeterminate: Image = ImageBook.checkmarkIndeterminate.renderingMode(.template)

    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isCheckmarkIconResizable: Bool = true

    /// Icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var checkmarkIconContentMode: ContentMode? = .fit

    /// Icon size. 
    /// Set to `(11, 11)` on `iOS`.
    /// Set to `(9, 9)` on `macOS`.
    public var checkmarkIconSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 11)
#elseif os(macOS)
        CGSize(dimension: 9)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var checkmarkIconColors: StateColors? = .init(
        off: Color.clear,
        on: Color.white,
        indeterminate: Color.white,
        pressedOff: Color.clear,
        pressedOn: Color.white,
        pressedIndeterminate: Color.white,
        disabled: Color.clear
    )

    /// Icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var checkmarkIconOpacities: StateOpacities?

    /// Icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isCheckmarkIconResizable` should be set to `false`, and `checkmarkIconSize` should be set to `nil`.
    public var checkmarkIconFont: Font?

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
            indeterminate: Color.primary,
            pressedOff: Color.primary,
            pressedOn: Color.primary,
            pressedIndeterminate: Color.primary,
            disabled: Color.primary.opacity(0.3)
        )
#elseif os(macOS)
        StateColors(
            off: Color.primary.opacity(0.85),
            on: Color.primary.opacity(0.85),
            indeterminate: Color.primary.opacity(0.85),
            pressedOff: Color.primary.opacity(0.85),
            pressedOn: Color.primary.opacity(0.85),
            pressedIndeterminate: Color.primary.opacity(0.85),
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
    /// Checkbox hit box. Set to `zero`.
    public var checkboxHitBox: HitBox = .zero

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

    // MARK: State Opacities
    /// Model that contains colors for component opacities.
    public typealias StateOpacities = GenericStateModel_OffOnIndeterminatePressedDisabled<CGFloat>
}
