//
//  VChevronButtonModelPlain.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Model Plain
public struct VChevronButtonModelPlain {
    public let layout: Layout
    public let colors: Colors
    let squareButtonModel: VSquareButtonModelFilled
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.layout = layout
        self.colors = colors
        
        self.squareButtonModel = .init(
            layout: .init(
                frame: .circular,
                dimension: layout.dimension,
                hitBoxSpacingX: layout.hitBoxSpacingX,
                hitBoxSpacingY: layout.hitBoxSpacingY
            ),
            colors: .init(
                foreground: .init(
                    enabled: colors.enabled,
                    pressed: colors.pressed,
                    disabled: colors.disabled,
                    pressedOpacity: colors.pressedOpacity,
                    disabledOpacity: colors.disabledOpacity
                ),
                background: .init(
                    enabled: .clear,
                    pressed: .clear,
                    disabled: .clear
                )
            )
        )
    }
}

// MARK:- Layout
extension VChevronButtonModelPlain {
    public struct Layout {
        public let dimension: CGFloat
        public let iconDimension: CGFloat
        public let hitBoxSpacingX: CGFloat
        public let hitBoxSpacingY: CGFloat
        
        public init(
            dimension: CGFloat = 32,
            iconDimension: CGFloat = 20,
            hitBoxSpacingX: CGFloat = 0,
            hitBoxSpacingY: CGFloat = 0
        ) {
            self.dimension = dimension
            self.iconDimension = iconDimension
            self.hitBoxSpacingX = hitBoxSpacingX
            self.hitBoxSpacingY = hitBoxSpacingY
        }
    }
}

// MARK:- Colors
extension VChevronButtonModelPlain {
    public struct Colors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.ChevronButtonPlain.Foreground.enabled,
            pressed: Color = ColorBook.ChevronButtonPlain.Foreground.pressed,
            disabled: Color = ColorBook.ChevronButtonPlain.Foreground.disabled,
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
