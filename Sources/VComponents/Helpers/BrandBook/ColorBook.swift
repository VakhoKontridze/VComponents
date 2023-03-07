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
    /// Black text color that inverts.
    public static let black: Color = .init(componentAsset: "Black") // 0.0.0
    
    /// White text color.
    public static let white: Color = .init(componentAsset: "White") // 255.255.255

    /// `black` color used for pressed or disabled states.
    public static let blackPressedDisabled: Color = .init(componentAsset: "Black.pressedDisabled") // 0.0.0.30
    
    /// `white` color used for pressed or disabled states.
    public static let whitePressedDisabled: Color = .init(componentAsset: "White.pressedDisabled") // 255.255.255.30
    
    // MARK: Properties - Background
    /// Canvas color that can be used as background.
    public static let canvas: Color = .init(componentAsset: "Canvas") // 247.247.247 & 0.0.0
    
    /// Layer color for container components.
    public static let layer: Color = .init(componentAsset: "Layer") // 254.254.254 & 28.28.28
    
    // MARK: Properties - Accent
    /// Blue accent color.
    public static let accent: Color = .init(componentAsset: "Accent") // 0.122.255 & 10.132.255 (Apple)
    
    /// `accent` color used for pressed or disabled states.
    public static let accentPressedDisabled: Color = .init(componentAsset: "Accent.pressedDisabled") // 0.122.255.30 & 10.132.255.30
    
    // MARK: Properties - Text (Primary)
    /// Primary text color.
    public static let primary: Color = .init(componentAsset: "Primary") // 0.0.0 & 255.255.255
    
    /// Primary text color that inverts color scheme.
    public static let primaryInverted: Color = .init(componentAsset: "PrimaryInverted") // 255.255.255 & 0.0.0
    
    /// Primary black text color that inverts.
    public static var primaryBlack: Color { black }
    
    /// Primary white text color.
    public static var primaryWhite: Color { white }
    
    /// `primary` color used for pressed or disabled states.
    public static let primaryPressedDisabled: Color = .init(componentAsset: "Primary.pressedDisabled") // 0.0.0.30 & 255.255.255.30
    
    /// `primaryInverted` color used for pressed or disabled states.
    public static let primaryInvertedPressedDisabled: Color = .init(componentAsset: "PrimaryInverted.pressedDisabled") // 255.255.255.30 & 0.0.0.30
    
    /// `primaryBlack` color used for pressed or disabled states.
    public static var primaryBlackPressedDisabled: Color { blackPressedDisabled }
    
    /// `primaryBlack` color used for pressed or disabled states.
    public static var primaryWhitePressedDisabled: Color { whitePressedDisabled }
    
    // MARK: Properties - Text (Secondary)
    /// Secondary text color.
    public static let secondary: Color = .init(componentAsset: "Secondary") // 60.60.67.60 & 235.235.245.60 (Apple)
    
    /// `secondary` color used for pressed or disabled states.
    public static let secondaryPressedDisabled: Color = .init(componentAsset: "Secondary.pressedDisabled") // 60.60.67.20 & 235.235.245.20
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Color {
    init(componentAsset name: String) {
        guard
            let uiColor: UIColor = .init(named: name, in: .module, compatibleWith: nil)
        else {
            fatalError()
        }
        
        self.init(uiColor)
    }
}
