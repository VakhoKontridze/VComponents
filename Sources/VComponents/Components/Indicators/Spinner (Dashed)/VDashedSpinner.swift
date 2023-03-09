//
//  VDashedSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Dashed Spinner
/// Indicator component that indicates activity.
///
/// UI model can be passed as parameter.
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
            .progressViewStyle(CircularProgressViewStyle(tint: uiModel.colors.spinner))
    }
}

// MARK: - Preview
struct VDashedSpinner_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VDashedSpinner()
            })
        }
    }
}
