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
    private let model: VPrimaryButtonFixedModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPrimaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VPrimaryButtonFixedModel,
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
extension VPrimaryButtonFixed {
    var body: some View {
        TouchConatiner(isDisabled: state.isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            HStack(alignment: .center, spacing: model.layout.loaderSpacing, content: {
                VPrimaryButtonLoaderCompensatorView(
                    isVisible: internalState.isLoading,
                    width: model.layout.loaderWidth
                )
                
                Spacer()
                
                VPrimaryButtonContentView(
                    foregroundColor: model.colors.foregroundColor(state: internalState),
                    foregroundOpacity: model.colors.foregroundOpacity(state: internalState),
                    font: model.fonts.title,
                    content: content
                )
                
                Spacer()
                
                VPrimaryButtonLoaderView(
                    isVisible: internalState.isLoading,
                    width: model.layout.loaderWidth
                )
            })
                .padding(.horizontal, model.layout.contentInset)
                .frame(size: model.layout.size)
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
struct VPrimaryButtonFixed_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonFixed(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
