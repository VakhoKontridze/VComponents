//
//  View+GenericStateTextConfiguration+OffOnPressedDisabled.swift
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
    ///     let state: GenericState_OffOnPressedDisabled = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration, state: state)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_OffOnPressedDisabled<Color>
        >,
        state: GenericState_OffOnPressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
