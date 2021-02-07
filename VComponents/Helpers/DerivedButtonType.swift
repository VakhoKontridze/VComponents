//
//  DerivedButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- Derived Button Type
enum DerivedButtonType {
    case primary(model: VPrimaryButtonModel)
    case secondary(model: VSecondaryButtonModel)
    case square(model: VSquareButtonModel)
    case plain(model: VPlainButtonModel)
    case custom
}

// MARK:- Derived Button Preset
public enum DerivedButtonPreset {
    case primary(model: VPrimaryButtonModel = .init())
    case secondary(model: VSecondaryButtonModel = .init())
    case square(model: VSquareButtonModel = .init())
    case plain(model: VPlainButtonModel = .init())
    
    var buttonType: DerivedButtonType {
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
