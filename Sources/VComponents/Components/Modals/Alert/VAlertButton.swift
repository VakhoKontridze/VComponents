//
//  VAlertButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK: - V Alert Button
/// Model that represents `VAlert` button, such as `primary`, `secondary`, `destructive`, or `cancel`.
///
/// `cancel` will be moved to the end of the stack.
/// If there are multiple `cancel` buttons, only the last one will be kept.
/// If there are no buttons, an `ok` button will be added.
public struct VAlertButton {
    // MARK: Properties
    let _alertButton: _VAlertButton
    let isEnabled: Bool
    let action: (() -> Void)?
    let title: String
    
    // MARK: Initializers
    private init(
        alertButton: _VAlertButton,
        isEnabled: Bool,
        action: (() -> Void)?,
        title: String
    ) {
        self._alertButton = alertButton
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
            alertButton: .primary,
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
            alertButton: .secondary,
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
            alertButton: .destructive,
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
            alertButton: .cancel,
            isEnabled: isEnabled,
            action: action,
            title: title ?? VComponentsLocalizationService.shared.localizationProvider.vAlertCancelButtonTitle
        )
    }
    
    private static func ok() -> Self {
        .init(
            alertButton: .ok,
            isEnabled: true,
            action: nil,
            title: VComponentsLocalizationService.shared.localizationProvider.vAlertOKButtonTitle
        )
    }
    
    // MARK: Processing
    static func process(_ buttons: [Self]) -> [Self] {
        var result: [VAlertButton] = .init()
        
        for button in buttons {
            if button._alertButton == .cancel { result.removeAll(where: { $0._alertButton == .cancel }) }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { $0._alertButton == .cancel }) {
            result.append(result.remove(at: cancelButtonIndex))
        }
        
        if result.isEmpty {
            result.append(.ok())
        }
        
        return result
    }
}

// MARK: - _ V Alert Button
enum _VAlertButton {
    case primary
    case secondary
    case destructive
    case cancel
    case ok // Not accessible from outside
}
