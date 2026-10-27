//
//  Image+GenericStateImageConfiguration+EnabledPressedDisabled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

public import SwiftUI
public import VCore

// Needs to be extended on `Image` for several modifiers to work

extension Image {
    /// Applies `GenericStateImageConfiguration`.
    ///
    ///     let configuration: GenericStateImageConfiguration<...> = ...
    ///     let state: GenericState_EnabledPressedDisabled = ...
    ///
    ///     var body: some View {
    ///         Image(...)
    ///             .imageConfiguration(configuration, state: state)
    ///     }
    ///
    public func imageConfiguration(
        _ configuration: GenericStateImageConfiguration<
            GenericStateModel_EnabledPressedDisabled<Color>,
            GenericStateModel_EnabledPressedDisabled<CGFloat>
        >,
        state: GenericState_EnabledPressedDisabled
    ) -> some View {
        self
            .imageConfiguration(
                configuration.toImageConfiguration(
                    color: configuration.colors?.value(for: state),
                    opacity: configuration.opacities?.value(for: state)
                )
            )
    }
}
