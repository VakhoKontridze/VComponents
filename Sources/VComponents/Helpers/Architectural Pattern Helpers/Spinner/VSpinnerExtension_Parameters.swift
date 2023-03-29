//
//  VSpinnerExtension_Parameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI
import VCore

// MARK: - V Spinner Extension (Parameters)
extension View {
    /// Presents `VContinuousSpinner` when `VSpinnerParameters` is non-`nil`.
    ///
    /// Done in the style of `View.progressView(parameters:)` from `VCore`.
    /// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Progress%20View/ProgressViewExtension.swift) .
    @ViewBuilder public func vContinuousSpinner(
        uiModel: VContinuousSpinnerUIModel = .init(),
        parameters: VSpinnerParameters?
    ) -> some View {
        switch parameters {
        case nil:
            self
            
        case let parameters?:
            self
                .blocksHitTesting(!parameters.isInteractionEnabled)
                .overlay(VContinuousSpinner(uiModel: uiModel))
        }
    }
    
    /// Presents `VDashedSpinner` when `VSpinnerParameters` is non-`nil`.
    ///
    /// Done in the style of `View.progressView(parameters:)` from `VCore`.
    /// For additional info, refer to [documentation](https://github.com/VakhoKontridze/VCore/blob/main/Sources/VCore/Helpers/Architectural%20Pattern%20Helpers/SwiftUI/Progress%20View/ProgressViewExtension.swift) .
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @ViewBuilder public func vDashedSpinner(
        uiModel: VDashedSpinnerUIModel = .init(),
        parameters: VSpinnerParameters?
    ) -> some View {
        switch parameters {
        case nil:
            self
            
        case let parameters?:
            self
                .blocksHitTesting(!parameters.isInteractionEnabled)
                .overlay(VDashedSpinner(uiModel: uiModel))
        }
    }
}
