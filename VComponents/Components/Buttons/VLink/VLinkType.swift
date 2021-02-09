//
//  VLinkType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- V Link Type
typealias VLinkType = DerivedButtonType

// MARK:- V Link Preset
/// Enum that describes link preset, such as primary, secondary, square, or plain
///
/// Custom type can be used via inits that do not take preset as a parameter
public typealias VLinkPreset = DerivedButtonPreset

// MARK:- Button
extension VLinkType {
    @ViewBuilder static func linkButton<Content>(
        buttonType: VLinkType,
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
