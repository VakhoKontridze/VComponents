//
//  NoDismissTypeWarningView.swift
//  VComponentsDemoDemo
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import SwiftUI
import VComponents

// MARK: - No Dismiss Type Warning View
struct NoDismissTypeWarningView: View {
    // MARK: Properties
    private let buttonUIModel: VPlainButtonUIModel = {
        var uiModel: VPlainButtonUIModel = .init()
        uiModel.colors.title = .init(
            enabled: ColorBook.primaryWhite,
            pressed: ColorBook.primaryWhitePressedDisabled,
            disabled: ColorBook.primaryWhitePressedDisabled
        )
        return uiModel
    }()
    
    private let dismissHandler: () -> Void
    
    // MARK: Initializers
    init(onDismiss dismissHandler: @escaping () -> Void) {
        self.dismissHandler = dismissHandler
    }
    
    // MARK: Body
    var body: some View {
        VStack(content: {
            VText(
                type: .multiLine(alignment: .center, lineLimit: nil),
                color: ColorBook.primaryWhite,
                font: .system(size: 14, weight: .semibold),
                text: "When there are no dismiss types, Modal can only be dismissed programmatically"
            )

            VPlainButton(
                uiModel: buttonUIModel,
                action: dismissHandler,
                title: "Dismiss"
            )
        })
            .padding(15)
            .background(ColorBook.accent.opacity(0.75))
            .cornerRadius(10)
            .padding(15)
    }
}
