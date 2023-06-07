//
//  VCapsuleButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Capsule Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
public struct VCapsuleButtonUIModel {
    // MARK: Properties - General
    /// Height.
    /// Set to `32` on `iOS`.
    /// Set to `32` on `macOS`.
    /// Set to `48` on `watchOS`.
    public var height: CGFloat = {
#if os(iOS)
        return 32
#elseif os(macOS)
        return 32
#elseif os(watchOS)
        return 48
#else
        fatalError() // Not supported
#endif
    }()

    /// Corner radius. Set to half of `height`.
    public var cornerRadius: CGFloat { height / 2 }

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
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Title text colors.
    public var titleTextColors: StateColors = .init(ColorBook.primaryWhite)

    /// Title text font.
    /// Set to `semibold` `subheadline` (`15`) on `iOS`.
    /// Set to `semibold` `body` (`13`) on `macOS`.
    /// Set to `semibold` `body` (`17`) on `watchOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        return Font.subheadline.weight(.semibold)
#elseif os(macOS)
        return Font.body.weight(.semibold)
#elseif os(watchOS)
        return Font.body.weight(.semibold)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon size.
    /// Set to `16x16` on `iOS`.
    /// Set to `16x16` on `macOS`.
    /// Set to `18x18` on `watchOS`.
    public var iconSize: CGSize = {
#if os(iOS)
        return CGSize(dimension: 16)
#elseif os(macOS)
        return CGSize(dimension: 16)
#elseif os(watchOS)
        return CGSize(dimension: 18)
#else
        fatalError() // Not supported
#endif
    }()

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

    /// Ratio to which label scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var labelPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    /// Spacing between icon and title text. Set to `8`.
    ///
    /// Applicable only if icon `init` with icon and title is used.
    public var iconAndTitleTextSpacing: CGFloat = GlobalUIModel.Buttons.iconAndTitleTextSpacing

    /// Label margins. Set to `15` horizontal and `3` vertical.
    public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMargins

    // MARK: Properties - HitBox
    /// Hit box. Set to `zero`.
    public var hitBox: HitBox = .zero

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - State Change
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
    /// Model that contains `horizontal` and `vertical` hit boxes.
    public typealias HitBox = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
    
    // MARK: Sub UI Models
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()
        
        uiModel.animations.animatesStateChange = animatesStateChange
        
        return uiModel
    }
}
