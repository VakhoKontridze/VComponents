//
//  VSpinnerParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Spinner Parameters
/// Parameters for presenting an `VSpinner`.
///
/// Done in the style of `ProgressViewParameters` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Progress%20View/ProgressViewParameters.swift) .
///
/// In `MVP`, `VIP`, and `VIPER` architectures, parameters are stored in `Presenter`.
/// in `MVVM` architecture, parameters are stored in`ViewModel.`
public struct VSpinnerParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public let id: UUID = .init()
    
    /// Indicates if interaction is disabled.
    public var isInteractionDisabled: Bool
    
    // MARK: Initializers
    /// Initializes `VSpinnerParameters`.
    public init(isInteractionDisabled: Bool) {
        self.isInteractionDisabled = isInteractionDisabled
    }
}
