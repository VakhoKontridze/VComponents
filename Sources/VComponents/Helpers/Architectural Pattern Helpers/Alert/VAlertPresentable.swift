//
//  VAlertPresentable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Alert Presentable
/// Protocol for presenting a `VAlert`.
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
///             .vAlert(
///                 id: "some_alert",
///                 parameters: $presenter.vAlertParameters
///             )
///         }
///     }
///
///     @MainActor final class Presenter: ObservableObject, VAlertPresentable {
///         @Published var vAlertParameters: VAlertParameters?
///
///         func didTapButton() {
///             vAlertParameters = VAlertParameters(
///                 title: "Lorem Ipsum",
///                 message: "Lorem ipsum dolor sit amet",
///                 actions: {
///                     VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
///                     VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
///                 }
///             )
///         }
///     }
///
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@MainActor public protocol VAlertPresentable: ObservableObject {
    /// `VAlertParameters`.
    var vAlertParameters: VAlertParameters? { get set }
}
