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
/// Done in the style of `AlertPresentable` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Alert/AlertPresentable.swift) .
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
///                 .vAlert(
///                     id: "some_alert",
///                     parameters: $presenter.vAlertParameters
///                 )
///         }
///     }
///
///     final class Presenter: ObservableObject, VAlertPresentable {
///         @Published var vAlertParameters: VAlertParameters?
///
///         func didTapButton() {
///             vAlertParameters = VAlertParameters(
///                 title: "Lorem Ipsum",
///                 message: "Lorem ipsum dolor sit amet",
///                 actions: {
///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
///                     VAlertCancelButton(action: { print("Cancelled") })
///                 }
///             )
///         }
///     }
///
@MainActor public protocol VAlertPresentable: ObservableObject {
    /// `VAlertParameters`.
    var vAlertParameters: VAlertParameters? { get set }
}
