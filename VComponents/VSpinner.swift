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
    
    private let viewModel: VSpinnerViewModel
    
    // MARK: Initializers
    public init(
        type spinnerType: VSpinnerType,
        viewModel: VSpinnerViewModel
    ) {
        self.spinnerType = spinnerType
        self.viewModel = viewModel
    }
}

// MARK:- Body
public extension VSpinner {
    @ViewBuilder var body: some View {
        if spinnerType == .dashed {
            dashedSpinner
        } else if spinnerType == .continous {
            continousSpinner
        }
    }
    
    private var dashedSpinner: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: viewModel.colors.spinner))
    }
    
    private var continousSpinner: some View {
        VContinousSpinner(viewModel: viewModel)
    }
}

// MARK:- Preview
private struct VSpinner_Previews: PreviewProvider {
    static var previews: some View {
        VSpinner(type: .continous, viewModel: .init())
    }
}
