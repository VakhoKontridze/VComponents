//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextFieldAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var secure: Self {
        var appearance: Self = .init()
        
        appearance.style = .secure
        
        return appearance
    }
    
    @available(*, deprecated, message: "Use new mutating API")
    public static var search: Self {
        var appearance: Self = .init()
        
        appearance.style = .search
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var success: Self {
        var appearance: Self = .init()
        
        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()
        
        return appearance
    }
    
    @available(*, deprecated, message: "Use new mutating API")
    public static var warning: Self {
        var appearance: Self = .init()
        
        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()
        
        return appearance
    }
    
    @available(*, deprecated, message: "Use new mutating API")
    public static var error: Self {
        var appearance: Self = .init()
        
        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyErrorColorScheme()
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applySuccessColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        borderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyWarningColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        borderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyErrorColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        borderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VTextViewAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var success: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var error: Self {
        var appearance: Self = .init()

        appearance.borderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyErrorColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applySuccessColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        borderColors.focused = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyWarningColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        borderColors.focused = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyErrorColorScheme() {
        borderColors.enabled = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        borderColors.focused = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VCodeEntryViewAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var success: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applySuccessColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyWarningColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var error: Self {
        var appearance: Self = .init()

        appearance.characterBackgroundBorderWidth = PointPixelMeasurement.points(1.5)
        appearance.applyErrorColorScheme()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applySuccessColorScheme() {
        characterBackgroundBorderColors.enabledEmpty = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        characterBackgroundBorderColors.enabledFilled = characterBackgroundBorderColors.enabledEmpty
        characterBackgroundBorderColors.focusedEmpty = Color.platformDynamic(Color(85, 195, 135), Color(45, 150, 75))
        characterBackgroundBorderColors.focusedFilled = characterBackgroundBorderColors.focusedEmpty
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyWarningColorScheme() {
        characterBackgroundBorderColors.enabledEmpty = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        characterBackgroundBorderColors.enabledFilled = characterBackgroundBorderColors.enabledEmpty
        characterBackgroundBorderColors.focusedEmpty = Color.platformDynamic(Color(255, 190, 35), Color(240, 150, 20))
        characterBackgroundBorderColors.focusedFilled = characterBackgroundBorderColors.focusedEmpty
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyErrorColorScheme() {
        characterBackgroundBorderColors.enabledEmpty = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        characterBackgroundBorderColors.enabledFilled = characterBackgroundBorderColors.enabledEmpty
        characterBackgroundBorderColors.focusedEmpty = Color.platformDynamic(Color(235, 110, 105), Color(215, 60, 55))
        characterBackgroundBorderColors.focusedFilled = characterBackgroundBorderColors.focusedEmpty
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VNotificationAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var info: Self {
        var appearance: Self = .init()

        appearance.applyInfoColorScheme()
        appearance.sensoryFeedback = .success

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var success: Self {
        var appearance: Self = .init()

        appearance.applySuccessColorScheme()
        appearance.sensoryFeedback = .success

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var warning: Self {
        var appearance: Self = .init()

        appearance.applyWarningColorScheme()
        appearance.sensoryFeedback = .warning

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var error: Self {
        var appearance: Self = .init()

        appearance.applyErrorColorScheme()
        appearance.sensoryFeedback = .error

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyInfoColorScheme() {
        backgroundColor = Color.platformDynamic(Color(0, 150, 230), Color(0, 100, 190))

        imageBackgroundColor = Color.platformDynamic(Color(0, 120, 200), Color(0, 75, 15))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applySuccessColorScheme() {
        backgroundColor = Color.platformDynamic(Color(70, 190, 125), Color(40, 135, 75))

        imageBackgroundColor = Color.platformDynamic(Color(40, 160, 95), Color(10, 105, 45))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyWarningColorScheme() {
        backgroundColor = Color.platformDynamic(Color(255, 205, 95), Color(230, 160, 40))

        imageBackgroundColor = Color.platformDynamic(Color(225, 175, 65), Color(200, 130, 10))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyErrorColorScheme() {
        backgroundColor = Color.platformDynamic(Color(235, 95, 90), Color(205, 50, 45))

        imageBackgroundColor = Color.platformDynamic(Color(205, 65, 60), Color(175, 20, 15))
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VToastAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var info: Self {
        var appearance: Self = .init()
        
        appearance.applyInfoColorScheme()
        appearance.sensoryFeedback = .success
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var success: Self {
        var appearance: Self = .init()
        
        appearance.applySuccessColorScheme()
        appearance.sensoryFeedback = .success
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var warning: Self {
        var appearance: Self = .init()
        
        appearance.applyWarningColorScheme()
        appearance.sensoryFeedback = .warning
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var error: Self {
        var appearance: Self = .init()
        
        appearance.applyErrorColorScheme()
        appearance.sensoryFeedback = .error
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyInfoColorScheme() {
        backgroundColor = Color.platformDynamic(Color(0, 150, 230), Color(0, 100, 190))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applySuccessColorScheme() {
        backgroundColor = Color.platformDynamic(Color(70, 190, 125), Color(40, 135, 75))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyWarningColorScheme() {
        backgroundColor = Color.platformDynamic(Color(255, 205, 95), Color(230, 160, 40))
    }

    @available(*, deprecated, message: "Use new mutating API")
    public mutating func applyErrorColorScheme() {
        backgroundColor = Color.platformDynamic(Color(235, 95, 90), Color(205, 50, 45))
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VGroupBoxAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var systemBackgroundColor: Self {
        var appearance: Self = .init()

#if os(iOS)
        appearance.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        return appearance
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VDisclosureGroupAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedContent: Self {
        var appearance: Self = .init()
        
        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VDisclosureGroupAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var systemBackgroundColor: Self {
        var appearance: Self = .init()

#if os(iOS)
        appearance.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        appearance.disclosureButtonAppearance.backgroundColors = VRectangularButtonAppearance.StateColors(
            enabled: Color.platformDynamic(Color(230, 230, 230), Color(60, 60, 60)),
            pressed: Color.platformDynamic(Color(210, 210, 210), Color(40, 40, 40)),
            disabled: Color.platformDynamic(Color(240, 240, 240), Color(40, 40, 40))
        )

        return appearance
    }
}

extension VBouncingMarqueeAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedGradientMask: Self {
        var appearance: Self = .init()
        
        appearance.inset = 20
        
        appearance.gradientMaskWidth = 20
        
        return appearance
    }
}

extension VWrappingMarqueeAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedGradientMask: Self {
        var appearance: Self = .init()
        
        appearance.wrappedContentSpacing = 0
        appearance.inset = 20
        
        appearance.gradientMaskWidth = 20
        
        return appearance
    }
}

extension VPageIndicatorAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var vertical: Self {
        var appearance: Self = .init()
        
        appearance.direction = .topToBottom
        
        return appearance
    }
}

extension VCompactPageIndicatorAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var vertical: Self {
        var appearance: Self = .init()

        appearance.direction = .topToBottom

        return appearance
    }
}

@available(watchOS, unavailable)
extension VModalAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedContent: Self {
        var appearance: Self = .init()
        
        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VBottomSheetAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedContent: Self {
        var appearance: Self = .init()
        
        appearance.contentMargins = EdgeInsets(15)
        
        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var noDragIndicator: Self {
        var appearance: Self = .init()

        appearance.dragIndicatorSize.height = 0

        return appearance
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VSideBarAppearance {
    @available(*, deprecated, message: "Use new mutating API")
    public static var leading: Self {
        .init()
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var trailing: Self {
        var appearance: Self = .init()

        appearance.presentationEdge = .trailing
        
        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                leadingCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var top: Self {
        var appearance: Self = .init()
        
        appearance.presentationEdge = .top

        appearance.sizeGroup = {
#if os(iOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .fraction(1),
                    height: .fraction(0.75)
                )
            )
#elseif os(macOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .absolute(0),
                    height: .absolute(0)
                )
            )
#else
            fatalError()
#endif
        }()

        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                bottomCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var bottom: Self {
        var appearance: Self = .init()
        
        appearance.presentationEdge = .bottom

        appearance.sizeGroup = {
#if os(iOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .fraction(1),
                    height: .fraction(0.75)
                )
            )
#elseif os(macOS)
            SizeGroup(
                portrait: Size(
                    width: .fraction(1),
                    height: .fraction(0.5)
                ),
                landscape: Size(
                    width: .absolute(0),
                    height: .absolute(0)
                )
            )
#else
            fatalError()
#endif
        }()

        appearance.cornerRadii = {
#if os(iOS)
            RectangleCornerRadii(
                topCorners: 15
            )
#elseif os(macOS)
            RectangleCornerRadii()
#else
            fatalError()
#endif
        }()

        return appearance
    }

    @available(*, deprecated, message: "Use new mutating API")
    public static var insettedContent: Self {
        var appearance: Self = .init()

        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}
