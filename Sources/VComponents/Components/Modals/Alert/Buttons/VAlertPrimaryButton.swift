//
//  VAlertPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Alert Primary Button
struct VAlertPrimaryButton: View {
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
    public var body: some View {
        VPrimaryButton(
            uiModel: uiModel,
            isLoading: false,
            action: action,
            title: title
        )
    }
}

// MARK: - Preview
struct VAlertPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VAlertPrimaryButton(
            uiModel: VAlertUIModel().primaryButtonSubUIModel,
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
