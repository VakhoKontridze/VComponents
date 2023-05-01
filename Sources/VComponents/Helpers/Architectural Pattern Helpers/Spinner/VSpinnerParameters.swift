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
/// In `MVP`, `VIP`, and `VIPER` architectures, parameters are stored in `Presenter`.
/// in `MVVM` architecture, parameters are stored in`ViewModel.`
///
///     @State private var parameters: VSpinnerParameters = .init()
///
///     var body: some View {
///         content
///             .vContinuousSpinner(parameters: parameters)
///     }
///
public struct VSpinnerParameters: Identifiable {
    // MARK: Properties
    /// ID.
    public let id: UUID = .init()
    
    /// Indicates if interaction is enabled.
    public var isInteractionEnabled: Bool
    
    // MARK: Initializers
    /// Initializes `VSpinnerParameters`.
    public init(
        isInteractionEnabled: Bool = true
    ) {
        self.isInteractionEnabled = isInteractionEnabled
    }
}
