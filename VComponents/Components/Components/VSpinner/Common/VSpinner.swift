//
//  VSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK:- V Spinner
public struct VSpinner: View {
    // MARK: Proeprties
    private let model: VSpinnerModel
    
    // MARK: Initializers
    public init(
        model: VSpinnerModel = .default
    ) {
        self.model = model
    }
}

// MARK:- Body
extension VSpinner {
    @ViewBuilder public var body: some View {
        switch model {
        case .continous(let model): VSpinnerContinous(model: model)
        case .dashed(let model): VSpinnerDashed(model: model)
        }
    }
}

// MARK:- Preview
struct VSpinner_Previews: PreviewProvider {
    static var previews: some View {
        VSpinner()
    }
}
