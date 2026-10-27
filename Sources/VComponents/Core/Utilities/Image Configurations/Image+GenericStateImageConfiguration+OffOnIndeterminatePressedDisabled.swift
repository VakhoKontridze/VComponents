//
//  Image+GenericStateImageConfiguration+OffOnIndeterminatePressedDisabled.swift
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
    ///
    ///     var body: some View {
    ///         Image(...)
    ///             .imageConfiguration(configuration)
    ///     }
    ///
    public func imageConfiguration(
        _ configuration: GenericStateImageConfiguration<
            GenericStateModel_OffOnIndeterminatePressedDisabled<Color>,
            GenericStateModel_OffOnIndeterminatePressedDisabled<CGFloat>
        >,
        state: GenericState_OffOnIndeterminatePressedDisabled
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
