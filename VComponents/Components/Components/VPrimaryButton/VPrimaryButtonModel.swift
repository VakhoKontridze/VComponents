//
//  VPrimaryButtonModelBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Primary Button Model
public struct VPrimaryButtonModel {
    public let layout: Layout
    public let colors: Colors
    public let fonts: Fonts
    
    let spinnerModel: VSpinnerModelContinous
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
        self.spinnerModel = .init(
            colors: .init(spinner: colors.loader)
        )
    }
}

// MARK:- Layout
extension VPrimaryButtonModel {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        public let borderWidth: CGFloat
        let hasBorder: Bool
        
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        
        public let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            borderWidth: CGFloat = 1,
            contentMarginX: CGFloat = 15,
            contentMarginY: CGFloat = 3,
            loaderSpacing: CGFloat = 20,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.hasBorder = borderWidth > 0
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.loaderSpacing = loaderSpacing
            self.loaderWidth = 10
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonModel {
    public struct Colors {
        public let foreground: ForegroundColors
        public let background: BackgroundColors
        public let border: BorderColors
        public let loader: Color
        
        public init(
            foreground: ForegroundColors = .init(),
            background: BackgroundColors = .init(),
            border: BorderColors = .init(),
            loader: Color = ColorBook.primaryInverted
        ) {
            self.foreground = foreground
            self.background = background
            self.border = border
            self.loader = loader
        }
    }
}

extension VPrimaryButtonModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.primaryInverted,
            pressed: Color = ColorBook.primaryInverted,
            disabled: Color = ColorBook.primaryInverted,
            loading: Color = ColorBook.primaryInverted,
            pressedOpacity: Double = 0.5,
            disabledOpacity: Double = 0.5
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
    }
    
    public struct BackgroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = .init(componentAsset: "PrimaryButton.Background.enabled"),
            pressed: Color = .init(componentAsset: "PrimaryButton.Background.pressed"),
            disabled: Color = .init(componentAsset: "PrimaryButton.Background.disabled"),
            loading: Color = .init(componentAsset: "PrimaryButton.Background.disabled")
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
    }
    
    public struct BorderColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = .clear,
            pressed: Color = .clear,
            disabled: Color = .clear,
            loading: Color = .clear
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = .system(size: 16, weight: .semibold, design: .default)
        ) {
            self.title = title
        }
    }
}

// MARK:- Mapping
extension VPrimaryButtonModel.Colors {
    func foregroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        case .loading: return foreground.loading
        }
    }
    
    func foregroundOpacity(state: VPrimaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        case .loading: return foreground.disabledOpacity
        }
    }

    func backgroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return background.enabled
        case .pressed: return background.pressed
        case .disabled: return background.disabled
        case .loading: return background.loading
        }
    }
    
    func borderColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        case .loading: return border.loading
        }
    }
}
