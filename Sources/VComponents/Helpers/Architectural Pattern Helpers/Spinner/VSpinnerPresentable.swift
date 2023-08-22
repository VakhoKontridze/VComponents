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
/// In `MVP`, `VIP`, and `VIPER` architectures, this protocol is conformed to by a `Presenter`.
/// in `MVVM` architecture, this protocol is conformed to by a `ViewModel`.
///
///     struct ContentView: View {
///         @StateObject private var presenter: Presenter = .init()
///
///         var body: some View {
///             VPlainButton(
///                 action: { presenter.didTapButton() },
///                 title: "Lorem ipsum"
///             )
///             .vContinuousSpinner(parameters: presenter.vSpinnerParameters)
///         }
///     }
///
///     @MainActor final class Presenter: ObservableObject, VSpinnerPresentable {
///         @Published var vSpinnerParameters: VSpinnerParameters?
///
///         func didTapButton() {
///             vSpinnerParameters = VSpinnerParameters()
///
///             Task(operation: {
///                 ...
///
///                 do {
///                     let (data, response) = try await URLSession.shared.data(for: request)
///                     vSpinnerParameters = nil
///
///                     ...
///
///                 } catch {
///                     vSpinnerParameters = nil
///
///                     ...
///                 }
///             })
///         }
///     }
///
@MainActor public protocol VSpinnerPresentable: ObservableObject {
    /// `VSpinnerParameters`.
    var vSpinnerParameters: VSpinnerParameters? { get set }
}
