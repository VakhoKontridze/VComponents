//
//  VChevronButtonModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Model
public struct VChevronButtonModel {
    public let layout: Layout
    public let colors: Colors
    let squareButtonModel: VSquareButtonModel
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.layout = layout
        self.colors = colors
        
        self.squareButtonModel = .init(
            layout: .init(
                dimension: layout.dimension,
                cornerRadius: layout.dimension / 2,
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
                background: .init(
                    enabled: colors.background.enabled,
                    pressed: colors.background.pressed,
                    disabled: colors.background.disabled
                )
            )
        )
    }
}

// MARK:- Layout
extension VChevronButtonModel {
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
extension VChevronButtonModel {
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

extension VChevronButtonModel {
    public struct ForegroundColors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.primary,
            pressed: Color = ColorBook.primary,
            disabled: Color = ColorBook.primary,
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
            enabled: Color = .init(componentAsset: "ChevronButton.Background.enabled"),
            pressed: Color = .init(componentAsset: "ChevronButton.Background.pressed"),
            disabled: Color = .init(componentAsset: "ChevronButton.Background.disabled")
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
}
