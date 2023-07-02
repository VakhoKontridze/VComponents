//
//  VRoundedButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rounded Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
public struct VRoundedButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animations.animatesStateChange = animatesStateChange

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Size.
    /// Set to `56x56` on `iOS`.
    /// Set to `28x28` on `macOS`.
    /// Set to `64x56` on `watchOS`.
    public var size: CGSize = GlobalUIModel.Buttons.sizeRoundedButton

    // MARK: Properties - Corners
    /// Corner radius.
    /// Set to `16` on `iOS`.
    /// Set to `6` on `macOS`.
    /// Set to `16` on `watchOS`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        return 16
#elseif os(macOS)
        return 6
#elseif os(watchOS)
        return 16
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: ColorBook.controlLayerBlue,
        pressed: ColorBook.controlLayerBluePressed,
        disabled: ColorBook.controlLayerBlueDisabled
    )

    /// Ratio to which background scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var backgroundPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins. Set to `3`s.
    public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMarginsRoundedButton

    /// Ratio to which label scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var labelPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    // MARK: Properties - Label - Text
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Title text colors.
    public var titleTextColors: StateColors = .init(ColorBook.primaryWhite)

    /// Title text font.
    /// Set to `semibold` `subheadline` (`15`) on `iOS`.
    /// Set to `body` (`13`) on `macOS`.
    /// Set to `semibold` `body` (`17`) on `watchOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        return Font.subheadline.weight(.semibold)
#elseif os(macOS)
        return Font.body
#elseif os(watchOS)
        return Font.body.weight(.semibold)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Label - Icon
    /// Icon size.
    /// Set to `24x24` on `iOS`.
    /// Set to `14x14` on `macOS`.
    /// Set to `26x26` `watchOS`.
    public var iconSize: CGSize = GlobalUIModel.Buttons.iconSizeRoundedButton

    /// Icon colors.
    ///
    /// Applied to all images. But should be used for vector images.
    /// In order to use bitmap images, set this to `clear`.
    public var iconColors: StateColors = .init(ColorBook.primaryWhite)

    /// Icon opacities. Set to `1`s.
    ///
    /// Applied to all images. But should be used for bitmap images.
    /// In order to use vector images, set this to `1`s.
    public var iconOpacities: StateOpacities = .init(1)

    // MARK: Properties - Hit Box
    /// Hit box. Set to `zero`.
    public var hitBox: HitBox = .zero

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transitions
    /// Indicates if button animates state change. Set to `true`.
    public var animatesStateChange: Bool = true

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `nil`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil
#elseif os(watchOS)
    /// Haptic feedback type. Set to `nil`.
    public var haptic: WKHapticType? = nil
#endif
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias LabelMargins = EdgeInsets_HorizontalVertical

    // MARK: Hit Box
    /// Model that contains `leading`, `trailing`, `top` and `bottom` hit boxes.
    public typealias HitBox = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
