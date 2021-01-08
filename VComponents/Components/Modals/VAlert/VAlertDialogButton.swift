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
    public var title: String
    public var action: () -> Void
    
    // MARK: Initializers
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
}
