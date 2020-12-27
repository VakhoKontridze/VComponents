//
//  VSpinnerDashed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Spinner Dashed
struct VSpinnerDashed: View {
    // MARK: Properties
    private let model: VSpinnerModelDashed
    
    // MARK: Initializers
    init(model: VSpinnerModelDashed) {
        self.model = model
    }
}

// MARK:- Body
extension VSpinnerDashed {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: model.colors.spinner))
    }
}

// MARK:- Preview
struct VSpinnerDashed_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDashed(model: .init())
    }
}
