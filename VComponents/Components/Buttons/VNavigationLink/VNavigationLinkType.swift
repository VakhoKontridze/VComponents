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
/// Enum that describes navigation link preset, such as `primary`, `secondary`, `square`, or `plain`
///
/// Custom type can be used via inits that do not take preset as a parameter
public typealias VNavigationLinkPreset = DerivedButtonPreset

// MARK:- Button
extension VNavigationLinkType {
    @ViewBuilder static func navLinkButton<Content>(
        buttonType: VNavigationLinkType,
        isEnabled: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        switch buttonType {
        case .primary(let model):
            VPrimaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: content
            )
            
        case .secondary(let model):
            VSecondaryButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: content
            )
            
        case .square(let model):
            VSquareButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: content
            )
            
        case .plain(let model):
            VPlainButton(
                model: model,
                state: isEnabled ? .enabled : .disabled,
                action: action,
                content: content
            )
            
        case .custom:
            content()
                .allowsHitTesting(isEnabled)
                .onTapGesture(perform: action)
        }
    }
}
