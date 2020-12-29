//
//  VPlainButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Model Button
public struct VPlainButtonModel {
    public let layout: Layout
    public let colors: Colors
    public let font: Font
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init(),
        font: Font = .system(size: 14, weight: .semibold, design: .default)
    ) {
        self.layout = layout
        self.colors = colors
        self.font = font
    }
}

// MARK:- Layout
extension VPlainButtonModel {
    public struct Layout {
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            hitBoxSpacingX: CGFloat = 15,
            hitBoxSpacingY: CGFloat = 5
        ) {
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

// MARK:- Colors
extension VPlainButtonModel {
    public struct Colors {
        public let foreground: ForegroundColors
        
        public init(
            foreground: ForegroundColors = .init()
        ) {
            self.foreground = foreground
        }
    }
}

extension VPlainButtonModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.accent,
            pressed: Color = ColorBook.accent,
            disabled: Color = ColorBook.accent,
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
}

// MARK:- Mapping
extension VPlainButtonModel.Colors {
    func foregroundColor(state: VPlainButtonInternalState) -> Color {
        switch state {
        case .enabled: return foreground.enabled
        case .pressed: return foreground.pressed
        case .disabled: return foreground.disabled
        }
    }
    
    func foregroundOpacity(state: VPlainButtonInternalState) -> Double {
        switch state {
        case .enabled: return 1
        case .pressed: return foreground.pressedOpacity
        case .disabled: return foreground.disabledOpacity
        }
    }
}
