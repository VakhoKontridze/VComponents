//
//  VChevronButtonPlainModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Plain Model
public struct VChevronButtonPlainModel {
    public let layout: Layout
    public let colors: Colors
    let circularButtonModel: VCircularButtonFilledModel
    
    public init(
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.layout = layout
        self.colors = colors
        
        self.circularButtonModel = .init(
            layout: .init(
                dimension: layout.dimension
            ),
            colors: .init(
                foreground: .init(
                    enabled: colors.enabled,
                    pressed: colors.pressed,
                    disabled: colors.disabled,
                    pressedOpacity: colors.pressedOpacity,
                    disabledOpacity: colors.disabledOpacity
                ),
                fill: .init(
                    enabled: .clear,
                    pressed: .clear,
                    disabled: .clear
                )
            )
        )
    }
}

// MARK:- Layout
extension VChevronButtonPlainModel {
    public struct Layout {
        public let dimension: CGFloat
        public let iconDimension: CGFloat
        
        public init(
            dimension: CGFloat = 32,
            iconDimension: CGFloat = 20
        ) {
            self.dimension = dimension
            self.iconDimension = iconDimension
        }
    }
}

// MARK:- Colors
extension VChevronButtonPlainModel {
    public struct Colors {
        public let enabled: Color
        public let pressed: Color
        public let disabled: Color
        public let pressedOpacity: Double
        public let disabledOpacity: Double
        
        public init(
            enabled: Color = ColorBook.ChevronButton.IconPlain.enabled,
            pressed: Color = ColorBook.ChevronButton.IconPlain.pressed,
            disabled: Color = ColorBook.ChevronButton.IconPlain.disabled,
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
