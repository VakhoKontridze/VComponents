//
//  VToggleSpacerView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Toggle Spacer View
struct VToggleSpacerView: View {
    // MARK: Properties
    private let width: CGFloat?
    private let isDisabled: Bool
    private let action: () -> Void
    
    // MARK: Initializers
    init(
        width: CGFloat?,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) {
        self.width = width
        self.isDisabled = isDisabled
        self.action = action
    }
}

// MARK:- Body
extension VToggleSpacerView {
    var body: some View {
        VInteractiveView(isDisabled: isDisabled, action: action, onPress: { _ in }, content: {
            Rectangle()
                .fixedSize(horizontal: false, vertical: true)
                .ifLet(width, transform: { $0.frame(width: $1) })
                .foregroundColor(.clear)
        })
    }
}

// MARK:- Preview
struct VToggleSpacerView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleSpacerView(
            width: VToggleRightContentModel.Layout().contentSpacing,
            isDisabled: false,
            action: {}
        )
    }
}
