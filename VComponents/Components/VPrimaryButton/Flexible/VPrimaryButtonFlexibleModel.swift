//
//  VPrimaryButtonFlexibleModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Flexible Model
public struct VPrimaryButtonFlexibleModel {
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
public extension VPrimaryButtonFlexibleModel {
    struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let borderWidth: CGFloat
        public let contentInset: CGFloat
        let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            borderWidth: CGFloat = 0,
            contentInset: CGFloat = 15
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.contentInset = contentInset
            self.loaderSpacing = 20
            self.loaderWidth = 10
        }
    }
}

// MARK:- Colors
public extension VPrimaryButtonFlexibleModel {
    struct Colors {
        public let foreground: ForegroundColors
        public let fill: FillColors
        public let border: BorderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            fill: FillColors = .init(),
            border: BorderColors = .init()
        ) {
            self.foreground = foreground
            self.fill = fill
            self.border = border
        }
    }
}

extension VPrimaryButtonFlexibleModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        
        public init(
            enabled: Color = ColorBook.PrimaryButton.Text.enabled,
            pressed: Color = ColorBook.PrimaryButton.Text.pressed,
            disabled: Color = ColorBook.PrimaryButton.Text.disabled,
            loading: Color = ColorBook.PrimaryButton.Text.loading,
            
            pressedOpacity: Double = 0.5
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.loading = loading
            self.pressedOpacity = pressedOpacity
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
}

// MARK:- Fonts
public extension VPrimaryButtonFlexibleModel {
    struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.buttonLarge
        ) {
            self.title = title
        }
    }
}

// MARK:- Mapping
extension VPrimaryButtonFlexibleModel.Colors {
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
        case .disabled: return 1
        case .loading: return 1
        }
    }
}
