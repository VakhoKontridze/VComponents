//
//  Image+GenericStateImageConfiguration+EnabledPressedFocusedDisabled.swift
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
    ///     let state: GenericState_EnabledFocusedDisabled = ...
    ///
    ///     var body: some View {
    ///         Image(...)
    ///             .imageConfiguration(configuration, state: state)
    ///     }
    ///
    public func imageConfiguration(
        _ configuration: GenericStateImageConfiguration<
            GenericStateModel_EnabledFocusedDisabled<Color>,
            GenericStateModel_EnabledFocusedDisabled<CGFloat>
        >,
        state: GenericState_EnabledFocusedDisabled
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
