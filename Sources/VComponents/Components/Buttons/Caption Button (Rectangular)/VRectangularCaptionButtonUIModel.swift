//
//  VRectangularCaptionButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Caption Button UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularCaptionButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        uiModel.animatesStateChange = animatesStateChange

        return uiModel
    }

    /// Spacing between rectangle and caption.
    /// Set to `7` on `iOS`.
    /// Set to `3` on `watchOS`.
    public var rectangleAndCaptionSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(watchOS)
        3
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Rectangle Background
    /// Rectangle size.
    /// Set to `(56, 56)` on `iOS`.
    /// Set to `(64, 56)` on `watchOS`.
    public var rectangleSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 56)
#elseif os(watchOS)
        CGSize(width: 64, height: 56)
#else
        fatalError() // Not supported
#endif
    }()

    /// Rectangle corner radius. Set to `24`.
    public var rectangleCornerRadius: CGFloat = 24

    /// Rectangle colors.
    public var rectangleColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240, 0.25), Color(25, 131, 255, 0.35)),
        pressed: Color.platformDynamic(Color(31, 104, 182, 0.25), Color(36, 106, 186, 0.35)),
        disabled: Color(128, 176, 240, 0.35)
    )

    /// Ratio to which rectangle scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `0.98` on `watchOS`.
    public var rectanglePressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Rectangle Border
    /// Rectangle border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var rectangleBorderWidth: CGFloat = 0

    /// Rectangle border colors.
    public var rectangleBorderColors: StateColors = .clearColors

    // MARK: Properties - Icon
    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconResizable: Bool = true

    /// Icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconContentMode: ContentMode? = .fit

    /// Icon size.
    /// Set to `(24, 24)` on `iOS`.
    /// Set to `(26, 26)` on `watchOS`.
    public var iconSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 24)
#elseif os(watchOS)
        CGSize(dimension: 26)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconColors: StateColors? = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240, 0.5)
    )

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

    /// Ratio to which icon scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var iconPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon margins. Set to `(1, 1)`.
    public var iconMargins: IconMargins = .init(3)

    // MARK: Properties - Caption
    /// Maximum caption width. Set to `100`.
    public var captionWidthMax: CGFloat = 100

    /// Caption text frame alignment. Set to `center`.
    public var captionFrameAlignment: HorizontalAlignment = .center

    /// Title caption text and icon caption placement. Set to `iconAndTitle`.
    public var titleCaptionTextAndIconCaptionPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title caption text and icon caption. Set to `8`.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleCaptionTextAndIconCaptionSpacing: CGFloat = 8

    /// Ratio to which caption scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `0.98` on `watchOS`.
    public var captionPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Caption - Icon
    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to icon caption. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconCaptionResizable: Bool = true

    /// Icon caption content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionContentMode: ContentMode? = .fit

    /// Icon caption size.
    /// Set to `(16, 16)` on `iOS`.
    /// Set to `(18, 18)` on `watchOS`
    public var iconCaptionSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 16)
#elseif os(watchOS)
        CGSize(dimension: 18)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon caption colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionColors: StateColors? = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Icon caption opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionOpacities: StateOpacities?

    /// Icon caption font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconCaptionResizable` should be set to `false`, and `iconCaptionSize` should be set to `nil`.
    public var iconCaptionFont: Font?

    /// Icon caption `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Caption - Text
    /// Title caption text line type.
    /// Set to `multiline` with `center` alignment and `1...2` lines on `iOS`.
    /// Set to `singleLine` on `watchOS`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleCaptionTextLineType: TextLineType = {
#if os(iOS)
        .multiLine(
            alignment: .center,
            lineLimit: 1...2
        )
#elseif os(watchOS)
        .singleLine
#else
        fatalError() // Not supported
#endif
    }()

    /// Title caption text colors.
    public var titleCaptionTextColors: StateColors = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Title caption text minimum scale factor. Set to `0.75`.
    public var titleCaptionTextMinimumScaleFactor: CGFloat = 0.75

    /// Title caption text font.
    /// Set to `subheadline` on `iOS`.
    /// Set to `body` on `watchOS`.
    public var titleCaptionTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(watchOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    /// Title caption text `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleCaptionTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

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

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `nil`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle?
#elseif os(watchOS)
    /// Haptic feedback type. Set to `nil`.
    public var haptic: WKHapticType?
#endif
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias IconMargins = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
