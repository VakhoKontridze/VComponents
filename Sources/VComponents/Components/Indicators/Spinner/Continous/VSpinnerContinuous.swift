//
//  VSpinnerContinuous.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK: - V Spinner Continuous
struct VSpinnerContinuous: View {
    // MARK: Properties
    private let uiModel: VSpinnerContinuousUIModel
    
    @State private var isAnimating: Bool = false
    
    // MARK: Initializers
    init(uiModel: VSpinnerContinuousUIModel) {
        self.uiModel = uiModel
    }

    // MARK: Body
    var body: some View {
        Circle()
            .trim(from: 0, to: uiModel.layout.length)
            .stroke(
                uiModel.colors.spinner,
                style: .init(lineWidth: uiModel.layout.borderWidth, lineCap: .round)
            )
            .frame(width: uiModel.layout.dimension, height: uiModel.layout.dimension)
            .rotationEffect(.init(degrees: isAnimating ? 360 : 0))
            .onAppear(perform: {
                DispatchQueue.main.async(execute: {
                    withAnimation(uiModel.animations.spinning.repeatForever(autoreverses: false), {
                        isAnimating.toggle()
                    })
                })
            })
    }
}

struct VSpinnerContinuous_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerContinuous(uiModel: .init())
    }
}