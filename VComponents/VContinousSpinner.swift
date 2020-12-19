//
//  VContinousSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK:- V Continous Spinner
struct VContinousSpinner: View {
    // MARK: Properties
    @State private var isAnimating: Bool = false
    
    private let animationDuration: Double = 0.75
    
    private let viewModel: VSpinnerViewModel
    
    // MARK: Initializers
    init(viewModel: VSpinnerViewModel) {
        self.viewModel = viewModel
    }
}

// MARK:- Body
extension VContinousSpinner {
    var body: some View {
        Circle()
            .trim(from: 0, to: viewModel.layout.legth)
            .stroke(
                viewModel.colors.spinner,
                style: .init(lineWidth: viewModel.layout.thickness, lineCap: .round)
            )
            .frame(width: viewModel.layout.dimension, height: viewModel.layout.dimension)
            .rotationEffect(.init(degrees: isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false))
            .onAppear(perform: { isAnimating.toggle() })
    }
}
