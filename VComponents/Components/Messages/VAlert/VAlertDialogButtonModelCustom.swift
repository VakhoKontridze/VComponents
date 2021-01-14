//
//  VAlertDialogButtonModelCustom.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Alert Dialog Button Model Model
/// Model that describes UI
public enum VAlertDialogButtonModel {
    case primary
    case secondary
    case custom(_ model: VAlertDialogButtonModelCustom)
    
    private static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
    
    private static let primaryModel: VAlertDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: Self.primaryButtonColors.text.enabled,
                pressed: Self.primaryButtonColors.text.pressed,
                disabled: Self.primaryButtonColors.text.disabled
            ),
            background: .init(
                enabled: Self.primaryButtonColors.background.enabled,
                pressed: Self.primaryButtonColors.background.pressed,
                disabled: Self.primaryButtonColors.background.disabled
            )
        )
    )
    
    private static let secondaryModel: VAlertDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: Self.primaryButtonColors.background.enabled,
                pressed: Self.primaryButtonColors.background.pressed,
                disabled: Self.primaryButtonColors.background.disabled
            ),
            background: .init(
                enabled: .clear,
                pressed: .clear,
                disabled: .clear
            )
        )
    )
    
    var primaryButtonModel: VPrimaryButtonModel {
        switch self {
        case .primary: return Self.primaryModel.primaryButtonModel
        case .secondary: return Self.secondaryModel.primaryButtonModel
        case .custom(let model): return model.primaryButtonModel
        }
    }
}

// MARK:- V Alert Dialog Button Model Custom
/// Model that describes UI
public struct VAlertDialogButtonModelCustom {
    public static let primaryButtonFont: Font = VPrimaryButtonModel().font
    
    public var layout: Layout
    public var colors: Colors
    public var font: Font
    
    fileprivate var primaryButtonModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()

        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius

        model.colors.content.pressedOpacity = colors.content.pressedOpacity

        model.colors.text.enabled = colors.text.enabled
        model.colors.text.pressed = colors.text.pressed
        model.colors.text.disabled = colors.text.disabled

        model.colors.background.enabled = colors.background.enabled
        model.colors.background.pressed = colors.background.pressed
        model.colors.background.disabled = colors.background.disabled

        model.font = font

        return model
    }
    
    public init(layout: Layout = .init(), colors: Colors, font: Font = primaryButtonFont) {
        self.layout = layout
        self.colors = colors
        self.font = font
    }
}

// MARK:- Layout
extension VAlertDialogButtonModelCustom {
    public struct Layout {
        public var height: CGFloat = 40
        public var cornerRadius: CGFloat = 10
        
        public init() {}
    }
}

// MARK:- Colors
extension VAlertDialogButtonModelCustom {
    public struct Colors {
        public var content: StateOpacity
        public var text: StateColors    // Only used in init with string
        public var background: StateColors
        
        public init(foreground: StateOpacity, text: StateColors, background: StateColors) {
            self.content = foreground
            self.text = text
            self.background = background
        }
    }
}

extension VAlertDialogButtonModelCustom.Colors {
    public struct StateColors {
        public var enabled: Color
        public var pressed: Color
        public var disabled: Color

        public init(enabled: Color, pressed: Color, disabled: Color) {
            self.enabled = enabled
            self.pressed = pressed
            self.disabled = disabled
        }
    }
    
    public struct StateOpacity {
        public var pressedOpacity: Double

        public init(pressedOpacity: Double) {
            self.pressedOpacity = pressedOpacity
        }
    }
}
