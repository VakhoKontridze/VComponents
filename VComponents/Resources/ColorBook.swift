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
    // MARK: Properties
    /// Canvas color that can be used for `VBaseView`.
    public static let canvas: Color = .init(componentAsset: "Canvas")
    
    /// Layer color for container components.
    public static let layer: Color = .init(componentAsset: "Layer")
    
    /// Primary text color.
    public static let primary: Color = .init(componentAsset: "Primary")
    
    /// Primary text color that inverts color scheme.
    public static let primaryInverted: Color = .init(componentAsset: "PrimaryInverted")
    
    /// Secondary text color.
    public static let secondary: Color = .init(componentAsset: "Secondary")
    
    /// Blue accent color.
    public static let accent: Color = .init(componentAsset: "Accent")
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Color {
    /// Initializes color from library's local assets library from a name.
    public init(componentAsset name: String) {
        guard
            let bundle: Bundle = .init(identifier: "com.vakhtang-kontridze.vcomponents"),
            let uiColor: UIColor = .init(named: name, in: bundle, compatibleWith: nil)
        else {
            fatalError()
        }
        
        self.init(uiColor)
    }
}

// MARK: - Assets

/*
 
 Accordion.Divider
 @140.140.140 @ 50
 
 BaseList.Divider
 *120.120.120 @ 15
 @160.160.160 @ 15

 CheckBox.Border.disabled
 *230.230.230
 *40.40.40
 
 CheckBox.Border.off
 *200.200.200
 *60.60.60
 
 ChevronButton.Background.disabled
 250.250.250
 80.80.80
 
 ChevronButton.Background.enabled
 235.235.235
 *40.40.40
 
 ChevronButton.Background.pressed
 225.225.225
 *30.30.30
 
 HalfModal.Grabber
 *220.220.220
 45.45.45
 
 Modal.Blinding
 *100.100.100 @ 30
 35.35.35 @ 30
 
 PrimaryButton.Background.enabled
 128.176.240
 
 PrimaryButton.Background.disabled
 24.126.240
 25.131.255
 
 PrimaryButton.Background.pressed
 31.104.182
 36.106.186
 
 SegmentedPicker.Background.enabled
 240.240.240
 *40.40.40
 
 SegmentedPicker.Divider.disabled
 *230.230.230
 *50.50.50
 
 SegmentedPicker.Divider.enabled
 *215.215.215
 *70.70.70
 
 SegmentedPicker.Header
 *60.60.60
 210.210.210
 
 SegmentedPicker.Indicator.disabled
 *254.254.254
 *60.60.60
 
 SegmentedPicker.Indicator.enabled
 *254.254.254
 90.90.90
 
 Slider.Thumb.Border.disabled
 192.192.192
 
 Slider.Thumb.Border.enabled
 *96.96.96
 
 Slider.Thumb.Shadow.disabled
 *96.96.96 @ 20
 
 Slider.Thumb.Shadow.enabled
 *96.96.96 @ 50
 
 VStepper.Button.Background.pressed
 *200.200.200
 *70.70.70
 
 TabNavigationView.Item
 190.190.190
 *100.100.100
 
 NavigationView.Divider
 0.0.0 @ 30
 1.1.1 @ 15

 TextField.Background.error
 250.205.210
 230.60.30
 
 TextField.Background.focused
 215.215.215
 *50.50.50
 
 TextField.Background.success
 205.250.210
 25.175.90
 
 TextField.Border.error
 200.35.30
 
 TextField.Border.success
 5.145.65
 
 TextField.ClearButton.Background.disabled
 *220.220.220
 *40.40.40
 
 TextField.ClearButton.Background.enabled
 170.170.170
 *30.30.30
 
 TextField.ClearButton.Background.pressed
 150.150.150
 *20.20.20
 
 TextField.ClearButton.Icon
 *254.254.254
 
 Toggle.Fill.disabled
 244.244.244
 *30.30.30
 
 Toggle.Fill.off
 233.233.233
 *40.40.40
 
 Toggle.Thumb
 *254.254.254
 
 Accent
 0.122.255
 10.132.255
 
 Canvas
 247.247.247
 22.22.22
 
 Layer
 *254.254.254
 18.18.18
 
 Primary
 *20.20.20
 *254.254.254
 
 PrimaryInverted
 *254.254.254
 *20.20.20
 
 Secondary
 *120.120.120
 140.140.140
 
*/
