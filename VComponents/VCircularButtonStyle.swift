//
//  VCircularButtonStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Circular Button Style
struct VCircularButtonStyle: ButtonStyle {
    // MARK: Properties
    private let state: VCircularButtonState
    private let viewModel: VCircularButtonViewModel
    
    // MARK: Initializers
    init(state: VCircularButtonState, viewModel: VCircularButtonViewModel) {
        self.state = state
        self.viewModel = viewModel
    }
}

// MARK:- Style
extension VCircularButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        contentView(label: configuration.label, actualState: state.actualState(configuration: configuration))
            .frame(width: viewModel.layout.dimension, height: viewModel.layout.dimension)
    
            .background(backgroundView(actualState: state.actualState(configuration: configuration)))
    }
    
    private func contentView(label: ButtonStyleConfiguration.Label, actualState: VRoundedButtonActualState) -> some View {
        label
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(VCircularButtonViewModel.Colors.foreground(state: actualState, vm: viewModel))
            .font(viewModel.fonts.title)
    }
    
    private func backgroundView(actualState: VRoundedButtonActualState) -> some View {
        Circle()
            .foregroundColor(VCircularButtonViewModel.Colors.background(state: actualState, vm: viewModel))
    }
}
