//
//  VDialogSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Dialog Secondary Button
struct VDialogSecondaryButton: View {
    // MARK: Properties
    private let model: VPrimaryButtonModel
    private let action: () -> Void
    private let title: String
    
    // MARK: Initializers
    init(
        model: VPrimaryButtonModel,
        action: @escaping () -> Void,
        title: String
    ) {
        self.model = model
        self.action = action
        self.title = title
    }
    
    // MARK: Body
    var body: some View {
        VPrimaryButton(
            model: model,
            isLoading: false,
            action: action,
            title: title
        )
    }
}

// MARK: - Preview
struct VDialogSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VDialogSecondaryButton(
            model: VDialogModel().secondaryButtonSubModel,
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
