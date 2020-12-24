//
//  VSquareButtonFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Square Button Standard Model
public struct VSquareButtonFilledModel {
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
extension VSquareButtonFilledModel {
    public struct Layout {
        public let frame: Frame
        let cornerRadius: CGFloat
        public let dimension: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            frame: Frame = .circular,
            dimension: CGFloat = 56,
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
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

extension VSquareButtonFilledModel.Layout {
    public enum Frame {
        case circular
        case rounded(radius: CGFloat = 16)
    }
}

// MARK:- Colors
extension VSquareButtonFilledModel {
    public struct Colors {
        public let foreground: ForegroundColors
        public let fill: FillColors
        
        public init(
            foreground: ForegroundColors = .init(),
            fill: FillColors = .init()
        ) {
            self.foreground = foreground
            self.fill = fill
        }
    }
}

extension VSquareButtonFilledModel {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.SquareButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.SquareButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.SquareButtonFilled.Foreground.disabled,
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
            enabled: Color = ColorBook.SquareButtonFilled.Fill.enabled,
            pressed: Color = ColorBook.SquareButtonFilled.Fill.pressed,
            disabled: Color = ColorBook.SquareButtonFilled.Fill.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VSquareButtonFilledModel {
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
extension VSquareButtonFilledModel.Colors {
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

    func fillColor(state: VSquareButtonInternalState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        }
    }
}
