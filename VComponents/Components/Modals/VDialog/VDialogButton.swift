//
//  VDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Dialog Button
/// ViewModel that creates `VDialog` buttons
public struct VDialogButton {
    // MARK: Properties
    public var model: VDialogButtonModel
    public var isEnabled: Bool
    public var title: String
    public var action: () -> Void
    
    // MARK: Initializers
    /// Initializes data source with model, title, and action
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
