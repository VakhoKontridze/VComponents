//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert
struct VAlert: View {
    // MARK: Properties
    private let model: VAlertModel
    
    @Binding private var isPresented: Bool
    
    private let dialogType: VAlertDialogType
    
    private let title: String?
    private let description: String
    
    // MARK: Initializers
    init(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String
    ) {
        self.model = model
        self._isPresented = isPresented
        self.dialogType = dialogType
        self.title = title
        self.description = description
    }
}

// MARK:- Body
extension VAlert {
    var body: some View {
        ZStack(content: {
            background
            contentView
        })
            .frame(width: model.layout.width)
    }
    
    private var background: some View {
        model.colors.background
            .cornerRadius(model.layout.cornerRadius)
    }
    
    private var contentView: some View {
        VStack(spacing: model.layout.contentSpacing, content: {
            textView
            dialogView
        })
            .padding(model.layout.contentInset)
    }
    
    private var textView: some View {
        VStack(spacing: model.layout.textSpacing, content: {
            titleView
            descriptionView
        })
            .padding(.horizontal, model.layout.textPaddingHor)
            .padding(.top, model.layout.textPaddingTop)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VGenericTitleContentView(
                title: title,
                color: model.colors.title,
                font: model.fonts.title
            )
        }
    }
    
    @ViewBuilder private var descriptionView: some View {
        if !description.isEmpty {
            VGenericTitleContentView(
                title: description,
                color: model.colors.description,
                font: model.fonts.description
            )
        }
    }
    
    @ViewBuilder private var dialogView: some View {
        switch dialogType {
        case .one(let button): oneButtonDialogView(button: button)
        case .two(let primary, let secondary): twoButtonDialogView(primary: primary, secondary: secondary)
        }
    }
    
    private func oneButtonDialogView(button: VAlertDialogButton) -> some View {
        VPrimaryButton(
            model: model.primaryButtonModel,
            state: .enabled,
            action: { dismiss(and: button.action) },
            title: button.title
        )
    }
    
    private func twoButtonDialogView(primary: VAlertDialogButton, secondary: VAlertDialogButton) -> some View {
        HStack(spacing: model.layout.contentSpacing, content: {
            VPrimaryButton(
                model: model.secondaryButtonModel,
                state: .enabled,
                action: { dismiss(and: secondary.action) },
                title: secondary.title
            )
            
            VPrimaryButton(
                model: model.primaryButtonModel,
                state: .enabled,
                action: { dismiss(and: primary.action) },
                title: primary.title
            )
        })
    }
}

// MARK:- Dismiss
private extension VAlert {
    func dismiss(and action: @escaping () -> Void ) {
        withAnimation { isPresented = false }
        action()
    }
}

// MARK:- Preview
struct VAlert_Previews: PreviewProvider {
    static var previews: some View {
//        VAlert()
        Text("???")
    }
}
