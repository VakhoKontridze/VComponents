//
//  VTextFieldAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VTextFieldAppearance {
    // MARK: Properties - Global
    /// Height.
    public var height: CGFloat = 50
    
    /// Style.
    public var style: Style = .default

    /// Content horizontal margin.
    public var contentMarginHorizontal: CGFloat = 15

    /// Content horizontal spacing.
    public var contentSpacingHorizontal: CGFloat = 10
    
    // MARK: Properties - TextField
#if !(os(macOS) || os(watchOS))
    /// Keyboard type.
    public var keyboardType: UIKeyboardType = .default
#endif

#if !(os(macOS) || os(watchOS))
    /// Text content type.
    public var textContentType: UITextContentType?
#endif

    /// Indicates if auto correction is enabled.
    public var isAutocorrectionEnabled: Bool?

#if !(os(macOS) || os(watchOS))
    /// Auto capitalization type.
    public var autocapitalization: TextInputAutocapitalization?
#endif
    
    /// Submit button type.
    public var submitButton: SubmitLabel = .return

    // MARK: Properties - Corners
    /// Corner radius.
    public var cornerRadius: CGFloat = 12

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(235, 235, 235), Color(60, 60, 60)),
        focused: Color.platformDynamic(Color(220, 220, 220), Color(80, 80, 80)),
        disabled: Color.platformDynamic(Color(245, 245, 245), Color(50, 50, 50))
    )

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors
    
    // MARK: Properties - Text
    /// Text configuration.
    public var textConfiguration: StateTextConfiguration = .init(
        colors: StateColors(
            enabled: Color.primary,
            focused: Color.primary,
            disabled: Color.primary.opacity(0.3)
        ),
        font: Font.body
    )

    // MARK: Properties - Placeholder Text
    /// Placeholder text configuration.
    public var placeholderTextConfiguration: PlaceholderStateTextConfiguration = .init(
        colors: StateColors(Color.secondary),
        font: Font.body
    )

    // MARK: Properties - Clear Button
    /// Indicates if textfield has clear button.
    public var hasClearButton: Bool = true

    /// Clear button image.
    public var clearButtonImage: Image = ImageBook.Symbols.xmark

    /// Clear button appearance.
    public var clearButtonAppearance: VRectangularButtonAppearance = .init {
        $0.size = CGSize(dimension: 22)

        $0.backgroundColors = VRectangularButtonAppearance.StateColors(
            enabled: Color.platformDynamic(Color(170, 170, 170), Color(40, 40, 40)),
            pressed: Color.platformDynamic(Color(150, 150, 150), Color(20, 20, 20)),
            disabled: Color.platformDynamic(Color(220, 220, 220), Color(40, 40, 40))
        )
        
        $0.labelImageConfiguration = VRectangularButtonAppearance.StateImageConfiguration(
            colors: VRectangularButtonAppearance.StateColors(
                Color.platformDynamic(Color(255, 255, 255), Color(230, 230, 230))
            ),
            aspectRatio: ImageConfiguration.AspectRatio(
                contentMode: .fit
            ),
            resizable: ImageConfiguration.Resizable(),
            size: CGSize(dimension: 8)
        )

        $0.sensoryFeedback = nil
    }

    /// Clear button appear and disappear animation.
    public var clearButtonAppearDisappearAnimation: Animation?

    // MARK: Properties - Secure
    /// Visibility button image (off).
    public var visibilityOffButtonImage: Image = ImageBook.Symbols.eye

    /// Visibility button image (on).
    public var visibilityOnButtonImage: Image = ImageBook.Symbols.eyeCrossed

    /// Visibility button appearance.
    public var visibilityButtonAppearance: VPlainButtonAppearance = .init {
        $0.labelImageConfiguration = VPlainButtonAppearance.StateImageConfiguration(
            colors: VPlainButtonAppearance.StateColors(
                enabled: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
                pressed: Color.primary.opacity(0.3),
                disabled: Color.primary.opacity(0.3)
            ),
            aspectRatio: ImageConfiguration.AspectRatio(
                contentMode: .fit
            ),
            resizable: ImageConfiguration.Resizable(),
            size: CGSize(dimension: 20)
        )

        $0.sensoryFeedback = nil
    }

    // MARK: Properties - Search
    /// Search image configuration.
    public var searchImageConfiguration: StateImageConfiguration = .init(
        colors: StateColors(
            enabled: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
            focused: Color.platformDynamic(Color(70, 70, 70), Color(240, 240, 240)),
            disabled: Color.primary.opacity(0.3)
        ),
        aspectRatio: ImageConfiguration.AspectRatio(
            contentMode: .fit
        ),
        resizable: ImageConfiguration.Resizable(),
        size: CGSize(dimension: 15)
    )
    
    /// Search image.
    public var searchImage: Image = ImageBook.Symbols.magnifyGlass

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}
    
    /// Initializes appearance from the given base instance and applies the given configuration.
    public init(
        _ base: Self = .init(),
        _ configure: (inout Self) -> Void
    ) {
        self = base
        configure(&self)
    }

    // MARK: Types
    /// Style.
    nonisolated public enum Style: Int, Equatable, Sendable, CaseIterable {
        // MARK: Cases
        /// Standard.
        case standard

        /// Secure.
        ///
        /// Visibility image is present, and securities, such as copying is enabled.
        case secure

        /// Search.
        ///
        /// Magnification image is present.
        case search

        // MARK: Properties
        var hasSearchImage: Bool {
            switch self {
            case .standard: false
            case .secure: false
            case .search: true
            }
        }

        var hasClearButton: Bool {
            switch self {
            case .standard: true
            case .secure: false
            case .search: true
            }
        }

        var hasVisibilityButton: Bool {
            switch self {
            case .standard: false
            case .secure: true
            case .search: false
            }
        }

        // MARK: Initializers
        /// Default value.
        public static var `default`: Self { .standard }
    }

    /// State-bound colors.
    public typealias StateColors = GenericStateModel_EnabledFocusedDisabled<Color>

    /// State-bound opacities.
    public typealias StateOpacities = GenericStateModel_EnabledFocusedDisabled<CGFloat>
    
    /// State-bound text configuration.
    public typealias StateTextConfiguration = GenericStateTextConfiguration<StateColors>
    
    /// State-bound text configuration.
    public typealias PlaceholderStateTextConfiguration = GenericStateBasicTextConfiguration<StateColors>
    
    /// State-bound image configuration.
    public typealias StateImageConfiguration = GenericStateImageConfiguration<StateColors, StateOpacities>
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldAppearance {
    /// Applies secure style.
    public mutating func applySecureStyle() {
        style = .secure
    }
    
    /// Applies search style.
    public mutating func applySearchStyle() {
        style = .search
    }
    
    /// Applies success style.
    public mutating func applySuccessStyle() {
        applyBorder()
        borderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        borderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }
    
    /// Applies warning style.
    public mutating func applyWarningStyle() {
        applyBorder()
        borderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        borderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }
    
    /// Applies error style.
    public mutating func applyErrorStyle() {
        applyBorder()
        borderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        borderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
    
    private mutating func applyBorder() {
        borderWidth = PointPixelMeasurement.points(1.5)
    }
}
