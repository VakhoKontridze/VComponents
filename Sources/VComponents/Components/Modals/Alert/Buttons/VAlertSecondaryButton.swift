//
//  VAlertSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Alert Secondary Button
struct VAlertSecondaryButton: View {
    // MARK: Properties
    private let uiModel: VPrimaryButtonUIModel
    private let action: () -> Void
    private let title: String
    
    // MARK: Initializers
    init(
        uiModel: VPrimaryButtonUIModel,
        action: @escaping () -> Void,
        title: String
    ) {
        self.uiModel = uiModel
        self.action = action
        self.title = title
    }
    
    // MARK: Body
    var body: some View {
        VPrimaryButton(
            uiModel: uiModel,
            isLoading: false,
            action: action,
            title: title
        )
    }
}

// MARK: - Preview
struct VAlertSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VAlertSecondaryButton(
            uiModel: VAlertUIModel().secondaryButtonSubUIModel,
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
