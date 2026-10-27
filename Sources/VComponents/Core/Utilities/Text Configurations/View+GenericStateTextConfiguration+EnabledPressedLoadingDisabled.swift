//
//  View+GenericStateTextConfiguration+EnabledPressedLoadingDisabled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

public import SwiftUI
public import VCore

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///     let state: GenericState_EnabledPressedLoadingDisabled = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration, state: state)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledPressedLoadingDisabled<Color>
        >,
        state: GenericState_EnabledPressedLoadingDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
