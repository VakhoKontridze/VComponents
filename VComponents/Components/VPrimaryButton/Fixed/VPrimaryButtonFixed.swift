//
//  VPrimaryButtonFixed.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Fixed
struct VPrimaryButtonFixed<Content>: View where Content: View {
    // MARK: Properties
    private let viewModel: VPrimaryButtonFixedViewModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var actualState: VPrimaryButtonActualState { state.actualState(isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        viewModel: VPrimaryButtonFixedViewModel,
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
extension VPrimaryButtonFixed {
    var body: some View {
        TouchConatiner(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            HStack(alignment: .center, spacing: viewModel.layout.loaderSpacing, content: {
                VPrimaryButtonLoaderCompensatorView(
                    isVisible: actualState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
                
                Spacer()
                
                VPrimaryButtonContentView(
                    foregroundColor: viewModel.colors.foregroundColor(state: actualState),
                    foregroundOpacity: viewModel.colors.foregroundOpacity(state: actualState),
                    font: viewModel.fonts.title,
                    content: content
                )
                
                Spacer()
                
                VPrimaryButtonLoaderView(
                    isVisible: actualState.isLoading,
                    width: viewModel.layout.loaderWidth
                )
            })
                .padding(.horizontal, viewModel.layout.contentInset)
                .frame(size: viewModel.layout.size)
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
struct VPrimaryButtonFixed_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonFixed(viewModel: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
