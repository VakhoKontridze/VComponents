//
//  VPrimaryButtonModelFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//
import SwiftUI

// MARK:- V Primary Model Button Filled
public struct VPrimaryButtonModelFilled {
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
extension VPrimaryButtonModelFilled {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let loaderSpacing: CGFloat
        let loaderWidth: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            height: CGFloat = 50,
            cornerRadius: CGFloat = 20,
            contentMarginX: CGFloat = 15,
            contentMarginY: CGFloat = 3,
            loaderSpacing: CGFloat = 20,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.loaderSpacing = loaderSpacing
            self.loaderWidth = 10
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

// MARK:- Colors
extension VPrimaryButtonModelFilled {
    public struct Colors {
        public let foreground: ForegroundColors
        public let background: Background
        public let loader: LoaderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            background: Background = .init(),
            loader: LoaderColors = .init()
        ) {
            self.foreground = foreground
            self.background = background
            self.loader = loader
        }
    }
}

extension VPrimaryButtonModelFilled.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.PrimaryButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.PrimaryButtonFilled.Foreground.disabled,
            loading: Color = ColorBook.PrimaryButtonFilled.Foreground.loading,
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
    
    public struct Background {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let loading: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonFilled.Background.enabled,
            pressed: Color = ColorBook.PrimaryButtonFilled.Background.pressed,
            disabled: Color = ColorBook.PrimaryButtonFilled.Background.disabled,
            loading: Color = ColorBook.PrimaryButtonFilled.Background.loading
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
            color: Color = ColorBook.PrimaryButtonFilled.loader
        ) {
            self.color = color
        }
    }
}

// MARK:- Fonts
extension VPrimaryButtonModelFilled {
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
extension VPrimaryButtonModelFilled.Colors {
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
}
