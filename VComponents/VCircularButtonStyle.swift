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
        contentView(label: configuration.label, actualState: actualState(configuration: configuration))
            .frame(width: viewModel.layout.dimension, height: viewModel.layout.dimension)
    
            .background(backgroundView(actualState: actualState(configuration: configuration)))
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

// MARK:- Actual State
private enum VRoundedButtonActualState {
    case enabled
    case pressed
    case disabled
}

private extension VCircularButtonStyle {
    func actualState(configuration: Configuration) -> VRoundedButtonActualState {
        if configuration.isPressed && state.isEnabled {
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
private extension VCircularButtonViewModel.Colors {
    static func foreground(state: VRoundedButtonActualState, vm: VCircularButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        }
    }

    static func background(state: VRoundedButtonActualState, vm: VCircularButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.background.enabled
        case .pressed: return vm.colors.background.pressed
        case .disabled: return vm.colors.background.disabled
        }
    }
}
