//
//  VWrappedButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Wrapped Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
public struct VWrappedButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animatesStateChange = animatesStateChange

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Height.
    /// Set to `32` on `iOS`.
    /// Set to `32` on `macOS`.
    /// Set to `48` on `watchOS`.
    public var height: CGFloat = GlobalUIModel.Buttons.heightWrappedButton

    // MARK: Properties - Corners
    /// Corner radius.
    /// Set to `16` on `iOS`.
    /// Set to `16` on `macOS`.
    public var cornerRadius: CGFloat = GlobalUIModel.Buttons.cornerRadiusWrappedButton

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
    /// Label margins. Set to `15` horizontal and `3` vertical.
    public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMargins

    /// Title text and icon placement. Set to `iconAndTitle`.
    public var titleTextAndIconPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title text and icon. Set to `8`.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleTextAndIconSpacing: CGFloat = GlobalUIModel.Buttons.titleTextAndIconSpacing

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
    /// Set to `semibold` `body` (`13`) on `macOS`.
    /// Set to `semibold` `body` (`17`) on `watchOS`.
    public var titleTextFont: Font = GlobalUIModel.Buttons.titleTextFontWrappedButton

    let titleTextDynamicTypeSizeMax: DynamicTypeSize = .accessibility3

    // MARK: Properties - Label - Icon
    /// Icon size.
    /// Set to `16x16` on `iOS`.
    /// Set to `16x16` on `macOS`.
    /// Set to `18x18` on `watchOS`.
    public var iconSize: CGSize = GlobalUIModel.Buttons.iconSizeWrappedButton

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

    // MARK: Properties - Transition
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
