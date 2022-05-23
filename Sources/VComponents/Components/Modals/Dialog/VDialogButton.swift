//
//  VDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK: - V Dialog Button
/// Model that describes `VDialog` button, such as `primary`, `secondary`, `destructive`, or `cancel`.
///
/// `Cancel` will be moved to the end of the stack.
/// If there are multiple `cancel` buttons, only the last one will be kept.
/// If thete are no buttons, an `ok` button will be added.
public struct VDialogButton {
    // MARK: Properties
    let _dialogButton: _VDialogButton
    let isEnabled: Bool
    let action: (() -> Void)?
    let title: String
    
    // MARK: Initializers
    private init(
        dialogButton: _VDialogButton,
        isEnabled: Bool,
        action: (() -> Void)?,
        title: String
    ) {
        self._dialogButton = dialogButton
        self.isEnabled = isEnabled
        self.action = action
        self.title = title
    }
    
    /// Primary button.
    public static func primary(
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(
            dialogButton: .primary,
            isEnabled: isEnabled,
            action: action,
            title: title
        )
    }
    
    /// Secondary button.
    public static func secondary(
        isEnabled: Bool = true,
        action: @escaping () -> Void,
        title: String
    ) -> Self {
        .init(
            dialogButton: .secondary,
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
            dialogButton: .destructive,
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
            dialogButton: .cancel,
            isEnabled: isEnabled,
            action: action,
            title: title ?? VComponentsLocalizationService.shared.localizationProvider.vDialogCancelButtonTitle
        )
    }
    
    private static func ok() -> Self {
        .init(
            dialogButton: .ok,
            isEnabled: true,
            action: nil,
            title: VComponentsLocalizationService.shared.localizationProvider.vDialogOKButtonTitle
        )
    }
    
    // MARK: Processing
    static func process(_ buttons: [Self]) -> [Self] {
        var result: [VDialogButton] = .init()
        
        for button in buttons {
            if button._dialogButton == .cancel { result.removeAll(where: { $0._dialogButton == .cancel }) }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { $0._dialogButton == .cancel }) {
            result.append(result.remove(at: cancelButtonIndex))
        }
        
        if result.isEmpty {
            result.append(.ok())
        }
        
        return result
    }
}

// MARK: - _ V Dialog Button
enum _VDialogButton {
    case primary
    case secondary
    case destructive
    case cancel
    case ok // Not accessible from outside
}
