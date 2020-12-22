//
//  VToggleContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Content View
struct VToggleContentView<Conent>: View where Conent: View {
    // MARK: Properties
    private let opacity: Double
    
    private let isDisabled: Bool
    @Binding private var isPressed: Bool
    
    private let action: () -> Void
    
    private let content: () -> Conent
    
    // MARK: Initializers
    internal init(
        opacity: Double,
        isDisabled: Bool,
        isPressed: Binding<Bool>,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Conent
    ) {
        self.opacity = opacity
        self.isDisabled = isDisabled
        self._isPressed = isPressed
        self.action = action
        self.content = content
    }
}

// MARK:- Body
extension VToggleContentView {
    var body: some View {
        VInteractiveView(isDisabled: isDisabled, action: action, onPress: { isPressed = $0 }, content: {
            content()
                .opacity(opacity)
        })
    }
}

// MARK:- Preview
struct VToggleContentView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleContentView(
            opacity: VToggleRightContentModel.Colors().contentDisabledOpacity(state: .enabled),
            isDisabled: false,
            isPressed: .constant(false),
            action: {},
            content: { Text("???") }
        )
    }
}
