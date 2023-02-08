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
    
    /// UI model.
    public var uiModel: VAlertUIModel
    
    /// Title.
    public var title: String
    
    /// Message.
    public var message: String?
    
    /// Buttons.
    public var buttons: () -> [any VAlertButtonProtocol]
    
    // MARK: Parameters
    /// Initializes `VAlertParameters`.
    public init(
        uiModel: VAlertUIModel = .init(),
        title: String,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) {
        self.uiModel = uiModel
        self.title = title
        self.message = message
        self.buttons = buttons
    }

    /// Initializes `VAlertParameters` with "ok" action.
    public init(
        uiModel: VAlertUIModel = .init(),
        title: String,
        message: String?,
        completion: (() -> Void)?
    ) {
        self.init(
            uiModel: uiModel,
            title: title,
            message: message,
            actions: {
                VAlertCancelButton(action: completion)
            }
        )
    }

    /// Initializes `VAlertParameters` with error and "ok" action.
    public init(
        uiModel: VAlertUIModel = .init(),
        error: some Error,
        completion: (() -> Void)?
    ) {
        self.init(
            uiModel: uiModel,
            title: VComponentsLocalizationManager.shared.localizationProvider.vAlertErrorTitle,
            message: error.localizedDescription,
            actions: {
                VAlertOKButton(action: completion)
            }
        )
    }
}
