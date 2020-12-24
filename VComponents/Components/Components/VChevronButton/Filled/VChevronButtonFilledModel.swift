//
//  VChevronButtonFilledModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Filled Model
public struct VChevronButtonFilledModel {
    public let layout: Layout
    public let colors: Colors
    let squareButtonModel: VSquareButtonFilledModel
    
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
                    enabled: colors.foreground.enabled,
                    pressed: colors.foreground.pressed,
                    disabled: colors.foreground.disabled,
                    pressedOpacity: colors.foreground.pressedOpacity,
                    disabledOpacity: colors.foreground.disabledOpacity
                ),
                fill: .init(
                    enabled: colors.fill.enabled,
                    pressed: colors.fill.pressed,
                    disabled: colors.fill.disabled
                )
            )
        )
    }
}

// MARK:- Layout
extension VChevronButtonFilledModel {
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
extension VChevronButtonFilledModel {
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

extension VChevronButtonFilledModel {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.ChevronButtonFilled.Foreground.enabled,
            pressed: Color = ColorBook.ChevronButtonFilled.Foreground.pressed,
            disabled: Color = ColorBook.ChevronButtonFilled.Foreground.disabled,
            pressedOpacity: Double = 1,
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
            enabled: Color = ColorBook.ChevronButtonFilled.Fill.enabled,
            pressed: Color = ColorBook.ChevronButtonFilled.Fill.pressed,
            disabled: Color = ColorBook.ChevronButtonFilled.Fill.disabled
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}
