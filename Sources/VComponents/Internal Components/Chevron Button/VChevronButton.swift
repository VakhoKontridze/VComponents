//
//  VChevronButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Chevron Button
extension VRoundedButton where Label == Never {
    static func chevron(
        uiModel: VChevronButtonUIModel = .init(),
        direction: VChevronButtonDirection,
        action: @escaping () -> Void
    ) -> some View {
        VRoundedButton(
            uiModel: uiModel.roundedButtonSubUIModel,
            action: action,
            icon: ImageBook.chevronUp
        )
            .rotationEffect(.init(degrees: direction.angle))
    }
}

// MARK: - Preview
struct VChevronButton_Previews: PreviewProvider {
    static var previews: some View {
        VRoundedButton.chevron(
            direction: .right,
            action: { print("Clicked") }
        )
    }
}
