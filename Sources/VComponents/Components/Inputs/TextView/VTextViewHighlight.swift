//
//  VTextViewHighlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.10.22.
//

import SwiftUI

// MARK: - V Text View Highlight
extension VTextViewUIModel {
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

extension VTextViewUIModel.Colors {
    /// Model that applies green color scheme.
    public static var success: VTextViewUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "color_235.250.240_130.180.140"),
            backgroundFocused: .init(componentAsset: "color_235.250.240_130.180.140"),
            enabled: .init(componentAsset: "color_85.195.135"),
            focused: .init(componentAsset: "color_85.195.135")
        )
    }

    /// Model that applies yellow color scheme.
    public static var warning: VTextViewUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "color_255.250.240_240.200.100"),
            backgroundFocused: .init(componentAsset: "color_255.250.240_240.200.100"),
            enabled: .init(componentAsset: "color_255.190.35"),
            focused: .init(componentAsset: "color_255.190.35")
        )
    }

    /// Model that applies error color scheme.
    public static var error: VTextViewUIModel.Colors {
        .createHighlightedColors(
            backgroundEnabled: .init(componentAsset: "color_250.240.240_220.125.125"),
            backgroundFocused: .init(componentAsset: "color_250.240.240_220.125.125"),
            enabled: .init(componentAsset: "color_235.110.105"),
            focused: .init(componentAsset: "color_235.110.105")
        )
    }
    
    private static func createHighlightedColors(
        backgroundEnabled: Color,
        backgroundFocused: Color,
        enabled: Color,
        focused: Color
    ) -> VTextViewUIModel.Colors {
        var colors: VTextViewUIModel.Colors = .init()
        
        colors.background.enabled = backgroundEnabled
        colors.background.focused = backgroundFocused
        
        colors.border.enabled = enabled
        colors.border.focused = focused
        
        //colors.text
        
        colors.header.enabled = enabled
        colors.header.focused = focused
        
        colors.footer.enabled = enabled
        colors.footer.focused = focused
        
        //colors.clearButtonBackground
        //colors.clearButtonIcon
        
        return colors
    }
}
