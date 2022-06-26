//
//  VConfirmationDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - V Confirmation Dialog Button
/// Model that represents `VConfirmationDialog` button, such as `standard`, `secondary`, `destructive`, or `cancel`.
///
/// `cancel` will be moved to the end of the stack.
/// If there are multiple `cancel` buttons, only the last one will be kept.
/// If thete are no buttons, an `ok` button will be added.
public struct VConfirmationDialogButton {
    // MARK: Properties
    let _confirmationDialogButton: _VConfirmationDialogButton
    let isEnabled: Bool
    let action: (() -> Void)?
    let title: String
    
    // MARK: Initializers
    private init(
        confirmationDialogButton: _VConfirmationDialogButton,
        isEnabled: Bool,
        action: (() -> Void)?,
        title: String
    ) {
        self._confirmationDialogButton = confirmationDialogButton
        self.isEnabled = isEnabled
        self.action = action
        self.title = title
    }
    
    /// Standard button.
    public static func standard(
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(
            confirmationDialogButton: .standard,
            isEnabled: isEnabled,
            action: action,
            title: title
        )
    }
    
    /// Destructive button.
    public static func destructive(
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(
            confirmationDialogButton: .destructive,
            isEnabled: isEnabled,
            action: action,
            title: title
        )
    }
    
    /// Cancel button.
    public static func cancel(
        isEnabled: Bool = true,
        action: (() -> Void)? = nil,
        title: String? = nil
    ) -> Self {
        .init(
            confirmationDialogButton: .cancel,
            isEnabled: isEnabled,
            action: action,
            title: title ?? VComponentsLocalizationService.shared.localizationProvider.vConfirmationDialogCancelButtonTitle
        )
    }
    
    private static func ok() -> Self {
        .init(
            confirmationDialogButton: .ok,
            isEnabled: true,
            action: nil,
            title: VComponentsLocalizationService.shared.localizationProvider.vConfirmationDialogOKButtonTitle
        )
    }
    
    // MARK: Processing
    static func process(_ buttons: [Self]) -> [Self] {
        // `.confirmationDialog()` filters out disabled buttons
        let buttons: [Self] = buttons.filter { $0.isEnabled }
        
        var result: [VConfirmationDialogButton] = .init()
        
        for button in buttons {
            if button._confirmationDialogButton == .cancel { result.removeAll(where: { $0._confirmationDialogButton == .cancel }) }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { $0._confirmationDialogButton == .cancel }) {
            result.append(result.remove(at: cancelButtonIndex))
        }
        
        if result.isEmpty {
            result.append(.ok())
        }
        
        return result
    }
    
    // MARK: Button
    var swiftUIButton: Button<Text> {
        switch _confirmationDialogButton {
        case .standard:
            return Button(
                title,
                role: nil,
                action: { action?() }
            )
            
        case .destructive:
            return Button(
                title,
                role: .destructive,
                action: { action?() }
            )
        
        case .cancel:
            return Button(
                title,
                role: .cancel,
                action: { action?() }
            )
            
        case .ok:
            return Button(
                title,
                role: nil,
                action: { action?() }
            )
        }
    }
}

// MARK: - _ V Confirmation Dialog Button
enum _VConfirmationDialogButton {
    case standard
    case destructive
    case cancel
    case ok // Not accessible from outside
}
