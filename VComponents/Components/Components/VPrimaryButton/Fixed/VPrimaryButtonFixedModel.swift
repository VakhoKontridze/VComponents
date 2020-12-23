//
//  VPrimaryButtonFixedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Fixed Model
public struct VPrimaryButtonFixedModel {
    public let layout: Layout
    public let colors: Colors
    public let fonts: Fonts
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
    }
}

// MARK:- Layout
extension VPrimaryButtonFixedModel {
    public struct Layout {
        public let size: CGSize
        public let cornerRadius: CGFloat
        public let borderWidth: CGFloat
        public let contentInset: CGFloat
        let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        
        public init(
            size: CGSize = .init(width: 300, height: 50),
            cornerRadius: CGFloat = 20,
            borderWidth: CGFloat = 0,
            contentInset: CGFloat = 15
        ) {
            self.size = size
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.contentInset = contentInset
            self.loaderSpacing = 20
            self.loaderWidth = 10
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonFixedModel {
    public struct Colors {
        public let foreground: ForegroundColors
        public let fill: FillColors
        public let border: BorderColors
        public let loader: LoaderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            fill: FillColors = .init(),
            border: BorderColors = .init(),
            loader: LoaderColors = .init()
        ) {
            self.foreground = foreground
            self.fill = fill
            self.border = border
            self.loader = loader
        }
    }
}

extension VPrimaryButtonFixedModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.PrimaryButton.Text.enabled,
            pressed: Color = ColorBook.PrimaryButton.Text.pressed,
            disabled: Color = ColorBook.PrimaryButton.Text.disabled,
            loading: Color = ColorBook.PrimaryButton.Text.loading,
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
    
    public struct FillColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButton.Fill.enabled,
            pressed: Color = ColorBook.PrimaryButton.Fill.pressed,
            disabled: Color = ColorBook.PrimaryButton.Fill.disabled,
            loading: Color = ColorBook.PrimaryButton.Fill.loading
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
            enabled: Color = ColorBook.PrimaryButton.Border.enabled,
            pressed: Color = ColorBook.PrimaryButton.Border.pressed,
            disabled: Color = ColorBook.PrimaryButton.Border.disabled,
            loading: Color = ColorBook.PrimaryButton.Border.loading
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
        }
    }
    
    public struct LoaderColors {
        public let color: Color
        
        public init(
            color: Color = ColorBook.PrimaryButton.Text.enabled
        ) {
            self.color = color
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonFixedModel {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.buttonLarge
        ) {
            self.title = title
        }
    }
}

// MARK:- Mapping
extension VPrimaryButtonFixedModel.Colors {
    func foregroundColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        case .loading: return foreground.loading
        }
    }

    func fillColor(state: VPrimaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        case .loading: return fill.loading
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
    
    func foregroundOpacity(state: VPrimaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        case .loading: return foreground.disabledOpacity
        }
    }
}
