//
//  VTextFieldHightlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import SwiftUI

// MARK: - V TextField Hightlight
extension VTextFieldModel {
    /// Model that applies green color scheme.
    public static var success: VTextFieldModel {
        var model: VTextFieldModel = .init()
        model.colors = .success
        return model
    }

    /// Model that applies yellow color scheme.
    public static var warning: VTextFieldModel {
        var model: VTextFieldModel = .init()
        model.colors = .warning
        return model
    }

    /// Model that applies error color scheme.
    public static var error: VTextFieldModel {
        var model: VTextFieldModel = .init()
        model.colors = .error
        return model
    }
}

extension VTextFieldModel.Colors {
    /// Model that applies green color scheme.
    public static let success: VTextFieldModel.Colors = .createHighlightedColors(
        backgroundEnabled: .init(componentAsset: "TextField.Success.Background.enabled"),
        backgroundFocused: .init(componentAsset: "TextField.Success.Background.enabled"),
        enabled: .init(componentAsset: "TextField.Success.Foreground.enabled"),
        focused: .init(componentAsset: "TextField.Success.Foreground.enabled")
    )

    /// Model that applies yellow color scheme.
    public static let warning: VTextFieldModel.Colors = .createHighlightedColors(
        backgroundEnabled: .init(componentAsset: "TextField.Warning.Background.enabled"),
        backgroundFocused: .init(componentAsset: "TextField.Warning.Background.enabled"),
        enabled: .init(componentAsset: "TextField.Warning.Foreground.enabled"),
        focused: .init(componentAsset: "TextField.Warning.Foreground.enabled")
    )

    /// Model that applies error color scheme.
    public static let error: VTextFieldModel.Colors = .createHighlightedColors(
        backgroundEnabled: .init(componentAsset: "TextField.Error.Background.enabled"),
        backgroundFocused: .init(componentAsset: "TextField.Error.Background.enabled"),
        enabled: .init(componentAsset: "TextField.Error.Foreground.enabled"),
        focused: .init(componentAsset: "TextField.Error.Foreground.enabled")
    )
    
    private static func createHighlightedColors(
        backgroundEnabled: Color,
        backgroundFocused: Color,
        enabled: Color,
        focused: Color
    ) -> VTextFieldModel.Colors {
        var colors: VTextFieldModel.Colors = .init()
        
        colors.background.enabled = backgroundEnabled
        colors.background.focused = backgroundFocused
        
        colors.border.enabled = enabled
        colors.border.focused = focused
        
        //colors.text
        
        colors.header.enabled = enabled
        colors.header.focused = focused
        
        colors.footer.enabled = enabled
        colors.footer.focused = focused
        
        //colors.searchIcon
        
        //colors.visibilityButtonIcon
        
        //colors.clearButtonBackground
        //colors.clearButtonIcon
        
        return colors
    }
}
