//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - Color Book
typealias ColorBook = VComponentsColorBook

// MARK: - VComponents Color Book
/// Contains fundamental colors used throughout the library.
@NonInitializable
public struct VComponentsColorBook {
    // MARK: Properties - Basic
    /// Black color. Set to `(0, 0, 0)`.
    public static let black: Color = .init(.basicBlack)

    /// Black color for pressed and disabled states. Set to `(0, 0, 0, 30)`.
    public static let blackPressedDisabled: Color = .init(.basicBlackPressedDisabled)

    /// White color. Set to `(255, 255, 255)`.
    public static let white: Color = .init(.basicWhite)

    /// White color for pressed and disabled states. Set to `(255, 255, 255, 30)`.
    public static let whitePressedDisabled: Color = .init(.basicWhitePressedDisabled)

    // MARK: Properties - Background
    /// Background color. Set to `(254, 254, 254)` and `(28, 28, 28)`, like `UIColor.systemBackground`.
    public static let background: Color = .init(.background)

    /// Secondary background color. Set to `(247, 247, 247)` and `(0, 0, 0)`.
    public static let secondaryBackground: Color = .init(.secondaryBackground)

    // MARK: Properties - Text (Primary)
    /// Primary text color. Set to `(0, 0, 0)` and `(255, 255, 255`).
    public static let primary: Color = .init(.textPrimary)

    /// Primary text color for pressed and disabled states. Set to `(0, 0, 0, 30)` and `(255, 255, 255, 30`).
    public static let primaryPressedDisabled: Color = .init(.textPrimaryPressedDisabled)

    /// Primary text color that inverts color scheme. Set to `(255, 255, 255)` and `(0, 0, 0`).
    public static let primaryInverted: Color = .init(.textPrimaryInverted)

    /// Primary text color for pressed and disabled states that inverts color scheme. Set to `(255, 255, 255, 30)` and `(0, 0, 0, 30)`.
    public static let primaryInvertedPressedDisabled: Color = .init(.textPrimaryInvertedPressedDisabled)

    /// Primary black text color. Set to `(0, 0, 0)`.
    public static var primaryBlack: Color = .init(.textPrimaryBlack)

    /// Primary black text color for pressed and disabled states. Set to `(0, 0, 0, 30)`.
    public static var primaryBlackPressedDisabled: Color = .init(.textPrimaryBlackPressedDisabled)

    /// Primary white text color. Set to `(255, 255, 255)`.
    public static var primaryWhite: Color = .init(.textPrimaryWhite)

    /// Primary white text color for pressed and disabled states. Set to `(255, 255, 255, 30)`.
    public static var primaryWhitePressedDisabled: Color = .init(.textPrimaryWhitePressedDisabled)

    // MARK: Properties - Text (Secondary)
    /// Secondary text color. Set to `(60, 60, 67, 60)` `(235, 235, 245, 60)`, like `UIColor.secondaryLabel`.
    public static let secondary: Color = .init(.textSecondary)

    /// Secondary text color. Set to `(60, 60, 67, 20)` `(235, 235, 245, 20)`.
    public static let secondaryPressedDisabled: Color = .init(.textSecondaryPressedDisabled)

    // MARK: Properties - Accent
    /// Red accent color. Set to `(255, 59, 48)` and `(255, 69, 68)` like `UIColor.systemRed`.
    public static let accentRed: Color = .init(.accentRed)

    /// Red accent color for pressed and disabled states. Set to `(255, 59, 48, 30)` and `(255, 69, 68, 30)`.
    public static let accentRedPressedDisabled: Color = .init(.accentRedPressedDisabled)

    /// Green accent color. Set to `(52, 199, 89)` and `(48, 209, 88)`, like `UIColor.systemGreen`.
    public static let accentGreen: Color = .init(.accentGreen)

    /// Green accent color for pressed and disabled states. Set to `(52, 199, 89, 30)` and `(48, 209, 88, 30)`.
    public static let accentGreenPressedDisabled: Color = .init(.accentGreenPressedDisabled)

    /// Blue accent color. Set to `(0, 122, 255)` and `(10, 132, 255)`, like `UIColor.systemBlue`.
    public static let accentBlue: Color = .init(.accentBlue)

    /// Blue accent color for pressed and disabled states. Set to `(0, 122, 255, 30)` and `(10, 132, 255, 30)`.
    public static let accentBluePressedDisabled: Color = .init(.accentBluePressedDisabled)

    // MARK: Properties - Layer
    /// Gray layer color. `(235, 235, 235)` and `(60, 60, 60)`.
    public static let layerGray: Color = .init(.layerGray)

    /// Gray layer color for pressed state. `(220, 220, 220)` and `(80, 80, 80)`.
    public static let layerGrayPressed: Color = .init(.layerGrayPressed)

    /// Gray layer color and disabled state. `(245, 245, 245)` and `(50, 50, 50)`.
    public static let layerGrayDisabled: Color = .init(.layerGrayDisabled)

    /// Green layer color. `(235, 250, 240)` and `(130, 190, 140)`.
    public static let layerGreen: Color = .init(.layerGreen)

    /// Yellow layer color. `(255, 250, 240)` and `(240, 200, 120)`.
    public static let layerYellow: Color = .init(.layerYellow)

    /// Red layer color. `(250, 240, 240)` and `(230, 125, 125)`.
    public static let layerRed: Color = .init(.layerRed)

    // MARK: Properties - Layer (Control)
    /// Blue control layer. Set to `(24, 126, 240)` and `(25, 131, 255)`.
    public static let controlLayerBlue: Color = .init(.controlLayerBlue)

    /// Blue control layer for pressed state. Set to `(31, 104, 182)` and `(36, 106, 186)`.
    public static let controlLayerBluePressed: Color = .init(.controlLayerBluePressed)

    /// Blue control layer for disabled state. Set to `(128, 176, 240).
    public static let controlLayerBlueDisabled: Color = .init(.controlLayerBlueDisabled)

    /// Transparent blue control layer. Set to `(24, 126, 240, 25)` and `(25, 131, 255, 25)`.
    public static let controlLayerBlueTransparent: Color = .init(.controlLayerBlueTransparent)

    /// Transparent blue control layer for pressed state. Set to `(31, 104, 182, 25)` and `(36, 106, 186, 25)`.
    public static let controlLayerBlueTransparentPressed: Color = .init(.controlLayerBlueTransparentPressed)

    /// Transparent blue control layer for disabled state. Set to `(24, 126, 240, 25, 25)` and `(25, 131, 255, 25, 25)`.
    public static let controlLayerBlueTransparentDisabled: Color = .init(.controlLayerBlueTransparentDisabled)

    // MARK: Properties - Border
    /// Gray border color. Set to `(200, 200, 200)` and `(100, 100, 100)`.
    public static let borderGray: Color = .init(.borderGray)

    /// Gray border color for pressed state. Set to `(170, 170, 170)` and `(130, 130, 130)`.
    public static let borderGrayPressed: Color = .init(.borderGrayPressed)

    /// Gray border color for disabled state. Set to `(230, 230, 230)` and `(70, 70, 70)`.
    public static let borderGrayDisabled: Color = .init(.borderGrayDisabled)

    /// Green border color. Set to `(85, 195, 135)` and `(45, 150, 75)`.
    public static let borderGreen: Color = .init(.borderGreen)

    /// Yellow border color. Set to `(235, 110, 105)` and `(215, 60, 55)`.
    public static let borderYellow: Color = .init(.borderYellow)

    /// Red border color. Set to `(255, 190, 35)` and `(240, 150, 20)`.
    public static let borderRed: Color = .init(.borderRed)

    // MARK: Properties - Internal - Common
    static let _circularButtonLayer: Color = .init(.circularButtonLayer)
    static let _circularButtonLayerPressed: Color = .init(.circularButtonLayerPressed)
    static let _circularButtonLayerDisabled: Color = .init(.circularButtonLayerDisabled)

    static let _dimmingView: Color = .init(.dimmingView)

    static let _divider: Color = .init(.divider)

    static let _dividerDash: Color = .init(.dividerDash)
    static let _dividerDashDisabled: Color = .init(.dividerDashDisabled)

    static let _dragIndicator: Color = .init(.dragIndicator)

    static let _shadow: Color = .init(.shadow)
    static let _shadowDisabled: Color = .init(.shadowDisabled)

    // MARK: Properties - Internal - Component
    static let _alertLayerColoredButtonBackgroundPressed: Color = .init(.alertLayerColoredButtonBackgroundPressed)
    
    static let _pageIndicatorDeselectedDot: Color = .init(.pageIndicatorDeselectedDot)

    static let _stepperButtonBackgroundPressed: Color = .init(.stepperButtonBackgroundPressed)

    // MARK: Properties - Internal - Component Group
    static let _inputClearButtonIcon: Color = .init(.inputClearButtonIcon)

    static let _inputClearButtonLayer: Color = .init(.inputClearButtonLayer)
    static let _inputClearButtonLayerPressed: Color = .init(.inputClearButtonLayerPressed)
    static let _inputClearButtonLayerDisabled: Color = .init(.inputClearButtonLayerDisabled)

    static let _inputHeaderTitleTextAndFooterTitleTextGreen: Color = .init(.inputHeaderTitleTextAndFooterTitleTextGreen)
    static let _inputHeaderTitleTextAndFooterTitleTextYellow: Color = .init(.inputHeaderTitleTextAndFooterTitleTextYellow)
    static let _inputHeaderTitleTextAndFooterTitleTextRed: Color = .init(.inputHeaderTitleTextAndFooterTitleTextRed)

    static let _inputLayerGrayFocused: Color = .init(.inputLayerGrayFocused)

    static let _inputSearchIcon: Color = .init(.inputSearchIcon)
    static let _inputVisibilityButtonIcon: Color = .init(.inputVisibilityButtonIcon)

    static let _notificationLayerGreen: Color = .init(.notificationLayerGreen)
    static let _notificationLayerRed: Color = .init(.notificationLayerRed)
    static let _notificationLayerYellow: Color = .init(.notificationLayerYellow)

    static let _placeholderImage: Color = .gray.opacity(0.3)
}
