//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert
struct VAlert<Content>: View where Content: View {
    // MARK: Properties
    private let model: VAlertModel
    
    @Binding private var isPresented: Bool
    
    private let dialogType: VAlertDialogType
    
    private let title: String?
    private let description: String?
    private let content: (() -> Content)?
    private let disappearAciton: (() -> Void)?
    
    // MARK: Initializers
    init(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        content: (() -> Content)?,
        onDisappear disappearAciton: (() -> Void)? = nil
    ) {
        self.model = model
        self._isPresented = isPresented
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = content
        self.disappearAciton = disappearAciton
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
            .onDisappear(perform: disappearAciton)
    }
    
    private var background: some View {
        model.colors.background
            .cornerRadius(model.layout.cornerRadius)
    }
    
    private var contentView: some View {
        VStack(spacing: model.layout.contentSpacing, content: {
            alertContentView
            dialogView
        })
            .padding(model.layout.contentMargin)
    }
    
    private var alertContentView: some View {
        VStack(spacing: model.layout.textSpacing, content: {
            titleView
            descriptionView
            freeContentView
        })
            .padding(.horizontal, model.layout.textMarginHor)
            .padding(.top, model.layout.textMarginTop)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VBaseTitle(
                title: title,
                color: model.colors.title,
                font: model.fonts.title,
                type: .oneLine
            )
        }
    }
    
    @ViewBuilder private var descriptionView: some View {
        if let description = description, !description.isEmpty {
            VBaseTitle(
                title: description,
                color: model.colors.description,
                font: model.fonts.description,
                type: .multiLine(limit: 5, alignment: .center)
            )
        }
    }
    
    @ViewBuilder private var freeContentView: some View {
        if let content = content {
            content()
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
        EmptyView()
    }
}
