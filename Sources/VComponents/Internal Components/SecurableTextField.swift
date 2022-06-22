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
    
    private let placeholder: String?
    @Binding private var text: String
    
    @FocusState private var isTextFieldFocused
    @FocusState private var isSecureFieldFocused
    
    // MARK: Initializers
    init(
        isSecure: Bool,
        placeholder: String?,
        text: Binding<String>
    ) {
        self.isSecure = isSecure
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: Body
    var body: some View {
        ZStack(content: {
            TextField(
                text: $text,
                prompt: placeholder.map { .init($0) },
                label: EmptyView.init
            )
                .focused($isTextFieldFocused)
                .opacity(isSecure ? 0 : 1)
            
            SecureField(
                text: $text,
                prompt: placeholder.map { .init($0) },
                label: EmptyView.init
            )
                .focused($isSecureFieldFocused)
                .opacity(isSecure ? 1 : 0)
        })
    }
}
