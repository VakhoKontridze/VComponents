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
        viewModel: VSpinnerViewModel = .init()
    ) {
        self.spinnerType = spinnerType
        self.viewModel = viewModel
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
        VContinousSpinner(viewModel: viewModel)
    }
    
    private var dashedSpinner: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: viewModel.colors.spinner))
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
