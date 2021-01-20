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
    public static let baseTextFieldKeyboardType: UIKeyboardType = VBaseTextFieldModel().keyboardType
    public static let baseTextFieldReturnButton: UIReturnKeyType = VBaseTextFieldModel().returnButton
    public static let baseTextFieldAutoCorrect: Bool = VBaseTextFieldModel().useAutoCorrect
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    
    public var keyboardType: UIKeyboardType = baseTextFieldKeyboardType
    public var useAutoCorrect: Bool = baseTextFieldAutoCorrect
    
    public var returnButton: UIReturnKeyType = baseTextFieldReturnButton
    
    public var clearButton: Bool = true
    public var clearButtonAnimation: Animation? = .easeInOut
    
    public var cancelButton: String? = nil
    
    func baseTextFieldModel(state: VTextFieldState, isSecureTextEntry: Bool) -> VBaseTextFieldModel {
        var model: VBaseTextFieldModel = .init()
        
        model.layout.textAlignment = layout.textAlignment
        
        model.colors.text = .init(
            enabled: colors.text.for(state),    // .disabled wouldn't matter
            disabled: colors.text.disabled,
            disabledOpacity: colors.content.disabledOpacity
        )
        
        model.font = fonts.textFont
        
        model.isSecureTextEntry = isSecureTextEntry
        
        model.keyboardType = keyboardType
        model.useAutoCorrect = useAutoCorrect
        
        model.returnButton = returnButton
        
        return model
    }
    
    func clearButtonModel(state: VTextFieldState, highlight: VTextFieldHighlight) -> VCloseButtonModel {
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
    
    func visibilityButtonModel(state: VTextFieldState, highlight: VTextFieldHighlight) -> VSquareButtonModel {
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
    
    var cancelButtonModel: VPlainButtonModel {
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.content = .init(
            pressedOpacity: colors.cancelButton.pressedOpacity,
            disabledOpacity: colors.cancelButton.disabledOpacity
        )
        
        model.colors.text = .init(
            enabled: colors.cancelButton.enabled,
            pressed: colors.cancelButton.pressed,
            disabled: colors.cancelButton.disabled
        )
        
        model.font = fonts.cancelButton
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VTextFieldModel {
    public struct Layout {
        public static let segmentedPickerLayout: VSegmentedPickerModel.Layout = .init()
        
        public var height: CGFloat = 50
        public var cornerRadius: CGFloat = 10
        
        public var textAlignment: TextAlignment = .default
        
        public var borderWidth: CGFloat = 2
        
        public var contentMarginHorizontal: CGFloat = 15
        
        public var searchIconDimension: CGFloat = 15
        
        public var clearButtonDimension: CGFloat = 22
        public var clearButtonIconDimension: CGFloat = 10
        
        public var visibilityButtonDimension: CGFloat = 22
        public var visibilityButtonIconDimension: CGFloat = 20
        
        public var buttonSpacing: CGFloat = 10

        public var titleSpacing: CGFloat = segmentedPickerLayout.titleSpacing
        public var titleMarginHor: CGFloat = segmentedPickerLayout.titleMarginHor
        
        public init() {}
    }
}

extension VTextFieldModel.Layout {
    public typealias TextAlignment = VBaseTextFieldModel.Layout.TextAlignment
}

// MARK:- Colors
extension VTextFieldModel {
    public struct Colors {
        public static let segmentedPickerColors: VSegmentedPickerModel.Colors = .init()
        public static let squareButtonColors: VSquareButtonModel.Colors = .init()
        public static let plainButtonColors: VPlainButtonModel.Colors = .init()
        public static let closeButtonColors: VCloseButtonModel.Colors = .init()
        
        public var content: StateOpacity = .init(
            disabledOpacity: 0.5
        )
        
        public var text: StateColors = .init(
            enabled: ColorBook.primary,
            focused: ColorBook.primary,
            disabled: ColorBook.primary
        )
        
        public var background: StateColorsHighlighted = .init(
            enabled: segmentedPickerColors.background.enabled,
            focused: .init(componentAsset: "TextField.Background.focused"),
            success: .init(componentAsset: "TextField.Background.success"),
            error: .init(componentAsset: "TextField.Background.error"),
            disabled: segmentedPickerColors.background.disabled
        )
        
        public var border: StateColorsHighlighted = .init(
            enabled: .clear,
            focused: .clear,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: .clear
        )
        
        public var title: StateColorsHighlighted = .init(
            enabled: segmentedPickerColors.title.enabled,
            focused: segmentedPickerColors.title.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerColors.title.disabled
        )
        
        public var description: StateColorsHighlighted = .init(
            enabled: segmentedPickerColors.description.enabled,
            focused: segmentedPickerColors.description.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerColors.description.disabled
        )
        
        public var searchIcon: StateColorsHighlighted = .init(
            enabled: segmentedPickerColors.title.enabled,
            focused: segmentedPickerColors.title.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerColors.title.disabled
        )
        
        public var visibilityButtonIcon: ButtonStateColorsAndOpacityHighlighted = .init(
            enabled: segmentedPickerColors.title.enabled,
            enabledPressed: segmentedPickerColors.title.enabled,
            focused: segmentedPickerColors.title.enabled,
            focusedPressed: segmentedPickerColors.title.enabled,
            success: .init(componentAsset: "TextField.Border.success"),
            successPressed: .init(componentAsset: "TextField.Border.success"),
            error: .init(componentAsset: "TextField.Border.error"),
            errorPressed: .init(componentAsset: "TextField.Border.error"),
            disabled: segmentedPickerColors.title.disabled,
            pressedOpacity: squareButtonColors.content.pressedOpacity,
            disabledOpacity: squareButtonColors.content.disabledOpacity
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
        
        public var clearButtonIcon: ButtonStateColorsAndOpacityHighlighted = .init(
            enabled: .init(componentAsset: "TextField.ClearButton.Icon"),
            enabledPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            focused: .init(componentAsset: "TextField.ClearButton.Icon"),
            focusedPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            success: .init(componentAsset: "TextField.ClearButton.Icon"),
            successPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            error: .init(componentAsset: "TextField.ClearButton.Icon"),
            errorPressed: .init(componentAsset: "TextField.ClearButton.Icon"),
            disabled: .init(componentAsset: "TextField.ClearButton.Icon"),
            pressedOpacity: closeButtonColors.content.pressedOpacity,
            disabledOpacity: closeButtonColors.content.disabledOpacity
        )
        
        public var cancelButton: StateColorsAndOpacity = .init(
            enabled: ColorBook.primary,
            pressed: ColorBook.primary,
            disabled: ColorBook.primary,
            pressedOpacity: plainButtonColors.content.pressedOpacity,
            disabledOpacity: plainButtonColors.content.disabledOpacity
        )
        
        public init() {}
    }
}

extension VTextFieldModel.Colors {
    public struct StateColors {
        public var enabled: Color
        public var focused: Color
        public var disabled: Color
        
        public init(enabled: Color, focused: Color, disabled: Color) {
            self.enabled = enabled
            self.focused = focused
            self.disabled = disabled
        }
        
        func `for`(_ state: VTextFieldState) -> Color {
            switch state {
            case .enabled: return enabled
            case .focused: return focused
            case .disabled: return disabled
            }
        }
    }
    
    public struct StateColorsHighlighted {
        public var enabled: Color
        public var focused: Color
        public var success: Color
        public var error: Color
        public var disabled: Color
        
        public init(enabled: Color, focused: Color, success: Color, error: Color, disabled: Color) {
            self.enabled = enabled
            self.focused = focused
            self.success = success
            self.error = error
            self.disabled = disabled
        }
        
        func `for`(_ state: VTextFieldState, highlight: VTextFieldHighlight) -> Color {
            switch (highlight, state) {
            case (_, .disabled): return disabled
            case (.none, .enabled): return enabled
            case (.none, .focused): return focused
            case (.success, .enabled): return success
            case (.success, .focused): return success
            case (.error, .enabled): return error
            case (.error, .focused): return error
            }
        }
    }
    
    public struct StateOpacity {
        public var disabledOpacity: Double
        
        public init(disabledOpacity: Double) {
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VTextFieldState) -> Double {
            switch state {
            case .enabled: return 1
            case .focused: return 1
            case .disabled: return disabledOpacity
            }
        }
    }
    
    public struct ButtonStateColorsHighlighted {
        public var enabled: Color
        public var enabledPressed: Color
        public var focused: Color
        public var focusedPressed: Color
        public var success: Color
        public var successPressed: Color
        public var error: Color
        public var errorPressed: Color
        public var disabled: Color
        
        public init(enabled: Color, enabledPressed: Color, focused: Color, focusedPressed: Color, success: Color, successPressed: Color, error: Color, errorPressed: Color, disabled: Color) {
            self.enabled = enabled
            self.enabledPressed = enabledPressed
            self.focused = focused
            self.focusedPressed = focusedPressed
            self.success = success
            self.successPressed = successPressed
            self.error = error
            self.errorPressed = errorPressed
            self.disabled = disabled
        }
        
        func `for`(_ state: VTextFieldState, highlight: VTextFieldHighlight) -> Color {
            switch (highlight, state) {
            case (_, .disabled): return disabled
            case (.none, .enabled): return enabled
            case (.none, .focused): return focused
            case (.success, .enabled): return success
            case (.success, .focused): return success
            case (.error, .enabled): return error
            case (.error, .focused): return error
            }
        }
        
        fileprivate func `for`(highlight: VTextFieldHighlight) -> Color {
            switch highlight {
            case .none: return enabledPressed
            case .success: return successPressed
            case .error: return errorPressed
            }
        }
    }
    
    public struct ButtonStateColorsAndOpacityHighlighted {
        public var enabled: Color
        public var enabledPressed: Color
        public var focused: Color
        public var focusedPressed: Color
        public var success: Color
        public var successPressed: Color
        public var error: Color
        public var errorPressed: Color
        public var disabled: Color
        public var pressedOpacity: Double
        public var disabledOpacity: Double
        
        public init(enabled: Color, enabledPressed: Color, focused: Color, focusedPressed: Color, success: Color, successPressed: Color, error: Color, errorPressed: Color, disabled: Color, pressedOpacity: Double, disabledOpacity: Double) {
            self.enabled = enabled
            self.enabledPressed = enabledPressed
            self.focused = focused
            self.focusedPressed = focusedPressed
            self.success = success
            self.successPressed = successPressed
            self.error = error
            self.errorPressed = errorPressed
            self.disabled = disabled
            self.pressedOpacity = pressedOpacity
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VTextFieldState, highlight: VTextFieldHighlight) -> Color {
            switch (highlight, state) {
            case (_, .disabled): return disabled
            case (.none, .enabled): return enabled
            case (.none, .focused): return focused
            case (.success, .enabled): return success
            case (.success, .focused): return success
            case (.error, .enabled): return error
            case (.error, .focused): return error
            }
        }
        
        fileprivate func `for`(highlight: VTextFieldHighlight) -> Color {
            switch highlight {
            case .none: return enabledPressed
            case .success: return successPressed
            case .error: return errorPressed
            }
        }
    }
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}

// MARK:- Fonts
extension VTextFieldModel {
    public struct Fonts {
        public static let baseTextFieldFont: UIFont = VBaseTextFieldModel().font
        public static let segmentedPickerFonts: VSegmentedPickerModel.Fonts = .init()
        public static let cancelButtonFont: Font = VPlainButtonModel().font
        
        public var textFont: UIFont = baseTextFieldFont
        
        public var placeholder: Font = segmentedPickerFonts.description
        public var title: Font = segmentedPickerFonts.title
        public var description: Font = segmentedPickerFonts.description
        
        public var cancelButton: Font = cancelButtonFont
        
        public init() {}
    }
}
