//
//  VAlertExtension_Parameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Alert Extension (Parameters)
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents `VAlert` when `VAlertParameters` is non-`nil`.
    ///
    /// Done in the style of `View.alert(parameters:)` from `VCore`.
    /// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Alert/AlertExtension.swift) .
    public func vAlert(
        id: String,
        uiModel: VAlertUIModel = .init(),
        parameters: Binding<VAlertParameters?>
    ) -> some View {
        vAlert(
            id: id,
            uiModel: uiModel,
            item: parameters,
            title: { $0.title },
            message: { $0.message },
            actions: { $0.buttons() }
        )
    }
}
