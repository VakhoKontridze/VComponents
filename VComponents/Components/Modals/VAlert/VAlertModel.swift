//
//  VAlertModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert Model
public struct VAlertModel {
    public let layout: Layout
    public let colors: Colors
    public let fonts: Fonts
    let primaryButtonModel: VPrimaryButtonModel
    let secondaryButtonModel: VPrimaryButtonModel

    public init(
        layout: Layout = .init(),
        colors: Colors = .init(),
        fonts: Fonts = .init()
    ) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
        self.primaryButtonModel = .init(
            layout: .init(
                height: layout.buttonHeight,
                cornerRadius: layout.buttonHeight / 4
            ),
            colors: .init(
                foreground: .init(
                    enabled: colors.primaryButton.foreground.enabled,
                    pressed: colors.primaryButton.foreground.pressed,
                    pressedOpacity: colors.primaryButton.foreground.pressedOpacity
                ),
                background: .init(
                    enabled: colors.primaryButton.background.enabled,
                    pressed: colors.primaryButton.background.pressed
                )
            ),
            font: fonts.primaryButton
        )
        self.secondaryButtonModel = .init(
            layout: .init(
                height: layout.buttonHeight,
                cornerRadius: layout.buttonHeight / 4
            ),
            colors: .init(
                foreground: .init(
                    enabled: colors.secondaryButton.foreground.enabled,
                    pressed: colors.secondaryButton.foreground.pressed,
                    pressedOpacity: colors.secondaryButton.foreground.pressedOpacity
                ),
                background: .init(
                    enabled: colors.secondaryButton.background.enabled,
                    pressed: colors.secondaryButton.background.pressed
                )
            ),
            font: fonts.secondaryButton
        )
    }
}

// MARK:- Layout
extension VAlertModel {
    public struct Layout {
        public let width: CGFloat
        public let cornerRadius: CGFloat
        public let contentInset: CGFloat
        let textPaddingTop: CGFloat
        let textPaddingHor: CGFloat
        let textSpacing: CGFloat
        let contentSpacing: CGFloat
        public let buttonHeight: CGFloat

        public init(
            width: CGFloat = UIScreen.main.bounds.width * 0.7,
            cornerRadius: CGFloat = 20,
            contentInset: CGFloat = 15,
            buttonHeight: CGFloat = 40
        ) {
            self.width = width
            self.cornerRadius = cornerRadius
            self.contentInset = contentInset
            self.textPaddingTop = max(25 - contentInset, 0)
            self.textPaddingHor = 10
            self.textSpacing = 5
            self.contentSpacing = 20
            self.buttonHeight = buttonHeight
        }
    }
}

// MARK:- Colors
extension VAlertModel {
    public struct Colors {
        public static let sideBarColors: VSideBarModel.Colors = .init()
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public let background: Color
        public let blinding: Color
        public let title: Color
        public let description: Color
        public let primaryButton: ButtonColors
        public let secondaryButton: ButtonColors

        public init(
            background: Color = sideBarColors.background,
            blinding: Color = sideBarColors.blinding,
            title: Color = ColorBook.primary,
            description: Color = ColorBook.primary,
            primaryButton: ButtonColors = .init(
                foreground: .init(
                    enabled: primaryButtonColors.foreground.enabled,
                    pressed: primaryButtonColors.foreground.pressed
                ),
                background: .init(
                    enabled: primaryButtonColors.background.enabled,
                    pressed: primaryButtonColors.background.pressed
                )
            ),
            secondaryButton: ButtonColors = .init(
                foreground: .init(
                    enabled: primaryButtonColors.background.enabled,
                    pressed: primaryButtonColors.background.pressed
                ),
                background: .init(
                    enabled: .clear,
                    pressed: .clear
                )
            )
        ) {
            self.background = background
            self.blinding = blinding
            self.title = title
            self.description = description
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
        }
    }
}

extension VAlertModel.Colors {
    public struct ButtonColors {
        public let foreground: Foreground
        public let background: Background

        public init(
            foreground: Foreground,
            background: Background
        ) {
            self.foreground = foreground
            self.background = background
        }
    }
}

extension VAlertModel.Colors.ButtonColors {
    public struct Foreground {
        public let enabled: Color
        public let pressed: Color
        public let pressedOpacity: Double

        public init(
            enabled: Color,
            pressed: Color,
            pressedOpacity: Double = 0.5
        ) {
            self.enabled = enabled
            self.pressed = pressed
            self.pressedOpacity = pressedOpacity
        }
    }

    public struct Background {
        public let enabled: Color
        public let pressed: Color

        public init(
            enabled: Color,
            pressed: Color
        ) {
            self.enabled = enabled
            self.pressed = pressed
        }
    }
}

// MARK:- Fonts
extension VAlertModel {
    public struct Fonts {
        public static let primaryButtonFont: Font = VPrimaryButtonModel().font
        
        public let title: Font
        public let description: Font
        public let primaryButton: Font
        public let secondaryButton: Font
        
        public init(
            title: Font = .system(size: 16, weight: .bold, design: .default),
            description: Font = .system(size: 14, weight: .regular, design: .default),
            primaryButton: Font = primaryButtonFont,
            secondaryButton: Font = primaryButtonFont
        ) {
            self.title = title
            self.description = description
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
        }
    }
}
