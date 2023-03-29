//
//  VSpinnerPresentable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Spinner Presentable
/// Protocol for presenting a `VSpinner`.
///
/// Done in the style of `ProgressViewPresentable` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Progress%20View/ProgressViewPresentable.swift) .
///
/// In `MVP`, `VIP`, and `VIPER` architectures, this protocol is conformed to by a `Presenter`.
/// in `MVVM` architecture, this protocol is conformed to by a `ViewModel.`
///
///     struct ContentView: View {
///         @StateObject private var presenter: Presenter = .init()
///
///         var body: some View {
///             VPlainButton(
///                 action: { presenter.didTapButton() },
///                 title: "Lorem ipsum"
///             )
///                 .vContinuousSpinner(parameters: presenter.vSpinnerParameters)
///         }
///     }
///
///     final class Presenter: ObservableObject, VSpinnerPresentable {
///         @Published var vSpinnerParameters: VSpinnerParameters?
///
///         func didTapButton() {
///             vSpinnerParameters = VSpinnerParameters(isInteractionDisabled: true)
///             DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in self?.vSpinnerParameters = nil })
///         }
///     }
///
@MainActor public protocol VSpinnerPresentable: ObservableObject {
    /// `VSpinnerParameters`.
    var vSpinnerParameters: VSpinnerParameters? { get set }
}
