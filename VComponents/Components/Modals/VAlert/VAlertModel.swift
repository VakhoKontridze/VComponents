//
//  VAlertModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert Model
public struct VAlertModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    var primaryButtonModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()
        
        model.layout.height = layout.buttonHeight
        model.layout.cornerRadius = layout.buttonHeight / 4
        
        model.colors.foreground.pressedOpacity = colors.primaryButton.foreground.pressedOpacity
        
        model.colors.text.enabled = colors.primaryButton.text.enabled
        model.colors.text.pressed = colors.primaryButton.text.pressed
        
        model.colors.background.enabled = colors.primaryButton.background.enabled
        model.colors.background.pressed = colors.primaryButton.background.pressed
        
        model.font = fonts.primaryButton
        
        return model
    }
    
    var secondaryButtonModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()
        
        model.layout.height = layout.buttonHeight
        model.layout.cornerRadius = layout.buttonHeight / 4
        
        model.colors.foreground.pressedOpacity = colors.secondaryButton.foreground.pressedOpacity
        
        model.colors.text.enabled = colors.secondaryButton.text.enabled
        model.colors.text.pressed = colors.secondaryButton.text.pressed
        
        model.colors.background.enabled = colors.secondaryButton.background.enabled
        model.colors.background.pressed = colors.secondaryButton.background.pressed
        
        model.font = fonts.secondaryButton
        
        return model
    }

    public init() {}
}

// MARK:- Layout
extension VAlertModel {
    public struct Layout {
        public var width: CGFloat = UIScreen.main.bounds.width * 0.7
        public var cornerRadius: CGFloat = 20
        
        public var contentInset: CGFloat = 15
        var textMarginTop: CGFloat { max(25 - contentInset, 0) }
        let textMarginHor: CGFloat = 10
        let textSpacing: CGFloat = 5
        let contentSpacing: CGFloat = 20
        
        public var buttonHeight: CGFloat = 40

        public init() {}
    }
}

// MARK:- Colors
extension VAlertModel {
    public struct Colors {
        public static let sideBarColors: VSideBarModel.Colors = .init()
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var background: Color = sideBarColors.background
        public var blinding: Color = sideBarColors.blinding
        
        public var title: Color = ColorBook.primary
        public var description: Color = ColorBook.primary
        
        public var primaryButton: ButtonColors = .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: primaryButtonColors.text.enabled,
                pressed: primaryButtonColors.text.pressed
            ),
            background: .init(
                enabled: primaryButtonColors.background.enabled,
                pressed: primaryButtonColors.background.pressed
            )
        )
        
        public var secondaryButton: ButtonColors = .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: primaryButtonColors.background.enabled,
                pressed: primaryButtonColors.background.pressed
            ),
            background: .init(
                enabled: .clear,
                pressed: .clear
            )
        )

        public init() {}
    }
}

extension VAlertModel.Colors {
    public struct ButtonColors {
        public var foreground: StateOpacityColors
        public var text: StateColors    // Only used in init with string
        public var background: StateColors
        
        public init(foreground: StateOpacityColors, text: StateColors, background: StateColors) {
            self.foreground = foreground
            self.text = text
            self.background = background
        }
    }
}

extension VAlertModel.Colors.ButtonColors {
    public struct StateColors {
        public var enabled: Color
        public var pressed: Color

        public init(enabled: Color, pressed: Color) {
            self.enabled = enabled
            self.pressed = pressed
        }
    }
    
    public struct StateOpacityColors {
        public var pressedOpacity: Double

        public init(pressedOpacity: Double) {
            self.pressedOpacity = pressedOpacity
        }
    }
}

// MARK:- Fonts
extension VAlertModel {
    public struct Fonts {
        public static let primaryButtonFont: Font = VPrimaryButtonModel().font
        
        public var title: Font = .system(size: 16, weight: .bold, design: .default)
        public var description: Font = .system(size: 14, weight: .regular, design: .default)
        public var primaryButton: Font = primaryButtonFont
        public var secondaryButton: Font = primaryButtonFont
        
        public init() {}
    }
}
