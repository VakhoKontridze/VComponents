//
//  VDialogButtonModelCustom.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Dialog Button Model Model
/// Enum that describes dialog button model, such as primary, secondary, or custom
public enum VDialogButtonModel {
    case primary
    case secondary
    case custom(_ model: VDialogButtonModelCustom)
    
    private static let primaryModel: VDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: VDialogButtonModelCustom.primaryButtonModel.colors.textContent.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonModel.colors.textContent.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonModel.colors.textContent.disabled
            ),
            background: .init(
                enabled: VDialogButtonModelCustom.primaryButtonModel.colors.background.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonModel.colors.background.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonModel.colors.background.disabled
            )
        )
    )
    
    private static let secondaryModel: VDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: VDialogButtonModelCustom.primaryButtonModel.colors.background.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonModel.colors.background.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonModel.colors.background.disabled
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
        case .primary: return VDialogButtonModel.primaryModel.primaryButtonSubModel
        case .secondary: return VDialogButtonModel.secondaryModel.primaryButtonSubModel
        case .custom(let model): return model.primaryButtonSubModel
        }
    }
}

// MARK:- V Dialog Button Model Custom
/// Model that describes UI
public struct VDialogButtonModelCustom {
    public static let primaryButtonModel: VPrimaryButtonModel = .init()
    
    public var layout: Layout
    public var colors: Colors
    public var font: Font
    
    fileprivate var primaryButtonSubModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()

        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius

        model.colors.content = .init(
            pressedOpacity: colors.content.pressedOpacity,
            disabledOpacity: VDialogButtonModelCustom.primaryButtonModel.colors.content.disabledOpacity
        )

        model.colors.textContent = .init(
            enabled: colors.text.enabled,
            pressed: colors.text.pressed,
            disabled: colors.text.disabled,
            loading: VDialogButtonModelCustom.primaryButtonModel.colors.textContent.loading
        )
        
        model.colors.background = .init(
            enabled: colors.background.enabled,
            pressed: colors.background.pressed,
            disabled: colors.background.disabled,
            loading: VDialogButtonModelCustom.primaryButtonModel.colors.background.loading
        )

        model.font = font

        return model
    }
    
    public init(layout: Layout = .init(), colors: Colors, font: Font = primaryButtonModel.font) {
        self.layout = layout
        self.colors = colors
        self.font = font
    }
}

// MARK:- Layout
extension VDialogButtonModelCustom {
    public struct Layout {
        public var height: CGFloat = 40
        public var cornerRadius: CGFloat = 10
        
        public init() {}
    }
}

// MARK:- Colors
extension VDialogButtonModelCustom {
    public struct Colors {
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

extension VDialogButtonModelCustom.Colors {
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
