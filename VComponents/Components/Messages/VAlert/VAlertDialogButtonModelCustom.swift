//
//  VAlertDialogButtonModelCustom.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Alert Dialog Button Model Model
/// Enum that describes dialog button model, such as primary, secondary, or custom
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
                enabled: Self.primaryButtonColors.textContent.enabled,
                pressed: Self.primaryButtonColors.textContent.pressed,
                disabled: Self.primaryButtonColors.textContent.disabled
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

        model.colors.content = .init(
            pressedOpacity: colors.content.pressedOpacity,
            disabledOpacity: Colors.primaryButtonColors.content.disabledOpacity
        )

        model.colors.textContent = .init(
            enabled: colors.text.enabled,
            pressed: colors.text.pressed,
            disabled: colors.text.disabled,
            loading: Colors.primaryButtonColors.textContent.loading
        )
        
        model.colors.background = .init(
            enabled: colors.background.enabled,
            pressed: colors.background.pressed,
            disabled: colors.background.disabled,
            loading: Colors.primaryButtonColors.background.loading
        )

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
        fileprivate static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        
        public var content: StateOpacity
        public var text: StateColors    // Only applicable during init with title
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
