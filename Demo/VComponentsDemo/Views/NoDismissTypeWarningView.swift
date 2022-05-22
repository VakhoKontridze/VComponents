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
    private let buttonModel: VPlainButtonModel = {
        var model: VPlainButtonModel = .init()
        model.colors.title = .init(
            enabled: ColorBook.primaryWhite,
            pressed: .init(componentAsset: "PrimaryWhite.presseddisabled"), // Not exposing API
            disabled: .init(componentAsset: "PrimaryWhite.presseddisabled") // Not exposing API
        )
        return model
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
                type: .multiLine(alignment: .center, limit: nil),
                color: ColorBook.primaryWhite,
                font: .system(size: 14, weight: .semibold),
                title: "When there are no dismiss types, Modal can only be dismissed programatically"
            )

            VPlainButton(
                model: buttonModel,
                action: dismissHandler,
                title: "Dismiss"
            )
        })
            .padding(15)
            .background(Color.black.opacity(0.75))
            .cornerRadius(10)
            .padding(15)
    }
}
