//
//  VLoadingStretchedButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VLoadingStretchedButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animatesStateChange = animatesStateChange

        return uiModel
    }

    // MARK: Properties - Global Layout
    /// Height.
    /// Set to `48` on `iOS`.
    /// Set to `40` on `macOS`.
    public var height: CGFloat = GlobalUIModel.Buttons.heightStretchedButton

    /// Spacing between label and spinner. Set to `20`.
    ///
    /// Only visible when state is set to `loading`.
    public var labelAndSpinnerSpacing: CGFloat = 20

    // MARK: Properties - Corners
    /// Corner radius.
    /// Set to `14` on `iOS`.
    /// Set to `12` on `macOS`.
    public var cornerRadius: CGFloat = GlobalUIModel.Buttons.cornerRadiusStretchedButton

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: ColorBook.controlLayerBlue,
        pressed: ColorBook.controlLayerBluePressed,
        loading: ColorBook.controlLayerBlueDisabled,
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

    /// Spacing between icon and title text. Set to `8`.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var iconAndTitleTextSpacing: CGFloat = GlobalUIModel.Buttons.iconAndTitleTextSpacing

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
    /// Set to `semibold` `callout` (`16`) on `iOS`.
    /// Set to `semibold` `16` on `macOS`.
    public var titleTextFont: Font = GlobalUIModel.Buttons.titleTextFontStretchedButton

    // MARK: Properties - Label - Icon
    /// Icon size.
    /// Set to `18x18` on `iOS`.
    /// Set to `16x16` on `macOS`.
    public var iconSize: CGSize = GlobalUIModel.Buttons.iconSizeStretchedButton

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

    // MARK: Properties - Spinner
    /// Model for customizing spinner.
    /// `spinnerColor` is changed.
    public var spinnerSubUIModel: VContinuousSpinnerUIModel = {
        var uiModel: VContinuousSpinnerUIModel = .init()

        uiModel.color = ColorBook.primaryWhite

        return uiModel
    }()

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
    /// Haptic feedback style. Set to `medium`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = GlobalUIModel.Buttons.hapticStretchedButtonIOS
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias LabelMargins = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedLoadingDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedLoadingDisabled<CGFloat>
}
