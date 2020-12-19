//
//  VButtonStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Button Style
struct VButtonStyle: ButtonStyle {
    // MARK: Properties
    private let state: VButtonState
    private let buttonType: VButtonType
    private let viewModel: VButtonViewModel
    
    // MARK: Initializers
    init(state: VButtonState, type buttonType: VButtonType, viewModel: VButtonViewModel) {
        self.state = state
        self.buttonType = buttonType
        self.viewModel = viewModel
    }
}

// MARK:- Style
extension VButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        contentView(label: configuration.label, actualState: actualState(configuration: configuration))
            .padding(.horizontal, viewModel.layout.contentInset)
            .frame(height: viewModel.layout.height)
            .if(buttonType == .compact, transform: { $0 })
            .if(buttonType == .fixed, transform: { $0.frame(width: viewModel.layout.widthFixed) })
            .if(buttonType == .flexible, transform: { $0.frame(maxWidth: .infinity) })

            .background(backgroundView(actualState: actualState(configuration: configuration)))
    }
    
    private func contentView(label: ButtonStyleConfiguration.Label, actualState: VButtonActualState) -> some View {
        HStack(alignment: .center, spacing: 20, content: {
            loaderCompensatorView(actualState: actualState)
            textView(label: label, actualState: actualState)
            loaderView(actualState: actualState)
        })
    }
    
    private func textView(label: ButtonStyleConfiguration.Label, actualState: VButtonActualState) -> some View {
        label
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(VButtonViewModel.Colors.foreground(state: actualState, vm: viewModel))
            .font(viewModel.fonts.title)
    }
    
    @ViewBuilder private func loaderCompensatorView(actualState: VButtonActualState) -> some View {
        if actualState == .loading {
            Spacer().frame(width: VButtonViewModel.Static.progressViewWidth, alignment: .leading)
            if buttonType != .compact { Spacer() }
        }
    }
    
    @ViewBuilder private func loaderView(actualState: VButtonActualState) -> some View {
        if actualState == .loading {
            if buttonType != .compact { Spacer() }
            VSpinner(type: .continous, viewModel: .init()).frame(width: VButtonViewModel.Static.progressViewWidth, alignment: .trailing)
        }
    }
    
    private func backgroundView(actualState: VButtonActualState) -> some View {
        RoundedRectangle(cornerRadius: viewModel.layout.cornerRadius, style: .continuous)
            .foregroundColor(VButtonViewModel.Colors.background(state: actualState, vm: viewModel))
    }
}

// MARK:- Actual State
private enum VButtonActualState {
    case enabled
    case pressed
    case disabled
    case loading
}

private extension VButtonStyle {
    func actualState(configuration: Configuration) -> VButtonActualState {
        if configuration.isPressed && state.shouldBeEnabled {
            return .pressed
        } else {
            switch state {
            case .enabled: return .enabled
            case .disabled: return .disabled
            case .loading: return .loading
            }
        }
    }
}

// MARK:- ViewModel Mapping
private extension VButtonViewModel.Colors {
    static func foreground(state: VButtonActualState, vm: VButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        case .loading: return vm.colors.foreground.loading
        }
    }

    static func background(state: VButtonActualState, vm: VButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.background.enabled
        case .pressed: return vm.colors.background.pressed
        case .disabled: return vm.colors.background.disabled
        case .loading: return vm.colors.background.loading
        }
    }
}
