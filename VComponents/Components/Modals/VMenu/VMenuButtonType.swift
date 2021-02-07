//
//  VMenuPreset.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK:- V Menu  Button Type
typealias VMenuButtonType = DerivedButtonType

// MARK:- V Menu  Button Preset
/// Enum that describes menu button preset, such as primary, secondary, square, or plain
///
/// Custom type can be used via inits that do not take preset as a parameter
public typealias VMenuButtonPreset = DerivedButtonPreset

// MARK:- Button
extension VMenuButtonType {
    @ViewBuilder static func menuButton<Label>(
        buttonType: VMenuButtonType,
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

