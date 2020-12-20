//
//  VPlainButtonStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button Style
struct VPlainButtonStyle: ButtonStyle {
    // MARK: Properties
    private let state: VPlainButtonState
    private let viewModel: VPlainButtonViewModel
    
    // MARK: Initializers
    init(state: VPlainButtonState, viewModel: VPlainButtonViewModel) {
        self.state = state
        self.viewModel = viewModel
    }
}

// MARK:- Style
extension VPlainButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        contentView(label: configuration.label, actualState: state.actualState(configuration: configuration))
            .padding(.horizontal, viewModel.layout.hitAreaOffsetHor)
            .padding(.vertical, viewModel.layout.hitAreaOffsetVer)
    }
    
    private func contentView(label: ButtonStyleConfiguration.Label, actualState: VPlainButtonActualState) -> some View {
        label
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(VPlainButtonViewModel.Colors.foreground(state: actualState, vm: viewModel))
            .opacity(VPlainButtonViewModel.Colors.foregroundOpacity(state: actualState, vm: viewModel))
            .font(viewModel.fonts.title)
    }
}
