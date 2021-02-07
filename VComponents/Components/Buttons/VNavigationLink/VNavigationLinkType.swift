//
//  VNavigationLinkType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import SwiftUI

// MARK:- V Navigation Link Type
typealias VNavigationLinkType = DerivedButtonType

// MARK:- V Navigation Link Preset
/// Enum that describes navigation link preset, such as primary, secondary, square, or plain
///
/// Custom type can be used via inits that do not take preset as a parameter
public typealias VNavigationLinkPreset = DerivedButtonPreset

// MARK:- Button
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
}
