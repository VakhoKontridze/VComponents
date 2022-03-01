//
//  VChevronButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Chevron Button
extension VSquareButton where Content == Never {
    static func chevron(
        model: VChevronButtonModel = .init(),
        direction: VChevronButtonDirection,
        action: @escaping () -> Void
    ) -> some View {
        VSquareButton(
            model: model.squareButtonSubModel,
            action: action,
            icon: ImageBook.chevronUp
        )
            .rotationEffect(.init(degrees: direction.angle))
    }
}

// MARK: - Preview
struct VChevronButton_Previews: PreviewProvider {
    static var previews: some View {
        VSquareButton.chevron(
            direction: .right,
            action: {}
        )
    }
}
