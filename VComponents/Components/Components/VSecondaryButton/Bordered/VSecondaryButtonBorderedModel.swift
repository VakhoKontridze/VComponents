//
//  VSecondaryButtonBorderedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button Bordered Model
public struct VSecondaryButtonBorderedModel {
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
extension VSecondaryButtonBorderedModel {
    public struct Layout {
        public let height: CGFloat
        let cornerRadius: CGFloat
        public let borderType: BorderType
        public let borderWidth: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            height: CGFloat = 32,
            borderType: BorderType = .continous,
            borderWidth: CGFloat = 1,
            contentMarginX: CGFloat = 10,
            contentMarginY: CGFloat = 3,
            hitBoxSpacingX: CGFloat = 10,
            hitBoxSpacingY: CGFloat = 10
        ) {
            self.height = height
            self.cornerRadius = height / 2
            self.borderType = borderType
            self.borderWidth = borderWidth
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

extension VSecondaryButtonBorderedModel.Layout {
    public enum BorderType {
        case continous
        case dashed(spacing: CGFloat = 3)
    }
}

// MARK:- Colors
extension VSecondaryButtonBorderedModel {
    public struct Colors {
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

extension VSecondaryButtonBorderedModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.SecondaryButtonBordered.Foreground.enabled,
            pressed: Color = ColorBook.SecondaryButtonBordered.Foreground.pressed,
            disabled: Color = ColorBook.SecondaryButtonBordered.Foreground.disabled,
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
    
    public struct FillColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.SecondaryButtonBordered.Fill.enabled,
            pressed: Color = ColorBook.SecondaryButtonBordered.Fill.pressed,
            disabled: Color = ColorBook.SecondaryButtonBordered.Fill.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
    
    public struct BorderColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.PrimaryButtonBordered.Border.enabled,
            pressed: Color = ColorBook.PrimaryButtonBordered.Border.pressed,
            disabled: Color = ColorBook.PrimaryButtonBordered.Border.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VSecondaryButtonBorderedModel {
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
extension VSecondaryButtonBorderedModel.Colors {
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

    func fillColor(state: VSecondaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        }
    }
    
    func borderColor(state: VSecondaryButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        }
    }
}
