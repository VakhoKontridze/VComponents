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
@available(visionOS, unavailable)
public struct VLoadingStretchedButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animatesStateChange = animatesStateChange

        return uiModel
    }

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

    /// Spacing between label and spinner. Set to `20`.
    ///
    /// Only visible when state is set to `loading`.
    public var labelAndSpinnerSpacing: CGFloat = 20

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
    public var backgroundColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        loading: Color(128, 176, 240),
        disabled: Color(128, 176, 240)
    )

    /// Ratio to which background scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    public var backgroundPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Border
    /// Border width. Set to `0` points.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

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

    /// Ratio to which label scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    public var labelPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Label - Text
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text colors.
    public var titleTextColors: StateColors = .init(Color.white)

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

    /// Title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Label - Icon
    /// Indicates if `resizable(...)` modifier is applied to icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconResizable: Bool = true

    /// Icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconContentMode: ContentMode? = .fit

    /// Icon size.
    /// Set to `(18, 18)` on `iOS`.
    /// Set to `(16, 16)` on `macOS`.
    public var iconSize: CGSize? = {
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
    /// Changing this property conditionally will cause view state to be reset.
    public var iconColors: StateColors? = .init(Color.white)

    /// Icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconOpacities: StateOpacities?

    /// Icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconResizable` should be set to `false`, and `iconSize` should be set to `nil`.
    public var iconFont: Font?

    /// Icon `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Spinner
    /// Model for customizing spinner.
    /// `dimension` is set to `16`.
    /// `thickness` is set to `2`.
    /// `spinnerColor` is changed.
    public var spinnerSubUIModel: VContinuousSpinnerUIModel = {
        var uiModel: VContinuousSpinnerUIModel = .init()

        uiModel.dimension = 16
        uiModel.thickness = 2
        uiModel.color = Color.white

        return uiModel
    }()

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

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
    public typealias StateColors = GenericStateModel_EnabledPressedLoadingDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedLoadingDisabled<CGFloat>
}
