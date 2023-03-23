//
//  VConfirmationDialogParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Parameters
/// Parameters for presenting a `VConfirmationDialog`.
///
/// Done in the style of `VConfirmationDialogParameters` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Confirmation%20Dialog/ConfirmationDialogParameters.swift) .
///
/// In `MVP`, `VIP`, and `VIPER` architectures, parameters are stored in`Presenter`.
/// in `MVVM` architecture, parameters are stored in `ViewModel.`
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct VConfirmationDialogParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public let id: UUID = .init()
    
    /// Title.
    public var title: String?
    
    /// Message.
    public var message: String?
    
    /// Buttons.
    public var buttons: () -> [any VConfirmationDialogButtonProtocol]
    
    // MARK: Initializers
    /// Initializes `ConfirmationDialogParameters`.
    public init(
        title: String?,
        message: String?,
        @VConfirmationDialogButtonBuilder actions buttons: @escaping () -> [any VConfirmationDialogButtonProtocol]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}
