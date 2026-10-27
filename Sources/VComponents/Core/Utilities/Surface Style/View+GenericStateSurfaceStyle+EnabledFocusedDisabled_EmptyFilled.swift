//
//  View+GenericStateSurfaceStyle+EnabledFocusedDisabled_EmptyFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 27/10/26.
//

public import SwiftUI
public import VCore

extension View {
    /// Draws `GenericStateSurfaceStyle` behind the `View`, within shape, with colors resolved for state.
    ///
    /// Content is not clipped to shape.
    ///
    ///     let style: GenericStateSurfaceStyle<GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Color>> = ...
    ///     let state: GenericState_EnabledFocusedDisabled_EmptyFilled = ...
    ///
    ///     var body: some View {
    ///         contentView
    ///             .surfaceStyle(style, state: state, in: .capsule)
    ///     }
    ///
    public func surfaceStyle(
        _ surfaceStyle: GenericStateSurfaceStyle<
            GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled_EmptyFilled,
        in shape: some Shape
    ) -> some View {
        self
            .surfaceStyle(
                surfaceStyle.toSurfaceStyle(resolveColor: { $0.value(for: state) }),
                in: shape
            )
    }
}
