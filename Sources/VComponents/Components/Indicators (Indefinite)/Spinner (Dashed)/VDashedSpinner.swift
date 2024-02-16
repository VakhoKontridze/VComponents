//
//  VDashedSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Dashed Spinner
/// Indicator component that represents indefinite activity.
///
///     var body: some View {
///         VDashedSpinner()
///     }
///
public struct VDashedSpinner: View {
    // MARK: Properties
    private let uiModel: VDashedSpinnerUIModel
    
    // MARK: Initializers
    /// Initializes `VDashedSpinner`
    public init(
        uiModel: VDashedSpinnerUIModel = .init()
    ) {
        self.uiModel = uiModel
    }
    
    // MARK: Body
    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(uiModel.color)
    }
}

// MARK: - Preview
#if DEBUG

#Preview(body: {
    PreviewContainer(content: {
        VDashedSpinner()
    })
})

#endif
