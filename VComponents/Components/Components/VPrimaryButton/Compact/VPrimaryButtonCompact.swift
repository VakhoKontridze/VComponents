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
    private let model: VPrimaryButtonCompactModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPrimaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VPrimaryButtonCompactModel,
        state: VPrimaryButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }
}

// MARK:- Body
extension VPrimaryButtonCompact {
    var body: some View {
        VInteractiveView(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            HStack(alignment: .center, spacing: model.layout.loaderSpacing, content: {
                VPrimaryButtonLoaderCompensatorView(
                    isVisible: internalState.isLoading,
                    width: model.layout.loaderWidth
                )
                
                VPrimaryButtonContentView(
                    foregroundColor: model.colors.foregroundColor(state: internalState),
                    foregroundOpacity: model.colors.foregroundOpacity(state: internalState),
                    font: model.fonts.title,
                    content: content
                )
                
                VPrimaryButtonLoaderView(
                    loaderColor: model.colors.loader.color,
                    width: model.layout.loaderWidth,
                    isVisible: internalState.isLoading
                )
            })
                .padding(.horizontal, model.layout.contentInset)
                .frame(height: model.layout.height)
                .background(
                    VPrimaryButtonBackgroundView(
                        cornerRadius: model.layout.cornerRadius,
                        borderWidth: model.layout.borderWidth,
                        fillColor: model.colors.fillColor(state: internalState),
                        borderColor: model.colors.borderColor(state: internalState)
                    )
                )
        })
    }
}

// MARK:- Preview
struct VPrimaryButtonCompact_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonCompact(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
