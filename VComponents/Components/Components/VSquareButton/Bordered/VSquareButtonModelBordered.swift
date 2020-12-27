//
//  VSquareButtonModelBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Square Button Model Bordered
public struct VSquareButtonModelBordered {
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
extension VSquareButtonModelBordered {
    public struct Layout {
        public let frame: Frame
        let cornerRadius: CGFloat
        public let dimension: CGFloat
        public let borderType: BorderType
        public let borderWidth: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            frame: Frame = .circular,
            dimension: CGFloat = 56,
            borderType: BorderType = .continous,
            borderWidth: CGFloat = 1,
            contentMarginX: CGFloat = 3,
            contentMarginY: CGFloat = 3,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.frame = frame
            self.cornerRadius = {
                switch frame {
                case .circular: return dimension / 2
                case .rounded(let radius): return radius
                }
            }()
            self.dimension = dimension
            self.borderType = borderType
            self.borderWidth = borderWidth
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

extension VSquareButtonModelBordered.Layout {
    public enum Frame {
        case circular
        case rounded(radius: CGFloat = 16)
    }
    
    public enum BorderType {
        case continous
        case dashed(spacing: CGFloat = 3)
    }
}

// MARK:- Colors
extension VSquareButtonModelBordered {
    public struct Colors {
        public let foreground: ForegroundColors
        public let background: BackgroundColors
        public let border: BorderColors
        
        public init(
            foreground: ForegroundColors = .init(),
            background: BackgroundColors = .init(),
            border: BorderColors = .init()
        ) {
            self.foreground = foreground
            self.background = background
            self.border = border
        }
    }
}

extension VSquareButtonModelBordered {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.SquareButtonBordered.Foreground.enabled,
            pressed: Color = ColorBook.SquareButtonBordered.Foreground.pressed,
            disabled: Color = ColorBook.SquareButtonBordered.Foreground.disabled,
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
            enabled: Color = ColorBook.SquareButtonBordered.Background.enabled,
            pressed: Color = ColorBook.SquareButtonBordered.Background.pressed,
            disabled: Color = ColorBook.SquareButtonBordered.Background.disabled
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
            enabled: Color = ColorBook.SquareButtonBordered.Border.enabled,
            pressed: Color = ColorBook.SquareButtonBordered.Border.pressed,
            disabled: Color = ColorBook.SquareButtonBordered.Border.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VSquareButtonModelBordered {
    public struct Fonts {
        public let title: Font
        
        public init(
            title: Font = FontBook.buttonSmall
        ) {
            self.title = title
        }
    }
}

// MARK:- Mapping
extension VSquareButtonModelBordered.Colors {
    func foregroundColor(state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }
    
    func foregroundOpacity(state: VSquareButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }

    func backgroundColor(state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return background.enabled
        case .pressed: return background.pressed
        case .disabled: return background.disabled
        }
    }
    
    func borderColor(state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        }
    }
}
