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
    private let spinnerType: VSpinnerType
    
    // MARK: Initializers
    public init(
        type spinnerType: VSpinnerType = .default
    ) {
        self.spinnerType = spinnerType
    }
}

// MARK:- Body
public extension VSpinner {
    @ViewBuilder var body: some View {
        switch spinnerType {
        case .continous(let model): VSpinnerContinous(model: model)
        case .dashed(let model): VSpinnerDashed(model: model)
        }
    }
}

// MARK:- Preview
struct VSpinner_Previews: PreviewProvider {
    static var previews: some View {
        VSpinner(type: .continous())
    }
}
