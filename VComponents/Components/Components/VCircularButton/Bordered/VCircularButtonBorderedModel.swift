//
//  VCircularButtonBorderedModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button Standard Model
public struct VCircularButtonBorderedModel {
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
extension VCircularButtonBorderedModel {
    public struct Layout {
        public let frame: Frame
        let cornerRadius: CGFloat
        public let dimension: CGFloat
        public let borderType: BorderType
        public let borderWidth: CGFloat
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        public let hitBoxExtendX: CGFloat
        public let hitBoxExtendY: CGFloat
        
        public init(
            frame: Frame = .circular,
            dimension: CGFloat = 56,
            borderType: BorderType = .continous,
            borderWidth: CGFloat = 1,
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
            self.borderType = borderType
            self.borderWidth = borderWidth
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxExtendX = hitBoxExtendX
            self.hitBoxExtendY = hitBoxExtendY
        }
    }
}

extension VCircularButtonBorderedModel.Layout {
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
extension VCircularButtonBorderedModel {
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

extension VCircularButtonBorderedModel {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.CircularButtonBordered.Foreground.enabled,
            pressed: Color = ColorBook.CircularButtonBordered.Foreground.pressed,
            disabled: Color = ColorBook.CircularButtonBordered.Foreground.disabled,
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
            enabled: Color = ColorBook.CircularButtonBordered.Fill.enabled,
            pressed: Color = ColorBook.CircularButtonBordered.Fill.pressed,
            disabled: Color = ColorBook.CircularButtonBordered.Fill.disabled
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
            enabled: Color = ColorBook.CircularButtonBordered.Border.enabled,
            pressed: Color = ColorBook.CircularButtonBordered.Border.pressed,
            disabled: Color = ColorBook.CircularButtonBordered.Border.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Fonts
extension VCircularButtonBorderedModel {
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
extension VCircularButtonBorderedModel.Colors {
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
    
    func borderColor(state: VCircularButtonInternalState) -> Color {
        switch state {
        case .enabled: return border.enabled
        case .pressed: return border.pressed
        case .disabled: return border.disabled
        }
    }
}
