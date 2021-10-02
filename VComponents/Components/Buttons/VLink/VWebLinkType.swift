//
//  VWebLinkType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Web Link Type
typealias VWebLinkType = DerivedButtonType

// MARK: - V Web Link Preset
/// Enum that describes link preset, such as `primary`, `secondary`, `square`, or `plain`.
///
/// Custom type can be used via inits that do not take preset as a parameter.
public typealias VWebLinkPreset = DerivedButtonPreset

// MARK: - Button
extension VWebLinkType {
    @ViewBuilder static func webLinkButton<Content>(
        buttonType: VWebLinkType,
        isEnabled: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        Self.navLinkButton(
            buttonType: buttonType,
            isEnabled: isEnabled,
            action: action,
            content: content
        )
    }
}
