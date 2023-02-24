//
//  VSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK: - V Spinner
/// Indicator component that indicates activity.
///
/// Type can be passed as parameter.
///
///     var body: some View {
///         VSpinner()
///     }
///
public struct VSpinner: View {
    // MARK: Properties
    private let spinnerType: VSpinnerType
    
    // MARK: Initializers
    /// Initializes component with type.
    public init(
        type spinnerType: VSpinnerType = .default
    ) {
        self.spinnerType = spinnerType
    }

    // MARK: Body
    public var body: some View {
        switch spinnerType._spinnerType {
        case .continuous(let uiModel): VSpinnerContinuous(uiModel: uiModel)
        case .dashed(let uiModel): VSpinnerDashed(uiModel: uiModel)
        }
    }
}

// MARK: - Preview
struct VSpinner_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            VSpinner(type: .continuous())
            VSpinner(type: .dashed())
        })
    }
}
