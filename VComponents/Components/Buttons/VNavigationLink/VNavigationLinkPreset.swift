//
//  VNavigationLinkPreset.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import SwiftUI

// MARK:- V Navigation Link Preset
/// Preset that describes navigation link, such as primary, secondary, square, or plain
///
/// Custom type can be used via inits that do not take preset as a parameter
public enum VNavigationLinkPreset {
    case primary(model: VPrimaryButtonModel = .init())
    case secondary(model: VSecondaryButtonModel = .init())
    case square(model: VSquareButtonModel = .init())
    case plain(model: VPlainButtonModel = .init())
    
    var linkType: VNavigationLinkType {
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
            case .primary(let model): return model.colors.text.for(isEnabled ? VPrimaryButtonInternalState.enabled : .disabled)
            case .secondary(let model): return model.colors.text.for(isEnabled ? VSecondaryButtonInternalState.enabled : .disabled)
            case .square(let model): return model.colors.text.for(isEnabled ? VSquareButtonInternalState.enabled : .disabled)
            case .plain(let model): return model.colors.text.for(isEnabled ? VPlainButtonInternalState.enabled : .disabled)
            }
        }()
        
        let font: Font = {
            switch self {
            case .primary(let model): return model.font
            case .secondary(let model): return model.font
            case .square(let model): return model.font
            case .plain(let model): return model.font
            }
        }()
        
        return .init(title: title, color: color, font: font, type: .oneLine)
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
