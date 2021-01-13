//
//  VAlertDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Alert Dialog Button
public struct VAlertDialogButton {
    // MARK: Properties
    public var isEnabled: Bool
    public var title: String
    public var action: () -> Void
    
    // MARK: Initializers
    public init(
        isEnabled: Bool = true,
        title: String,
        action: @escaping () -> Void
    ) {
        self.isEnabled = isEnabled
        self.title = title
        self.action = action
    }
}
