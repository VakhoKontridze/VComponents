//
//  VConfirmationDialogContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Content View
struct VConfirmationDialogContentView: View {
    // MARK: Properties
    let buttons: [any VConfirmationDialogButtonProtocol]
    
    // MARK: Initializers
    init(button: [any VConfirmationDialogButtonProtocol]) {
        self.buttons = VConfirmationDialogButtonBuilder.process(button)
    }
    
    // MARK: Body
    var body: some View {
        ForEach(buttons.indices, id: \.self, content: { i in
            buttons[i].body
        })
    }
}
