//
//  VPrimaryButtonStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Primary Button Style
struct VPrimaryButtonStyle: ButtonStyle {
    // MARK: Properties
    private let state: VPrimaryButtonState
    private let buttonType: VPrimaryButtonType
    private let viewModel: VPrimaryButtonViewModel
    
    // MARK: Initializers
    init(state: VPrimaryButtonState, type buttonType: VPrimaryButtonType, viewModel: VPrimaryButtonViewModel) {
        self.state = state
        self.buttonType = buttonType
        self.viewModel = viewModel
    }
}

// MARK:- Style
extension VPrimaryButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        contentView(label: configuration.label, actualState: actualState(configuration: configuration))
            .padding(.horizontal, viewModel.layout.contentInset)
            .frame(height: viewModel.layout.height)
            .if(buttonType == .compact, transform: { $0 })
            .if(buttonType == .fixed, transform: { $0.frame(width: viewModel.layout.widthFixed) })
            .if(buttonType == .flexible, transform: { $0.frame(maxWidth: .infinity) })

            .background(backgroundView(actualState: actualState(configuration: configuration)))
    }
    
    private func contentView(label: ButtonStyleConfiguration.Label, actualState: VPrimaryButtonActualState) -> some View {
        HStack(alignment: .center, spacing: 20, content: {
            loaderCompensatorView(actualState: actualState)
            textView(label: label, actualState: actualState)
            loaderView(actualState: actualState)
        })
    }
    
    private func textView(label: ButtonStyleConfiguration.Label, actualState: VPrimaryButtonActualState) -> some View {
        label
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(VPrimaryButtonViewModel.Colors.foreground(state: actualState, vm: viewModel))
            .font(viewModel.fonts.title)
    }
    
    @ViewBuilder private func loaderCompensatorView(actualState: VPrimaryButtonActualState) -> some View {
        if actualState == .loading {
            Spacer().frame(width: VPrimaryButtonViewModel.Static.progressViewWidth, alignment: .leading)
            if buttonType != .compact { Spacer() }
        }
    }
    
    @ViewBuilder private func loaderView(actualState: VPrimaryButtonActualState) -> some View {
        if actualState == .loading {
            if buttonType != .compact { Spacer() }
            VSpinner(type: .continous, viewModel: .init()).frame(width: VPrimaryButtonViewModel.Static.progressViewWidth, alignment: .trailing)
        }
    }
    
    private func backgroundView(actualState: VPrimaryButtonActualState) -> some View {
        RoundedRectangle(cornerRadius: viewModel.layout.cornerRadius, style: .continuous)
            .foregroundColor(VPrimaryButtonViewModel.Colors.background(state: actualState, vm: viewModel))
    }
}

// MARK:- Actual State
private enum VPrimaryButtonActualState {
    case enabled
    case pressed
    case disabled
    case loading
}

private extension VPrimaryButtonStyle {
    func actualState(configuration: Configuration) -> VPrimaryButtonActualState {
        if configuration.isPressed && state.isEnabled {
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
private extension VPrimaryButtonViewModel.Colors {
    static func foreground(state: VPrimaryButtonActualState, vm: VPrimaryButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.foreground.enabled
        case .pressed: return vm.colors.foreground.pressed
        case .disabled: return vm.colors.foreground.disabled
        case .loading: return vm.colors.foreground.loading
        }
    }

    static func background(state: VPrimaryButtonActualState, vm: VPrimaryButtonViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.background.enabled
        case .pressed: return vm.colors.background.pressed
        case .disabled: return vm.colors.background.disabled
        case .loading: return vm.colors.background.loading
        }
    }
}
