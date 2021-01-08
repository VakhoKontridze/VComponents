//
//  VSquareButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Square Button Model
public struct VSquareButtonModel {
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
extension VSquareButtonModel {
    public struct Layout {
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        
        public let borderWidth: CGFloat
        let hasBorder: Bool
        
        public let contentMarginX: CGFloat
        public let contentMarginY: CGFloat
        
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            dimension: CGFloat = 56,
            cornerRadius: CGFloat = 16,
            borderWidth: CGFloat = 1,
            contentMarginX: CGFloat = 3,
            contentMarginY: CGFloat = 3,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.hasBorder = borderWidth > 0
            self.contentMarginX = contentMarginX
            self.contentMarginY = contentMarginY
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

// MARK:- Colors
extension VSquareButtonModel {
    public struct Colors {
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
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

extension VSquareButtonModel.Colors {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = primaryButtonColors.text.enabled,
            pressed: Color = primaryButtonColors.text.pressed,
            disabled: Color = primaryButtonColors.text.disabled,
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
            enabled: Color = primaryButtonColors.background.enabled,
            pressed: Color = primaryButtonColors.background.pressed,
            disabled: Color = primaryButtonColors.background.disabled
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
            enabled: Color = primaryButtonColors.border.enabled,
            pressed: Color = primaryButtonColors.border.pressed,
            disabled: Color = primaryButtonColors.border.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSquareButtonModel.Colors {
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
