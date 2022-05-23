//
//  VDialogPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Dialog Primary Button
struct VDialogPrimaryButton: View {
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
    public var body: some View {
        VPrimaryButton(
            model: model,
            isLoading: false,
            action: action,
            title: title
        )
    }
}

// MARK: - Preview
struct VDialogPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VDialogPrimaryButton(
            model: VDialogModel().primaryButtonSubModel,
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
