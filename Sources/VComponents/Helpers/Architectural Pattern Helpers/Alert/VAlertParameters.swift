//
//  VAlertParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Alert Parameters
/// Parameters for presenting a `VAlert`.
///
/// Done in the style of `VAlertParameters` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Alert/AlertParameters.swift) .
///
/// In `MVP`, `VIP`, and `VIPER` architectures, parameters are stored in`Presenter`.
/// in `MVVM` architecture, parameters are stored in `ViewModel.`
public struct VAlertParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public let id: UUID = .init()
    
    /// Title.
    public var title: String
    
    /// Message.
    public var message: String?
    
    /// Buttons.
    public var buttons: () -> [any VAlertButtonProtocol]
    
    // MARK: Parameters
    /// Initializes `VAlertParameters`.
    public init(
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }

    /// Initializes `VAlertParameters` with "ok" action.
    public init(
        title: String,
        message: String?,
        completion: (() -> Void)?
    ) {
        self.init(
            title: title,
            message: message,
            actions: {
                VAlertCancelButton(action: completion)
            }
        )
    }

    /// Initializes `VAlertParameters` with error and "ok" action.
    public init(
        error: some Error,
        completion: (() -> Void)?
    ) {
        self.init(
            title: VComponentsLocalizationService.shared.localizationProvider.vAlertErrorTitle,
            message: error.localizedDescription,
            actions: {
                VAlertOKButton(action: completion)
            }
        )
    }
}
