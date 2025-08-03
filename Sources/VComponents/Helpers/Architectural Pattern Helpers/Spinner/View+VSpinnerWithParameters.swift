//
//  View+VSpinnerWithParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI
import VCore

extension View {
    /// Presents `VContinuousSpinner` when `parameters` is non-`nil`.
    ///
    ///     @State private var parameters: VSpinnerParameters = .init()
    ///
    ///     var body: some View {
    ///         content
    ///             .vContinuousSpinner(parameters: parameters)
    ///     }
    ///
    public func vContinuousSpinner(
        parameters: VSpinnerParameters?
    ) -> some View {
        self
            .blocksHitTesting(parameters?.isInteractionEnabled == false)
            .overlay {
                if let parameters {
                    VContinuousSpinner(appearance: parameters.appearance)
                }
            }
    }
}
