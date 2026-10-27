//
//  View+GenericStateTextConfiguration+OffOnIndeterminatePressedDisabled.swift
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
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_OffOnIndeterminatePressedDisabled<Color>
        >,
        state: GenericState_OffOnIndeterminatePressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
