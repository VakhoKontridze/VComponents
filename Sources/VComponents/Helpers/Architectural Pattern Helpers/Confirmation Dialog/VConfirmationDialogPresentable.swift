//
//  VConfirmationDialogPresentable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Presentable
/// Protocol for presenting a `VConfirmationDialog`.
///
/// Done in the style of `ConfirmationDialogPresentable` from `VCore`.
/// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Confirmation%20Dialog/ConfirmationDialogPresentable.swift) .
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
///                 .vConfirmationDialog(parameters: $presenter.vConfirmationDialogParameters)
///         }
///     }
///
///     final class Presenter: ObservableObject, VConfirmationDialogPresentable {
///         @Published var vConfirmationDialogParameters: VConfirmationDialogParameters?
///
///         func didTapButton() {
///             vConfirmationDialogParameters = VConfirmationDialogParameters(
///                 title: "Lorem Ipsum",
///                 message: "Lorem ipsum dolor sit amet",
///                 actions: {
///                     VConfirmationDialogButton(action: { print("Confirmed") }, title: "Confirm")
///                     VConfirmationDialogCancelButton(action: { print("Cancelled") })
///                 }
///             )
///         }
///     }
///
@MainActor public protocol VConfirmationDialogPresentable: ObservableObject {
    /// `VConfirmationDialogParameters`.
    var vConfirmationDialogParameters: VConfirmationDialogParameters? { get set }
}
