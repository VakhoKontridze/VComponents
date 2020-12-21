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
    private let model: VSpinnerModel
    
    // MARK: Initializers
    public init(
        type spinnerType: VSpinnerType,
        model: VSpinnerModel = .init()
    ) {
        self.spinnerType = spinnerType
        self.model = model
    }
}

// MARK:- Body
public extension VSpinner {
    @ViewBuilder var body: some View {
        switch spinnerType {
        case .continous: continousSpinner
        case .dashed: dashedSpinner
        }
    }
    
    private var continousSpinner: some View {
        VContinousSpinner(model: model)
    }
    
    private var dashedSpinner: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: model.colors.spinner))
    }
}

// MARK:- Preview
struct VSpinner_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            Color.blue
            VSpinner(type: .continous)
        })
            .frame(width: .infinity, height: .infinity)
            .edgesIgnoringSafeArea(.bottom)
    }
}
