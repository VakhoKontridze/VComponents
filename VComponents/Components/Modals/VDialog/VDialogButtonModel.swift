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
}

// MARK:- Sub-Models
extension VDialogButtonModel {
    var buttonSubModel: VPrimaryButtonModel {
        switch self {
        case .primary: return VDialogButtonModel.primaryButtonSubModel.primaryButtonSubModel
        case .secondary: return VDialogButtonModel.secondaryButtonSubModel.primaryButtonSubModel
        case .custom(let model): return model.primaryButtonSubModel
        }
    }
    
    private static let primaryButtonSubModel: VDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: VDialogButtonModelCustom.primaryButtonReference.colors.textContent.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonReference.colors.textContent.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonReference.colors.textContent.disabled
            ),
            background: .init(
                enabled: VDialogButtonModelCustom.primaryButtonReference.colors.background.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonReference.colors.background.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonReference.colors.background.disabled
            )
        )
    )
    
    private static let secondaryButtonSubModel: VDialogButtonModelCustom = .init(
        colors: .init(
            foreground: .init(
                pressedOpacity: 0.5
            ),
            text: .init(
                enabled: VDialogButtonModelCustom.primaryButtonReference.colors.background.enabled,
                pressed: VDialogButtonModelCustom.primaryButtonReference.colors.background.pressed,
                disabled: VDialogButtonModelCustom.primaryButtonReference.colors.background.disabled
            ),
            background: .init(
                enabled: .clear,
                pressed: .clear,
                disabled: .clear
            )
        )
    )
}

// MARK:- V Dialog Button Model Custom
/// Model that describes UI
public struct VDialogButtonModelCustom {
    public var layout: Layout
    public var colors: Colors
    public var fonts: Fonts
    
    public init(layout: Layout = .init(), colors: Colors, fonts: Fonts = .init()) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
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

// MARK:- Fonts
extension VDialogButtonModelCustom {
    public struct Fonts {
        public var title: Font = primaryButtonReference.fonts.title
        
        public init() {}
    }
}

// MARK:- References
extension VDialogButtonModelCustom {
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
}

// MARK:- Sub-Models
extension VDialogButtonModelCustom {
    fileprivate var primaryButtonSubModel: VPrimaryButtonModel {
        var model: VPrimaryButtonModel = .init()

        model.layout.height = layout.height
        model.layout.cornerRadius = layout.cornerRadius

        model.colors.content = .init(
            pressedOpacity: colors.content.pressedOpacity,
            disabledOpacity: VDialogButtonModelCustom.primaryButtonReference.colors.content.disabledOpacity
        )

        model.colors.textContent = .init(
            enabled: colors.text.enabled,
            pressed: colors.text.pressed,
            disabled: colors.text.disabled,
            loading: VDialogButtonModelCustom.primaryButtonReference.colors.textContent.loading
        )
        
        model.colors.background = .init(
            enabled: colors.background.enabled,
            pressed: colors.background.pressed,
            disabled: colors.background.disabled,
            loading: VDialogButtonModelCustom.primaryButtonReference.colors.background.loading
        )

        model.fonts.title = fonts.title

        return model
    }
}
