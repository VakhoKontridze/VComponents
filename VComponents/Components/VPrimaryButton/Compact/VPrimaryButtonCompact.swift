//
//  VPrimaryButtonCompact.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Compact
struct VPrimaryButtonCompact<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VPrimaryButtonCompactViewModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var actualState: VPrimaryButtonActualState { state.actualState(isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        viewModel: VPrimaryButtonCompactViewModel,
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.state = state
        self.action = action
        self.content = content
    }
}

// MARK:- Body
extension VPrimaryButtonCompact {
    var body: some View {
        TouchConatiner(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            HStack(alignment: .center, spacing: viewModel.layout.loaderSpacing, content: {
                VPrimaryButtonLoaderCompensatorView(
                    isVisible: actualState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
                
                VPrimaryButtonContentView(
                    foregroundColor: viewModel.colors.foregroundColor(state: actualState),
                    foregroundOpacity: viewModel.colors.foregroundOpacity(state: actualState),
                    font: viewModel.fonts.title,
                    content: content
                )
                
                VPrimaryButtonLoaderView(
                    isVisible: actualState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
            })
                .padding(.horizontal, viewModel.layout.contentInset)
                .frame(height: viewModel.layout.height)
                .background(
                    VPrimaryButtonBackgroundView(
                        cornerRadius: viewModel.layout.cornerRadius,
                        borderWidth: viewModel.layout.borderWidth,
                        fillColor: viewModel.colors.fillColor(state: actualState),
                        borderColor: viewModel.colors.borderColor(state: actualState)
                    )
                )
        })
    }
}

// MARK:- Preview
struct VPrimaryButtonCompact_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonCompact(viewModel: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
