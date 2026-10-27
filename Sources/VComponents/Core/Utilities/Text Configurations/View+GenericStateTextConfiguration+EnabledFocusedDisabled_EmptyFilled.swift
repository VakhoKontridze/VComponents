//
//  View+GenericStateTextConfiguration+EnabledFocusedDisabled_EmptyFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

public import SwiftUI

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///     let state: GenericState_EnabledFocusedDisabled_EmptyFilled = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration, state: state)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled_EmptyFilled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
