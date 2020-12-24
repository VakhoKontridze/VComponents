//
//  VCircularButtonFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button Standard Model
public struct VCircularButtonFilledModel {
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
extension VCircularButtonFilledModel {
    public struct Layout {
        public let frame: Frame
        let cornerRadius: CGFloat
        public let dimension: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxExtendX: CGFloat
        public let hitBoxExtendY: CGFloat
        
        public init(
            frame: Frame = .circular,
            dimension: CGFloat = 56,
            contentMarginX: CGFloat = 3,
            contentMarginY: CGFloat = 3,
            hitBoxExtendX: CGFloat = 0,
            hitBoxExtendY: CGFloat = 0
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
            self.hitBoxExtendX = hitBoxExtendX
            self.hitBoxExtendY = hitBoxExtendY
        }
    }
}

extension VCircularButtonFilledModel.Layout {
    public enum Frame {
        case circular
        case rounded(radius: CGFloat = 16)
    }
}

// MARK:- Colors
extension VCircularButtonFilledModel {
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

extension VCircularButtonFilledModel {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.CircularButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.CircularButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.CircularButtonFilled.Foreground.disabled,
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
            enabled: Color = ColorBook.CircularButtonFilled.Fill.enabled,
            pressed: Color = ColorBook.CircularButtonFilled.Fill.pressed,
            disabled: Color = ColorBook.CircularButtonFilled.Fill.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VCircularButtonFilledModel {
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
extension VCircularButtonFilledModel.Colors {
    func foregroundColor(state: VCircularButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }
    
    func foregroundOpacity(state: VCircularButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }

    func fillColor(state: VCircularButtonInternalState) -> Color {
        switch state {
        case .enabled: return fill.enabled
        case .pressed: return fill.pressed
        case .disabled: return fill.disabled
        }
    }
}
