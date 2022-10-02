//
//  VSpinnerExtension_Parameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Spinner Extension (Parameters)
extension View {
    /// Presents `VSpinner` when `VSpinnerParameters` is non-`nil`.
    ///
    /// Done in the style of `View.progressView(parameters:)` from `VCore`.
    /// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Progress%20View/ProgressViewExtension.swift) .
    @ViewBuilder public func vSpinner(
        parameters: VSpinnerParameters?
    ) -> some View {
        switch parameters {
        case nil:
            self
            
        case let parameters?:
            self
                .if(parameters.isInteractionDisabled, transform: {
                    $0
                        .overlay(Color.clear.contentShape(Rectangle()))
                })
                .overlay(
                    VSpinner(type: parameters.spinnerType)
                )
        }
    }
}
