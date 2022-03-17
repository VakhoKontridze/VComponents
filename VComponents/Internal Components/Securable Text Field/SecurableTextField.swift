//
//  SecurableTextField.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/16/22.
//

import SwiftUI

// MARK: - Securable Text Field
struct SecurableTextField: View {
    // MARK: Properties
    private let isSecure: Bool
    @Binding private var text: String
    private let placeholder: String?
    
    // MARK: Initializers
    init(
        isSecure: Bool,
        text: Binding<String>,
        placeholder: String?
    ) {
        self.isSecure = isSecure
        self._text = text
        self.placeholder = placeholder
    }
    
    // MARK: Body
    var body: some View {
        switch isSecure {
        case false:
            TextField(
                text: $text,
                prompt: placeholder.map { .init($0) },
                label: { EmptyView() }
            )
                .labelsHidden()
            
        case true:
            SecureField(
                text: $text,
                prompt: placeholder.map { .init($0) },
                label: { EmptyView() }
            )
                .labelsHidden()
        }
    }
}
