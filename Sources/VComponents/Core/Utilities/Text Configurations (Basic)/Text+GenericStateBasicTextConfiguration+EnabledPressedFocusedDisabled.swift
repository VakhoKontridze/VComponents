//
//  Text+GenericStateBasicTextConfiguration+EnabledPressedFocusedDisabled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

public import SwiftUI
public import VCore

// Needs to be extended on `Text` and to return `Text` to keep identity for `TextField`

extension Text {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateBasicTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateBasicTextConfiguration<
            GenericStateModel_EnabledFocusedDisabled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled
    ) -> Text {
        self
            .textConfiguration(
                configuration.toBasicTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
