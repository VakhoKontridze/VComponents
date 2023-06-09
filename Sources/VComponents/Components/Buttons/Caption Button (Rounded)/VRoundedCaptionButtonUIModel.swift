//
//  VRoundedCaptionButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rounded Caption Button UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
public struct VRoundedCaptionButtonUIModel {
    // MARK: Properties - General
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animations.animatesStateChange = animatesStateChange

        return uiModel
    }

    /// Spacing between rounded rectangle and caption.
    /// Set to `7` on `iOS`.
    /// Set to `3` on `watchOS`.
    public var rectangleAndCaptionSpacing: CGFloat = {
#if os(iOS)
        return 7
#elseif os(watchOS)
        return 3
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Rectangle Background
    /// Rectangle size.
    /// Set to `56x56` on `iOS`.
    /// Set to `64x56` on `watchOS`.
    public var rectangleSize: CGSize = GlobalUIModel.Buttons.sizeRoundedButton

    /// Rectangle corner radius. Set to `24`.
    public var rectangleCornerRadius: CGFloat = {
#if os(iOS)
        return 24
#elseif os(watchOS)
        return 24
#else
        fatalError() // Not supported
#endif
    }()

    /// Rectangle colors.
    public var rectangleColors: StateColors = .init(
        enabled: ColorBook.controlLayerBlueTransparent,
        pressed: ColorBook.controlLayerBlueTransparentPressed,
        disabled: ColorBook.controlLayerBlueTransparentDisabled
    )

    /// Ratio to which rectangle scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var rectanglePressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    // MARK: Properties - Rectangle Border
    /// Rectangle border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var rectangleBorderWidth: CGFloat = 0

    /// Rectangle border colors.
    public var rectangleBorderColors: StateColors = .clearColors

    // MARK: Properties - Icon
    /// Icon size.
    /// Set to `24x24` on `iOS`.
    /// Set to `26x26` on `watchOS`.
    public var iconSize: CGSize = GlobalUIModel.Buttons.iconSizeRoundedButton

    /// Icon colors.
    ///
    /// Applied to all images. But should be used for vector images.
    /// In order to use bitmap images, set this to `clear`.
    public var iconColors: StateColors = .init(
        enabled: GlobalUIModel.Buttons.transparentLayerLabelEnabled,
        pressed: GlobalUIModel.Buttons.transparentLayerLabelPressed,
        disabled: GlobalUIModel.Buttons.transparentLayerLabelDisabled
    )

    /// Icon opacities. Set to `1`s.
    ///
    /// Applied to all images. But should be used for bitmap images.
    /// In order to use vector images, set this to `1`s.
    public var iconOpacities: StateOpacities = .init(1)

    /// Icon margins. Set to `3`s.
    public var iconMargins: IconMargins = GlobalUIModel.Buttons.labelMarginsRoundedButton

    /// Ratio to which icon scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var iconPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    // MARK: Properties - Caption
    /// Maximum caption width. Set to `100`.
    public var captionWidthMax: CGFloat = 100

    /// Ratio to which caption scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var captionPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    /// Spacing between icon caption and title caption text. Set to `8`.
    public var iconCaptionAndTitleCaptionTextSpacing: CGFloat = GlobalUIModel.Buttons.iconAndTitleTextSpacing

    // MARK: Properties - Caption - Icon
    /// Icon caption size.
    /// Set to `16x16` on `iOS`.
    /// Set to `18x18` on `watchOS`
    public var iconCaptionSize: CGSize = {
#if os(iOS)
        return CGSize(dimension: 16)
#elseif os(watchOS)
        return CGSize(dimension: 18)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon caption colors.
    ///
    /// Applied to all images. But should be used for vector images.
    /// In order to use bitmap images, set this to `clear`.
    public var iconCaptionColors: StateColors = .init(
        enabled: ColorBook.primary,
        pressed: ColorBook.primaryPressedDisabled,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Icon caption opacities. Set to `1`s.
    ///
    /// Applied to all images. But should be used for bitmap images.
    /// In order to use vector images, set this to `1`s.
    public var iconCaptionOpacities: StateOpacities = .init(1)

    // MARK: Properties - Caption - Text
    /// Title caption text line type.
    /// Set to `multiline` with `center` alignment and `1...2` lines on `iOS`.
    /// Set to `singleLine` on `watchOS`.
    public var titleCaptionTextLineType: TextLineType = {
#if os(iOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return .multiLine(alignment: .center, lineLimit: 1...2)
        } else {
            return .multiLine(alignment: .center, lineLimit: 2)
        }
#elseif os(watchOS)
        return .singleLine
#else
        fatalError() // Not supported
#endif
    }()

    /// Title caption text colors.
    public var titleCaptionTextColors: StateColors = .init(
        enabled: ColorBook.primary,
        pressed: ColorBook.primaryPressedDisabled,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Title caption text minimum scale factor. Set to `0.75`.
    public var titleCaptionTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Title caption text font.
    /// Set to `subheadline` (`15`) on `iOS`.
    /// Set to `body` (`17`) on `watchOS`.
    public var titleCaptionTextFont: Font = {
#if os(iOS)
        return .subheadline
#elseif os(watchOS)
        return Font.body
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Shadow
    /// Shadow colors.
    ///
    /// By default, `background` of button is transparent.
    /// And applying shadow directly without making it opaque is not recommended.
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
    public typealias IconMargins = EdgeInsets_HorizontalVertical

    // MARK: Hit Box
    /// Model that contains `horizontal` and `vertical` hit boxes.
    public typealias HitBox = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
