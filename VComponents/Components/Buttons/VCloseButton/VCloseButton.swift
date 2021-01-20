//
//  VCloseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Close Button
/// Circular colored close button component that performs action when triggered
///
/// Model and state can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     VCloseButton(action: {
///         print("Pressed")
///     })
/// }
/// ```
///
public struct VCloseButton: View {
    // MARK: Properties
    private let model: VCloseButtonModel

    private let state: VCloseButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCloseButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    // MARK: Initializers
    public init(
        model: VCloseButtonModel = .init(),
        state: VCloseButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.action = action
    }
}

// MARK:- Body
extension VCloseButton {
    public var body: some View {
        VBaseButton(
            isEnabled: state.isEnabled,
            action: action,
            onPress: { isPressed = $0 },
            content: { hitBox }
        )
    }
    
    private var hitBox: some View {
        buttonView
            .padding(.horizontal, model.layout.hitBoxHor)
            .padding(.vertical, model.layout.hitBoxVer)
    }
    
    private var buttonView: some View {
        buttonContent
            .frame(dimension: model.layout.dimension)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        ImageBook.xMark
            .resizable()
            .frame(dimension: model.layout.iconDimension)
            .foregroundColor(model.colors.content.for(internalState))
            .opacity(model.colors.content.for(internalState))
    }
    
    private var backgroundView: some View {
        Circle()
            .foregroundColor(model.colors.background.for(internalState))
    }
}

// MARK:- Preview
struct VCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButton(action: {})
            .padding()
    }
}
