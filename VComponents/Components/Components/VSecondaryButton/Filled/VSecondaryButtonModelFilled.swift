//
//  VSecondaryButtonModelFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button Model Filled
public struct VSecondaryButtonModelFilled {
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
extension VSecondaryButtonModelFilled {
    public struct Layout {
        public let height: CGFloat
        let cornerRadius: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            height: CGFloat = 32,
            contentMarginX: CGFloat = 10,
            contentMarginY: CGFloat = 3,
            hitBoxSpacingX: CGFloat = 10,
            hitBoxSpacingY: CGFloat = 10
        ) {
            self.height = height
            self.cornerRadius = height / 2
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

// MARK:- Colors
extension VSecondaryButtonModelFilled {
    public struct Colors {
        public let foreground: ForegroundColors
        public let background: BackgroundColors
        
        public init(
            foreground: ForegroundColors = .init(),
            background: BackgroundColors = .init()
        ) {
            self.foreground = foreground
            self.background = background
        }
    }
}

extension VSecondaryButtonModelFilled.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.SecondaryButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.SecondaryButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.SecondaryButtonFilled.Foreground.disabled,
            pressedOpacity: Double = 0.5,
            disabledOpacity: Double = 0.5
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
    }
    
    public struct BackgroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.SecondaryButtonFilled.Background.enabled,
            pressed: Color = ColorBook.SecondaryButtonFilled.Background.pressed,
            disabled: Color = ColorBook.SecondaryButtonFilled.Background.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VSecondaryButtonModelFilled {
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
extension VSecondaryButtonModelFilled.Colors {
    func foregroundColor(state: VSecondaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }
    
    func foregroundOpacity(state: VSecondaryButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }

    func backgroundColor(state: VSecondaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return background.enabled
        case .pressed: return background.pressed
        case .disabled: return background.disabled
        }
    }
}
