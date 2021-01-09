//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Color Book
public struct ColorBook {
    private init() {}
}

// MARK:- Colors
extension ColorBook {
    public static let canvas: Color = .init(componentAsset: "Canvas")
    public static let layer: Color = .init(componentAsset: "Layer")
    
    public static let primary: Color = .init(componentAsset: "Primary")
    public static let primaryInverted: Color = .init(componentAsset: "PrimaryInverted")
    
    public static let secondary: Color = .init(componentAsset: "Secondary")
    
    public static let accent: Color = .init(componentAsset: "Accent")
}

// MARK:- Helper
public extension Color {
    init(componentAsset name: String) {
        guard
            let bundle = Bundle(identifier: "com.vakhtang-kontridze.VComponents"),
            let uiColor = UIColor(named: name, in: bundle, compatibleWith: nil)
        else {
            preconditionFailure()
        }
        
        self.init(uiColor)
    }
}

// MARK:- Assets

/*
 
 ChevronButton.Background.disabled
 245.245.245
 80.80.80
 
 ChevronButton.Background.enabled
 235.235.235
 *40.40.40
 
 ChevronButton.Background.pressed
 *210.210.210
 *30.30.30
 
 PrimaryButton.Background.enabled
 128.176.240
 
 PrimaryButton.Background.disabled
 24.126.240
 25.131.255
 
 PrimaryButton.Background.pressed
 31.104.182
 36.106.186
 
 SegmentedPicker.Indicator.disabled
 *254.254.254
 *60.60.60
 
 SegmentedPicker.Indicator.enabled
 *254.254.254
 90.90.90
 
 SegmentedPicker.Title
 *60.60.60
 *210.210.210
 
 SideBar.Blinding
 *100.100.100 @ 30
 
 Slider.Thumb.Border.disabled
 192.192.192
 
 Slider.Thumb.Border.enabled
 *96.96.96
 
 Slider.Thumb.Shadow.disabled
 *96.96.96 @ 20
 
 Slider.Thumb.Shadow.enabled
 *96.96.96 @ 50
 
 TabNavigationView.Item
 190.190.190
 *100.100.100
 
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
 120.120.120
 140.140.140
 
*/
