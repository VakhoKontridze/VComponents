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
    public static let black: Color = .init(componentAsset: "Black")
    
    /// White text color.
    public static let white: Color = .init(componentAsset: "White")

    /// `black` color used for pressed or disabled states.
    public static let blackPressedDisabled: Color = .init(componentAsset: "Black.presseddisabled")
    
    /// `white` color used for pressed or disabled states.
    public static let whitePressedDisabled: Color = .init(componentAsset: "White.presseddisabled")
    
    // MARK: Properties - Background
    /// Canvas color that can be used as background.
    public static let canvas: Color = .init(componentAsset: "Canvas")
    
    /// Layer color for container components.
    public static let layer: Color = .init(componentAsset: "Layer")
    
    // MARK: Properties - Accent
    /// Blue accent color.
    public static let accent: Color = .init(componentAsset: "Accent")
    
    /// `accent` color used for pressed or disabled states.
    public static let accentPressedDisabled: Color = .init(componentAsset: "Accent.presseddisabled")
    
    // MARK: Properties - Text (Primary)
    /// Primary text color.
    public static let primary: Color = .init(componentAsset: "Primary")
    
    /// Primary text color that inverts color scheme.
    public static let primaryInverted: Color = .init(componentAsset: "PrimaryInverted")
    
    /// Primary black text color that inverts.
    public static var primaryBlack: Color { black }
    
    /// Primary white text color.
    public static var primaryWhite: Color { white }
    
    /// `primary` color used for pressed or disabled states.
    public static let primaryPressedDisabled: Color = .init(componentAsset: "Primary.presseddisabled")
    
    /// `primaryInverted` color used for pressed or disabled states.
    public static let primaryInvertedPressedDisabled: Color = .init(componentAsset: "PrimaryInverted.presseddisabled")
    
    /// `primaryBlack` color used for pressed or disabled states.
    public static var primaryBlackPressedDisabled: Color { blackPressedDisabled }
    
    /// `primaryBlack` color used for pressed or disabled states.
    public static var primaryWhitePressedDisabled: Color { whitePressedDisabled }
    
    // MARK: Properties - Text (Secondary)
    /// Secondary text color.
    public static let secondary: Color = .init(componentAsset: "Secondary")
    
    /// `secondary` color used for pressed or disabled states.
    public static let secondaryPressedDisabled: Color = .init(componentAsset: "Secondary.presseddisabled")
    
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

// MARK: - Assets
/*
 
 Accent
 0.122.255 // Apple
 10.132.255 // Apple
 
 Canvas
 247.247.247
 0.0.0
 
 Layer
 254.254.254
 20.20.20
 
 Primary
 0.0.0
 255.255.255
 
 PrimaryBlack
 0.0.0
 0.0.0
 
 PrimaryInverted
 255.255.255
 0.0.0
 
 PrimaryWhite
 255.255.255
 255.255.255
 
 Secondary
 60.60.67 @ 60 // Apple
 235.235.245 @ 60 // Apple
 
*/

/*

 Alert.DestructiveButton.Background.disabled
 255.140.140
 
 Alert.DestructiveButton.Background.enabled
 255.59.48 // Apple
 255.69.68 // Apple
 
 Alert.SecondaryButton.Background.pressed
 235.235.235
 70.70.70
 
 BottomSheet.Grabber
 230.230.230
 100.100.100
 
 CheckBox.Border.disabled
 230.230.230
 40.40.40
 
 CheckBox.Border.off
 200.200.200
 80.80.80
 
 CheckBox.Border.pressedOff
 180.180.180
 60.60.60
 
 DisclosureGroup.ChevronButton.Background.disabled
 250.250.250
 80.80.80
 
 DisclosureGroup.ChevronButton.Background.enabled
 235.235.235
 55.55.55
 
 DisclosureGroup.ChevronButton.Background.pressed
 210.210.210
 45.45.45
 
 List.Separator
 60.60.60 @ 30
 85.85.85 @ 60
 
 Modal.DimmingView
 100.100.100 @ 30
 0.0.0 @ 60
 
 Modal.CloseButton.Icon.enabled
 100.100.100
 160.160.160
 
 PageIndicator.Dot
 190.190.190
 120.120.120
 
 PrimaryButton.Background.disabled
 128.176.240
 
 PrimaryButton.Background.enabled
 24.126.240
 25.131.255
 
 PrimaryButton.Background.pressed
 31.104.182
 36.106.186
 
 SegmentedPicker.Background.enabled
 240.240.240
 40.40.40
 
 SegmentedPicker.Divider.disabled
 230.230.230
 50.50.50
 
 SegmentedPicker.Divider.enabled
 215.215.215
 70.70.70
 
 SegmentedPicker.Indicator.disabled
 254.254.254
 60.60.60
 
 SegmentedPicker.Indicator.enabled
 254.254.254
 90.90.90
 
 Slider.Thumb.Border.disabled
 192.192.192
 
 Slider.Thumb.Border.enabled
 96.96.96
 
 Slider.Thumb.Shadow.disabled
 96.96.96 @ 20
 
 Slider.Thumb.Shadow.enabled
 96.96.96 @ 50
 
 Stepper.Button.Background.pressed
 200.200.200
 70.70.70
 
 TextField.Background.focused
 225.225.225
 50.50.50
 
 TextField.ClearButton.Background.disabled
 220.220.220
 40.40.40
 
 TextField.ClearButton.Background.enabled
 170.170.170
 30.30.30
 
 TextField.ClearButton.Background.pressed
 150.150.150
 20.20.20
 
 TextField.ClearButton.Icon
 255.255.255
 230.230.230
 
 TextField.Error.Background.enabled
 250.240.240
 229.125.125
 
 TextField.Error.Foreground.enabled
 235.110.105
 
 TextField.PlainButton.enabled
 70.70.70
 240.240.240
 
 TextField.Success.Background.enabled
 235.250.240
 130.180.140
 
 TextField.Success.Foreground.enabled
 85.195.135
 
 TextField.Warning.Background.enabled
 255.250.240
 245.150.90
 
 TextField.Warning.Foreground.enabled
 255.190.35
 
 Toggle.Fill.disabled
 244.244.244
 40.40.40
 
 Toggle.Fill.off
 233.233.233
 55.55.55
 
 Toggle.Fill.pressedOff
 220.220.220
 70.70.70
 
 Toggle.Thumb
 254.254.254
 
*/
