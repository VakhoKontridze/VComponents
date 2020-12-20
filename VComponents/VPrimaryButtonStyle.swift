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
        contentView(label: configuration.label, actualState: state.actualState(configuration: configuration))
            .padding(.horizontal, viewModel.layout.common.contentInset)
            .frame(height: viewModel.layout.common.height)
            .if(buttonType == .compact, transform: { $0 })
            .if(buttonType == .fixed, transform: { $0.frame(width: viewModel.layout.fixed.width) })
            .if(buttonType == .flexible, transform: { $0.frame(maxWidth: .infinity) })

            .background(backgroundView(actualState: state.actualState(configuration: configuration)))
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
            Spacer().frame(width: 10, alignment: .leading)
            if buttonType != .compact { Spacer() }
        }
    }
    
    @ViewBuilder private func loaderView(actualState: VPrimaryButtonActualState) -> some View {
        if actualState == .loading {
            if buttonType != .compact { Spacer() }
            VSpinner(type: .continous, viewModel: .init()).frame(width: 10, alignment: .trailing)
        }
    }
    
    private func backgroundView(actualState: VPrimaryButtonActualState) -> some View {
        RoundedRectangle(cornerRadius: viewModel.layout.common.cornerRadius, style: .continuous)
            .foregroundColor(VPrimaryButtonViewModel.Colors.background(state: actualState, vm: viewModel))
    }
}
