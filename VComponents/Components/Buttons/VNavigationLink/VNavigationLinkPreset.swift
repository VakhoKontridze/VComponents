//
//  VNavigationLinkPreset.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import SwiftUI

// MARK:- V Navigation Link Preset
/// Enum that describes navigation link preset, such as primary, secondary, square, or plain
///
/// Custom type can be used via inits that do not take preset as a parameter
public enum VNavigationLinkPreset {
    case primary(model: VPrimaryButtonModel = .init())
    case secondary(model: VSecondaryButtonModel = .init())
    case square(model: VSquareButtonModel = .init())
    case plain(model: VPlainButtonModel = .init())
    
    var buttonType: VNavigationLinkType {
        switch self {
        case .primary(let model): return .primary(model: model)
        case .secondary(let model): return .secondary(model: model)
        case .square(let model): return .square(model: model)
        case .plain(let model): return .plain(model: model)
        }
    }
    
    func text(from title: String, isEnabled: Bool) -> VText {
        let color: Color = {
            switch self {
            case .primary(let model): return model.colors.textContent.for(isEnabled ? VPrimaryButtonInternalState.enabled : .disabled)
            case .secondary(let model): return model.colors.textContent.for(isEnabled ? VSecondaryButtonInternalState.enabled : .disabled)
            case .square(let model): return model.colors.textContent.for(isEnabled ? VSquareButtonInternalState.enabled : .disabled)
            case .plain(let model): return model.colors.textContent.for(isEnabled ? VPlainButtonInternalState.enabled : .disabled)
            }
        }()
        
        let font: Font = {
            switch self {
            case .primary(let model): return model.fonts.title
            case .secondary(let model): return model.fonts.title
            case .square(let model): return model.fonts.title
            case .plain(let model): return model.fonts.title
            }
        }()
        
        return .init(type: .oneLine, font: font, color: color, title: title)
    }
}

// MARK:- V Navigation Link Type
enum VNavigationLinkType {
    case primary(model: VPrimaryButtonModel)
    case secondary(model: VSecondaryButtonModel)
    case square(model: VSquareButtonModel)
    case plain(model: VPlainButtonModel)
    case custom
}

// MARK:- V Navigation Link Type Buttons
extension VNavigationLinkType {
    @ViewBuilder static func navLinkButton<Label>(
        buttonType: VNavigationLinkType,
        isEnabled: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) -> some View
        where Label: View
    {
        switch buttonType {
        case .primary(let model):
            VPrimaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: label
            )
            
        case .secondary(let model):
            VSecondaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: label
            )
            
        case .square(let model):
            VSquareButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: label
            )
            
        case .plain(let model):
            VPlainButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: label
            )
            
        case .custom:
            label()
                .allowsHitTesting(isEnabled)
                .onTapGesture(perform: action)
        }
    }
    
    @ViewBuilder static func pickerButton<Label>(
        buttonType: VNavigationLinkType,
        isEnabled: Bool,
        @ViewBuilder label: @escaping () -> Label
    ) -> some View
        where Label: View
    {
        switch buttonType {
        case .primary(let model):
            VPrimaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .secondary(let model):
            VSecondaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .square(let model):
            VSquareButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .plain(let model):
            VPlainButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .custom:
            label()
        }
    }
}
