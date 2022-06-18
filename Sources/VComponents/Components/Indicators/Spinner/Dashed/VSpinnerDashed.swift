//
//  VSpinnerDashed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Spinner Dashed
struct VSpinnerDashed: View {
    // MARK: Properties
    private let uiModel: VSpinnerDashedUIModel
    
    // MARK: Initializers
    init(uiModel: VSpinnerDashedUIModel) {
        self.uiModel = uiModel
    }

    // MARK: Body
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: uiModel.colors.spinner))
    }
}

// MARK: - Preview
struct VSpinnerDashed_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDashed(uiModel: .init())
    }
}
