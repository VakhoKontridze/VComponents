//
//  VTextFieldHightlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.05.22.
//

import SwiftUI

// MARK: - V TextField Hightlight
extension VTextFieldUIModel {
    /// Model that applies green color scheme.
    public static var success: VTextFieldUIModel {
        var uiModel: VTextFieldUIModel = .init()
        uiModel.colors = .success
        return uiModel
    }

    /// Model that applies yellow color scheme.
    public static var warning: VTextFieldUIModel {
        var uiModel: VTextFieldUIModel = .init()
        uiModel.colors = .warning
        return uiModel
    }

    /// Model that applies error color scheme.
    public static var error: VTextFieldUIModel {
        var uiModel: VTextFieldUIModel = .init()
        uiModel.colors = .error
        return uiModel
    }
}

extension VTextFieldUIModel.Colors {
    /// Model that applies green color scheme.
    public static var success: VTextFieldUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Success.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Success.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Success.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Success.Foreground.enabled")
        )
    }

    /// Model that applies yellow color scheme.
    public static var warning: VTextFieldUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Warning.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Warning.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Warning.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Warning.Foreground.enabled")
        )
    }

    /// Model that applies error color scheme.
    public static var error: VTextFieldUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "TextField.Error.Background.enabled"),
            backgroundFocused: .init(componentAsset: "TextField.Error.Background.enabled"),
            enabled: .init(componentAsset: "TextField.Error.Foreground.enabled"),
            focused: .init(componentAsset: "TextField.Error.Foreground.enabled")
        )
    }
    
    private static func createHighlightedColors(
        backgroundEnabled: Color,
        backgroundFocused: Color,
        enabled: Color,
        focused: Color
    ) -> VTextFieldUIModel.Colors {
        var colors: VTextFieldUIModel.Colors = .init()
        
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
