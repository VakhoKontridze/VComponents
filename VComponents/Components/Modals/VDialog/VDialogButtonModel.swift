//
//  VDialogButtonModelCustom.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Dialog Button Model Model
/// Enum that describes `VDialog` button model, such as `primary`, `secondary`, or `custom`.
public enum VDialogButtonModel {
    // MARK: Cases
    /// Primary button.
    case primary
    
    /// Secondary button.
    case secondary
    
    /// Custom button.
    case custom(_ model: VDialogButtonModelCustom)

    // MARK: Sub-Models
    var buttonSubModel: VPrimaryButtonModel {
        switch self {
        case .primary: return VDialogButtonModel.primaryButtonSubModel.primaryButtonSubModel
        case .secondary: return VDialogButtonModel.secondaryButtonSubModel.primaryButtonSubModel
        case .custom(let model): return model.primaryButtonSubModel
        }
    }
    
    private static let primaryButtonSubModel: VDialogButtonModelCustom = .init(
        colors: .init(
            content: .init(
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
            content: .init(
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

// MARK: - V Dialog Button Model Custom
/// Model that describes UI.
public struct VDialogButtonModelCustom {
    // MARK: Properties
    /// Reference to `VPrimaryButtonModel`.
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout
    
    /// Sub-model containing color properties.
    public var colors: Colors
    
    /// Sub-model containing font properties.
    public var fonts: Fonts
    
    // MARK: Initializers
    /// Initializes model with colors.
    public init(layout: Layout = .init(), colors: Colors, fonts: Fonts = .init()) {
        self.layout = layout
        self.colors = colors
        self.fonts = fonts
    }

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Button height. Defaults to `40`.
        public var height: CGFloat = 40
        
        /// Button corner radius. Defaults to `20`.
        public var cornerRadius: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Conrent opacities.
        public var content: StateOpacities
        
        /// Text content colors.
        ///
        /// Only applicable when using init with title.
        public var text: StateColors
        
        /// Background colors.
        public var background: StateColors
        
        // MARK: Initializers
        /// Initializes sub-model with content, text, and background colors.
        public init(content: StateOpacities, text: StateColors, background: StateColors) {
            self.content = content
            self.text = text
            self.background = background
        }
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = StateColors_EPD
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = StateOpacities_P
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Title font. Defaults to system font of size `16` with `semibold` weight.
        public var title: Font = primaryButtonReference.fonts.title
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Sub-Models
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
