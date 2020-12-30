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
    public let title: String
    public let action: () -> Void
    
    // MARK: Initializers
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
}
