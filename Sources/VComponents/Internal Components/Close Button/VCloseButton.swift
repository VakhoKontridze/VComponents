//
//  VCloseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Chevron Button
extension VSquareButton where Label == Never {
    static func close(
        uiModel: VCloseButtonUIModel = .init(),
        action: @escaping () -> Void
    ) -> some View {
        VSquareButton(
            uiModel: uiModel.squareButtonSubUIModel,
            action: action,
            icon: ImageBook.xMark
        )
    }
}

// MARK: - Preview
struct VCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VSquareButton.close(
            action: { print("Clicked") }
        )
    }
}
