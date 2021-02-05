//
//  VTextFieldModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- V Text Field Model
/// Model that describes UI
public struct VTextFieldModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VTextFieldModel {
    public struct Layout {
        public var height: CGFloat = 50
        public var cornerRadius: CGFloat = 10
        
        public var textAlignment: TextAlignment = .default
        
        public var borderWidth: CGFloat = 1.5
        
        public var contentMarginHorizontal: CGFloat = 15
        
        public var searchIconDimension: CGFloat = 15
        
        public var clearButtonDimension: CGFloat = 22
        public var clearButtonIconDimension: CGFloat = 8
        
        public var visibilityButtonDimension: CGFloat = 22
        public var visibilityButtonIconDimension: CGFloat = 20
        
        public var contentSpacing: CGFloat = 10

        public var headerFooterSpacing: CGFloat = segmentedPickerReference.layout.headerFooterSpacing
        public var headerFooterMarginHor: CGFloat = segmentedPickerReference.layout.headerFooterMarginHor
        
        public init() {}
    }
}

extension VTextFieldModel.Layout {
    /// Enum that describes text alignment, such as leading, center, trailing, or auto
    public typealias TextAlignment = VBaseTextFieldModel.Layout.TextAlignment
}

// MARK:- Colors
extension VTextFieldModel {
    public struct Colors {
        public var content: StateOpacities = .init(
            disabledOpacity: 0.5
        )
        
        public var textContent: StateColors = .init(
            enabled: ColorBook.primary,
            focused: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public var background: StateColorsHighlighted = .init(
            enabled: segmentedPickerReference.colors.background.enabled,
            focused: .init(componentAsset: "TextField.Background.focused"),
            success: .init(componentAsset: "TextField.Background.success"),
            error: .init(componentAsset: "TextField.Background.error"),
            disabled: segmentedPickerReference.colors.background.disabled
        )
        
        public var border: StateColorsHighlighted = .init(
            enabled: .clear,
            focused: .clear,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: .clear
        )
        
        public var header: StateColorsHighlighted = .init(
            enabled: segmentedPickerReference.colors.header.enabled,
            focused: segmentedPickerReference.colors.header.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerReference.colors.header.disabled
        )
        
        public var footer: StateColorsHighlighted = .init(
            enabled: segmentedPickerReference.colors.footer.enabled,
            focused: segmentedPickerReference.colors.footer.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerReference.colors.footer.disabled
        )
        
        public var searchIcon: StateColorsHighlighted = .init(
            enabled: segmentedPickerReference.colors.header.enabled,
            focused: segmentedPickerReference.colors.header.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerReference.colors.header.disabled
        )
        
        public var visibilityButtonIcon: ButtonStateColorsAndOpacitiesHighlighted = .init(
            enabled: segmentedPickerReference.colors.header.enabled,
            enabledPressed: segmentedPickerReference.colors.header.enabled,
            focused: segmentedPickerReference.colors.header.enabled,
            focusedPressed: segmentedPickerReference.colors.header.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            successPressed: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            errorPressed: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerReference.colors.header.disabled,
            pressedOpacity: squareButtonReference.colors.content.pressedOpacity,
            disabledOpacity: squareButtonReference.colors.content.disabledOpacity
        )
        
        public var clearButtonBackground: ButtonStateColorsHighlighted = .init(
            enabled: .init(componentAsset: "TextField.ClearButton.Background.enabled"),
            enabledPressed: .init(componentAsset: "TextField.ClearButton.Background.pressed"),
            focused: .init(componentAsset: "TextField.ClearButton.Background.enabled"),
            focusedPressed: .init(componentAsset: "TextField.ClearButton.Background.pressed"),
            success: .init(componentAsset: "TextField.Border.success"),
            successPressed: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            errorPressed: .init(componentAsset: "TextField.Border.error"),
            disabled: .init(componentAsset: "TextField.ClearButton.Background.disabled")
        )
        
        public var clearButtonIcon: ButtonStateColorsAndOpacitiesHighlighted = .init(
            enabled: .init(componentAsset: "TextField.ClearButton.Icon"),
            enabledPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            focused: .init(componentAsset: "TextField.ClearButton.Icon"),
            focusedPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            success: .init(componentAsset: "TextField.ClearButton.Icon"),
            successPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            error: .init(componentAsset: "TextField.ClearButton.Icon"),
            errorPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            disabled: .init(componentAsset: "TextField.ClearButton.Icon"),
            pressedOpacity: closeButtonReference.colors.content.pressedOpacity,
            disabledOpacity: closeButtonReference.colors.content.disabledOpacity
        )
        
        public var cancelButton: StateColorsAndOpacities = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: plainButtonReference.colors.content.pressedOpacity,
            disabledOpacity: plainButtonReference.colors.content.disabledOpacity
        )
        
        public init() {}
    }
}

extension VTextFieldModel.Colors {
    public typealias StateColors = StateColorsEFD
    
    public typealias StateOpacities = StateOpacitiesD
    
    public typealias StateColorsAndOpacities = StateColorsAndOpacitiesEPD_PD
    
    public typealias StateColorsHighlighted = StateColorsEFSED
    
    public typealias ButtonStateColorsHighlighted = StateColorsEpFpSpEpD
    
    public typealias ButtonStateColorsAndOpacitiesHighlighted = StateColorsEpFpSpEpD_PD
}

// MARK:- Fonts
extension VTextFieldModel {
    public struct Fonts {
        public var text: UIFont = baseTextFieldReference.fonts.text
        
        public var placeholder: Font = segmentedPickerReference.fonts.footer
        public var header: Font = segmentedPickerReference.fonts.header
        public var footer: Font = segmentedPickerReference.fonts.footer
        
        public var cancelButton: Font = plainButtonReference.fonts.title
        
        public init() {}
    }
}

// MARK:- Animations
extension VTextFieldModel {
    public struct Animations {
        public var buttonsAppearDisAppear: Animation? = .easeInOut
        static let durationDelayToShowButtons: TimeInterval = 0.5   // Must be more than keyboard or modal duration
        
        public init() {}
    }
}

// MARK:- Misc
extension VTextFieldModel {
    public struct Misc {
        public var keyboardType: UIKeyboardType = baseTextFieldReference.misc.keyboardType
        public var textContentType: UITextContentType?
        
        public var spellCheck: UITextSpellCheckingType = baseTextFieldReference.misc.spellCheck
        public var autoCorrect: UITextAutocorrectionType = baseTextFieldReference.misc.autoCorrect
        
        public var returnButton: UIReturnKeyType = baseTextFieldReference.misc.returnButton
        public var clearButton: Bool = true
        public var cancelButton: String? = nil
        
        public init() {}
    }
}

// MARK:- References
extension VTextFieldModel {
    public static let baseTextFieldReference: VBaseTextFieldModel = .init()
    public static let squareButtonReference: VSquareButtonModel = .init()
    public static let plainButtonReference: VPlainButtonModel = .init()
    public static let closeButtonReference: VCloseButtonModel = .init()
    public static let segmentedPickerReference: VSegmentedPickerModel = .init()
}

// MARK:- Sub-Models
extension VTextFieldModel {
    func baseTextFieldSubModel(state: VTextFieldState, isSecureTextEntry: Bool) -> VBaseTextFieldModel {
        var model: VBaseTextFieldModel = .init()
        
        model.layout.textAlignment = layout.textAlignment
        
        model.colors.textContent = .init(
            enabled: colors.textContent.for(state),    // .disabled wouldn't matter
            disabled: colors.textContent.disabled,
            disabledOpacity: colors.content.disabledOpacity
        )
        
        model.fonts.text = fonts.text
        
        model.misc.isSecureTextEntry = isSecureTextEntry
        
        model.misc.keyboardType = misc.keyboardType
        model.misc.textContentType = misc.textContentType
        
        model.misc.spellCheck = misc.spellCheck
        model.misc.autoCorrect = misc.autoCorrect
        
        model.misc.returnButton = misc.returnButton
        
        return model
    }
    
    func clearSubButtonModel(state: VTextFieldState, highlight: VTextFieldHighlight) -> VCloseButtonModel {
        var model: VCloseButtonModel = .init()
        
        model.layout.dimension = layout.clearButtonDimension
        model.layout.iconDimension = layout.clearButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = .init(
            enabled: colors.clearButtonBackground.for(state, highlight: highlight),  // .disabled wouldn't matter
            pressed: colors.clearButtonBackground.for(highlight: highlight),
            disabled: colors.clearButtonBackground.disabled
        )
        
        model.colors.content = .init(
            enabled: colors.clearButtonIcon.for(state, highlight: highlight),       // .disabled wouldn't matter
            pressed: colors.clearButtonIcon.for(highlight: highlight),
            disabled: colors.clearButtonIcon.disabled,
            pressedOpacity: colors.clearButtonIcon.pressedOpacity,
            disabledOpacity: colors.clearButtonIcon.disabledOpacity
        )
        
        return model
    }
    
    func visibilityButtonSubModel(state: VTextFieldState, highlight: VTextFieldHighlight) -> VSquareButtonModel {
        var model: VSquareButtonModel = .init()
        
        model.layout.dimension = layout.visibilityButtonDimension
        model.layout.cornerRadius = layout.visibilityButtonDimension / 2
        model.layout.contentMarginHor = 0
        model.layout.contentMarginVer = 0
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = .init(
            enabled: .clear,
            pressed: .clear,
            disabled: .clear
        )
        
        model.colors.content = .init(
            pressedOpacity: colors.visibilityButtonIcon.pressedOpacity,
            disabledOpacity: colors.visibilityButtonIcon.disabledOpacity
        )
        
        return model
    }
    
    var cancelButtonSubModel: VPlainButtonModel {
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.content = .init(
            pressedOpacity: colors.cancelButton.pressedOpacity,
            disabledOpacity: colors.cancelButton.disabledOpacity
        )
        
        model.colors.textContent = .init(
            enabled: colors.cancelButton.enabled,
            pressed: colors.cancelButton.pressed,
            disabled: colors.cancelButton.disabled
        )
        
        model.fonts.title = fonts.cancelButton
        
        return model
    }
}
