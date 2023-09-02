//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - Color Book
/// Contains fundamental colors used throughout the library.
public struct ColorBook {
    // MARK: Properties - Basic
    /// Black color. Set to `(0, 0, 0)`.
    public static let black: Color = .init(module: "Black")
    
    /// Black color for pressed and disabled states. Set to `(0, 0, 0, 30)`.
    public static let blackPressedDisabled: Color = .init(module: "Black.PressedDisabled")
    
    /// White color. Set to `(255, 255, 255)`.
    public static let white: Color = .init(module: "White")
    
    /// White color for pressed and disabled states. Set to `(255, 255, 255, 30)`.
    public static let whitePressedDisabled: Color = .init(module: "White.PressedDisabled")
    
    // MARK: Properties - Text (Primary)
    /// Primary text color. Set to `(0, 0, 0)` and `(255, 255, 255`).
    public static let primary: Color = .init(module: "Text.Primary")
    
    /// Primary text color for pressed and disabled states. Set to `(0, 0, 0, 30)` and `(255, 255, 255, 30`).
    public static let primaryPressedDisabled: Color = .init(module: "Text.Primary.PressedDisabled")
    
    /// Primary text color that inverts color scheme. Set to `(255, 255, 255)` and `(0, 0, 0`).
    public static let primaryInverted: Color = .init(module: "Text.PrimaryInverted")
    
    /// Primary text color for pressed and disabled states that inverts color scheme. Set to `(255, 255, 255, 30)` and `(0, 0, 0, 30)`.
    public static let primaryInvertedPressedDisabled: Color = .init(module: "Text.PrimaryInverted.PressedDisabled")
    
    /// Primary black text color. Set to `(0, 0, 0)`.
    public static var primaryBlack: Color { black }
    
    /// Primary black text color for pressed and disabled states. Set to `(0, 0, 0, 30)`.
    public static var primaryBlackPressedDisabled: Color { blackPressedDisabled }
    
    /// Primary white text color. Set to `(255, 255, 255)`.
    public static var primaryWhite: Color { white }
    
    /// Primary white text color for pressed and disabled states. Set to `(255, 255, 255, 30)`.
    public static var primaryWhitePressedDisabled: Color { whitePressedDisabled }
    
    // MARK: Properties - Text (Secondary)
    /// Secondary text color. Set to `(60, 60, 67, 60)` `(235, 235, 245, 60)` like `UIColor.secondaryLabel`.
    public static let secondary: Color = .init(module: "Text.Secondary")
    
    /// Secondary text color. Set to `(60, 60, 67, 20)` `(235, 235, 245, 20)`.
    public static let secondaryPressedDisabled: Color = .init(module: "Text.Secondary.PressedDisabled")
    
    // MARK: Properties - Accent
    /// Red accent color. Set to `(255, 59, 48)` and `(255, 69, 68)` like `UIColor.systemRed`.
    public static let accentRed: Color = .init(module: "Accent.Red")

    /// Red accent color for pressed and disabled states. Set to `(255, 59, 48, 30)` and `(255, 69, 68, 30)`.
    public static let accentRedPressedDisabled: Color = .init(module: "Accent.Red.PressedDisabled")

    /// Green accent color. Set to `(52, 199, 89)` and `(48, 209, 88)` like `UIColor.systemGreen`.
    public static let accentGreen: Color = .init(module: "Accent.Green")

    /// Green accent color for pressed and disabled states. Set to `(52, 199, 89, 30)` and `(48, 209, 88, 30)`.
    public static let accentGreenPressedDisabled: Color = .init(module: "Accent.Green.PressedDisabled")

    /// Blue accent color. Set to `(0, 122, 255)` and `(10, 132, 255)` like `UIColor.systemBlue`.
    public static let accentBlue: Color = .init(module: "Accent.Blue")
    
    /// Blue accent color for pressed and disabled states. Set to `(0, 122, 255, 30)` and `(10, 132, 255, 30)`.
    public static let accentBluePressedDisabled: Color = .init(module: "Accent.Blue.PressedDisabled")
    
    // MARK: Properties - Canvas
    /// Canvas color. Set to `(247, 247, 247)` and `(0, 0, 0)`.
    public static let canvas: Color = .init(module: "Canvas")
    
    // MARK: Properties - Layer
    /// Primary layer color. Set to `(254, 254, 254)` and `(28, 28, 28)`.
    public static var layer: Color { layerPrimary }
    private static let layerPrimary: Color = .init(module: "Layer.Primary")
    
    /// Gray layer color. `(235, 235, 235)` and `(60, 60, 60)`.
    public static let layerGray: Color = .init(module: "Layer.Gray")
    
    /// Gray layer color for pressed state. `(220, 220, 220)` and `(80, 80, 80)`.
    public static let layerGrayPressed: Color = .init(module: "Layer.Gray.Pressed")
    
    /// Gray layer color and disabled state. `(245, 245, 245)` and `(50, 50, 50)`.
    public static let layerGrayDisabled: Color = .init(module: "Layer.Gray.Disabled")
    
    /// Green layer color. `(235, 250, 240)` and `(130, 190, 140)`.
    public static let layerGreen: Color = .init(module: "Layer.Green")
    
    /// Yellow layer color. `(255, 250, 240)` and `(240, 200, 120)`.
    public static let layerYellow: Color = .init(module: "Layer.Yellow")
    
    /// Red layer color. `(250, 240, 240)` and `(230, 125, 125)`.
    public static let layerRed: Color = .init(module: "Layer.Red")
    
    // MARK: Properties - Layer (Control)
    /// Blue control layer. Set to `(24, 126, 240)` and `(25, 131, 255)`.
    public static let controlLayerBlue: Color = .init(module: "LayerControl.Blue")
    
    /// Blue control layer for pressed state. Set to `(31, 104, 182)` and `(36, 106, 186)`.
    public static let controlLayerBluePressed: Color = .init(module: "LayerControl.Blue.Pressed")
    
    /// Blue control layer for disabled state. Set to `(128, 176, 240).
    public static let controlLayerBlueDisabled: Color = .init(module: "LayerControl.Blue.Disabled")
    
    /// Transparent blue control layer. Set to `(24, 126, 240, 25)` and `(25, 131, 255, 25)`.
    public static let controlLayerBlueTransparent: Color = .init(module: "LayerControl.Blue.Transparent")
    
    /// Transparent blue control layer for pressed state. Set to `(31, 104, 182, 25)` and `(36, 106, 186, 25)`.
    public static let controlLayerBlueTransparentPressed: Color = .init(module: "LayerControl.Blue.Transparent.Pressed")
    
    /// Transparent blue control layer for disabled state. Set to `(24, 126, 240, 25, 25)` and `(25, 131, 255, 25, 25)`.
    public static let controlLayerBlueTransparentDisabled: Color = .init(module: "LayerControl.Blue.Transparent.Disabled")
    
    // MARK: Properties - Border
    /// Gray border color. Set to `(200, 200, 200)` and `(100, 100, 100)`.
    public static let borderGray: Color = .init(module: "Border.Gray")
    
    /// Gray border color for pressed state. Set to `(170, 170, 170)` and `(130, 130, 130)`.
    public static let borderGrayPressed: Color = .init(module: "Border.Gray.Pressed")
    
    /// Gray border color for disabled state. Set to `(230, 230, 230)` and `(70, 70, 70)`.
    public static let borderGrayDisabled: Color = .init(module: "Border.Gray.Disabled")
    
    /// Green border color. Set to `(85, 195, 135)` and `(45, 150, 75)`.
    public static let borderGreen: Color = .init(module: "Border.Green")
    
    /// Yellow border color. Set to `(235, 110, 105)` and `(215, 60, 55)`.
    public static let borderYellow: Color = .init(module: "Border.Yellow")
    
    /// Red border color. Set to `(255, 190, 35)` and `(240, 150, 20)`.
    public static let borderRed: Color = .init(module: "Border.Red")
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Color {
    /*fileprivate*/ init(module name: String) {
        self.init(name, bundle: .module)
    }
}
