//
//  VDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Dialog Button
/// Data source that creates dialog buttons
public struct VDialogButton {
    // MARK: Properties
    public var model: VDialogButtonModel
    public var isEnabled: Bool
    public var title: String
    public var action: () -> Void
    
    // MARK: Initializers
    public init(
        model: VDialogButtonModel,
        isEnabled: Bool = true,
        title: String,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.isEnabled = isEnabled
        self.title = title
        self.action = action
    }
}
