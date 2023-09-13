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
    ///     @State private var parameters: VSpinnerParameters = .init()
    ///
    ///     var body: some View {
    ///         content
    ///             .vContinuousSpinner(parameters: parameters)
    ///     }
    ///
    public func vContinuousSpinner(
        uiModel: VContinuousSpinnerUIModel = .init(),
        parameters: VSpinnerParameters?
    ) -> some View {
        self
            .blocksHitTesting(parameters?.isInteractionEnabled == false)
            .overlay(content: {
                if parameters != nil {
                    VContinuousSpinner(uiModel: uiModel)
                }
            })
    }
    
    /// Presents `VDashedSpinner` when `VSpinnerParameters` is non-`nil`.
    ///
    ///     @State private var parameters: VSpinnerParameters = .init()
    ///
    ///     var body: some View {
    ///         content
    ///             .vDashedSpinner(parameters: parameters)
    ///     }
    ///
    public func vDashedSpinner(
        uiModel: VDashedSpinnerUIModel = .init(),
        parameters: VSpinnerParameters?
    ) -> some View {
        self
            .blocksHitTesting(parameters?.isInteractionEnabled == false)
            .overlay(content: {
                if parameters != nil {
                    VDashedSpinner(uiModel: uiModel)
                }
            })
    }
}
