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
    private let model: VSpinnerModel
    
    @State private var isAnimating: Bool = false
    
    // MARK: Initializers
    init(model: VSpinnerModel) {
        self.model = model
    }
}

// MARK:- Body
extension VContinousSpinner {
    var body: some View {
        Circle()
            .trim(from: 0, to: model.layout.legth)
            .stroke(
                model.colors.spinner,
                style: .init(lineWidth: model.layout.thickness, lineCap: .round)
            )
            .frame(width: model.layout.dimension, height: model.layout.dimension)
            .rotationEffect(.init(degrees: isAnimating ? 360 : 0))
            .animation(model.behavior.animation.repeatForever(autoreverses: false))
            .onAppear(perform: { isAnimating.toggle() })
    }
}
