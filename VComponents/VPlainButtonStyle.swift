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
        contentView(label: configuration.label, actualState: actualState(configuration: configuration))
            .padding(.horizontal, viewModel.layout.hitAreaOffsetHor)
            .padding(.vertical, viewModel.layout.hitAreaOffsetVer)
    }
    
    private func contentView(label: ButtonStyleConfiguration.Label, actualState: VPlainButtonStyleActualState) -> some View {
        label
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(VPlainButtonViewModel.Colors.foreground(state: actualState, vm: viewModel))
            .font(viewModel.fonts.title)
    }
}

// MARK:- Actual State
private enum VPlainButtonStyleActualState {
    case enabled
    case pressed
    case disabled
}

private extension VPlainButtonStyle {
    func actualState(configuration: Configuration) -> VPlainButtonStyleActualState {
        if configuration.isPressed && state.shouldBeEnabled {
            return .pressed
        } else {
            switch state {
            case .enabled: return .enabled
            case .disabled: return .disabled
            }
        }
    }
}

// MARK:- ViewModel Mapping
private extension VPlainButtonViewModel.Colors {
    static func foreground(state: VPlainButtonStyleActualState, vm: VPlainButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        }
    }
}
