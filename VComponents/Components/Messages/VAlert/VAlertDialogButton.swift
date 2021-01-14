//
//  VAlertDialogButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import Foundation

// MARK:- V Alert Dialog Button
/// Data source that creates alert dialog button
public struct VAlertDialogButton {
    // MARK: Properties
    public var model: VAlertDialogButtonModel
    public var isEnabled: Bool
    public var title: String
    public var action: () -> Void
    
    // MARK: Initializers
    /// Initializes data source
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - isEnabled: Bool that describes state
    ///   - title: Title that describes purpose of the action
    ///   - action: Action to perform when the user triggers button
    public init(
        model: VAlertDialogButtonModel,
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
