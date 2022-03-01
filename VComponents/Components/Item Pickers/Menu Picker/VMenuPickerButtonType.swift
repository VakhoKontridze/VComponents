//
//  VMenuPickerButtonType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Menu Picker Button Type
typealias VMenuPickerButtonType = DerivedButtonType

// MARK: - V Menu Picker Button Preset
/// Enum that describes menu button preset, such as `primary`, `secondary`, `square`, or `plain`.
///
/// Custom type can be used via inits that do not take preset as a parameter.
public typealias VMenuPickerButtonPreset = DerivedButtonPreset

// MARK: - Button
extension VMenuPickerButtonType {
    @ViewBuilder static func menuPickerButton<Content>(
        buttonType: VMenuPickerButtonType,
        isEnabled: Bool,
        @ViewBuilder label: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        Self.menuButton(
            buttonType: buttonType,
            isEnabled: isEnabled,
            label: label
        )
    }
}
