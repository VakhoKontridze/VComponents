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
    private var internalState: VPrimaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
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
                    isVisible: internalState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
                
                VPrimaryButtonContentView(
                    foregroundColor: viewModel.colors.foregroundColor(state: internalState),
                    foregroundOpacity: viewModel.colors.foregroundOpacity(state: internalState),
                    font: viewModel.fonts.title,
                    content: content
                )
                
                VPrimaryButtonLoaderView(
                    isVisible: internalState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
            })
                .padding(.horizontal, viewModel.layout.contentInset)
                .frame(height: viewModel.layout.height)
                .background(
                    VPrimaryButtonBackgroundView(
                        cornerRadius: viewModel.layout.cornerRadius,
                        borderWidth: viewModel.layout.borderWidth,
                        fillColor: viewModel.colors.fillColor(state: internalState),
                        borderColor: viewModel.colors.borderColor(state: internalState)
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
