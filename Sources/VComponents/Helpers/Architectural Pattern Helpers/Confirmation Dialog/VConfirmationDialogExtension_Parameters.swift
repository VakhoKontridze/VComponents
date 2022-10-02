//
//  VConfirmationDialogExtension_Parameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Extension (Parameters)
extension View {
    /// Presents `VConfirmationDialog` when `VConfirmationDialogParameters` is non-`nil`.
    ///
    /// Done in the style of `View.confirmationDialog(parameters:)` from `VCore`.
    /// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Confirmation%20Dialog/ConfirmationDialogExtension.swift) .
    public func vConfirmationDialog(
        parameters: Binding<VConfirmationDialogParameters?>
    ) -> some View {
        vConfirmationDialog(
            item: parameters,
            title: { $0.title },
            message: { $0.message },
            actions: { $0.buttons() }
        )
    }
}
