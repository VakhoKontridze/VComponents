//
//  _VDialog.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- _ V Dialog
struct _VDialog<Content>: View where Content: View {
    // MARK: Properties
    private let model: VDialogModel
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let dialogButtons: VDialogButtons
    
    private let title: String?
    private let description: String?
    private let content: (() -> Content)?
    
    // MARK: Initializers
    init(
        model: VDialogModel,
        isPresented: Binding<Bool>,
        dialogButtons: VDialogButtons,
        title: String?,
        description: String?,
        content: (() -> Content)?
    ) {
        self.model = model
        self._isHCPresented = isPresented
        self.dialogButtons = dialogButtons
        self.title = title
        self.description = description
        self.content = content
    }
}

// MARK:- Body
extension _VDialog {
    var body: some View {
        ZStack(content: {
            blinding
            modalView
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: model.misc.ignoredKeybordSafeAreaEdges)
            .onAppear(perform: animateIn)
    }
    
    private var blinding: some View {
        model.colors.blinding
            .edgesIgnoringSafeArea(.all)
    }
    
    private var modalView: some View {
        VStack(spacing: 0, content: {
            VStack(spacing: model.layout.titlesAndContentSpacing, content: {
                titleView
                descriptionView
                freeContentView
            })
                .padding(.horizontal, model.layout.titlesAndContentMargins.horizontal)
                .padding(.vertical, model.layout.titlesAndContentMargins.vertical)
            
            dialogView
        })
            .padding(model.layout.margin)
            .scaleEffect(isViewPresented ? 1 : model.animations.scaleEffect)
            .opacity(isViewPresented ? 1 : model.animations.opacity)
            .blur(radius: isViewPresented ? 0 : model.animations.blur)
            .background(background)
            .frame(width: model.layout.width)
    }
    
    private var background: some View {
        model.colors.background
            .cornerRadius(model.layout.cornerRadius)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VText(
                type: .oneLine,
                font: model.fonts.title,
                color: model.colors.title,
                title: title
            )
        }
    }
    
    @ViewBuilder private var descriptionView: some View {
        if let description = description, !description.isEmpty {
            VText(
                type: .multiLine(limit: model.layout.descriptionLineLimit, alignment: .center),
                font: model.fonts.description,
                color: model.colors.description,
                title: description
            )
        }
    }
    
    @ViewBuilder private var freeContentView: some View {
        if let content = content {
            content()
                .padding(.vertical, model.layout.contentMarginVertical)
        }
    }
    
    @ViewBuilder private var dialogView: some View {
        switch dialogButtons {
        case .one(let button): oneButtonDialogView(button: button)
        case .two(let primary, let secondary): twoButtonDialogView(primary: primary, secondary: secondary)
        case .many(let buttons): manyButtonDialogView(buttons: buttons)
        }
    }
    
    private func oneButtonDialogView(button: VDialogButton) -> some View {
        VPrimaryButton(
            model: button.model.buttonSubModel,
            state: button.isEnabled ? .enabled : .disabled,
            action: { animateOut(and: button.action) },
            title: button.title
        )
    }
    
    private func twoButtonDialogView(primary: VDialogButton, secondary: VDialogButton) -> some View {
        HStack(spacing: model.layout.twoButtonSpacing, content: {
            VPrimaryButton(
                model: secondary.model.buttonSubModel,
                state: secondary.isEnabled ? .enabled : .disabled,
                action: { animateOut(and: secondary.action) },
                title: secondary.title
            )
            
            VPrimaryButton(
                model: primary.model.buttonSubModel,
                state: primary.isEnabled ? .enabled : .disabled,
                action: { animateOut(and: primary.action) },
                title: primary.title
            )
        })
    }
    
    private func manyButtonDialogView(buttons: [VDialogButton]) -> some View {
        VStack(spacing: model.layout.manyButtonSpacing, content: {
            ForEach(0..<buttons.count, content: { i in
                VPrimaryButton(
                    model: buttons[i].model.buttonSubModel,
                    state: buttons[i].isEnabled ? .enabled : .disabled,
                    action: { animateOut(and: buttons[i].action) },
                    title: buttons[i].title
                )
            })
        })
    }
}

// MARK:- Animations
private extension _VDialog {
    func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isViewPresented = true })
    }
    
    func animateOut(and action: @escaping () -> Void) {
        action()
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }
}

// MARK:- Preview
struct VDialog_Previews: PreviewProvider {
    static var previews: some View {
        _VDialog(
            model: .init(),
            isPresented: .constant(true),
            dialogButtons: .two(
                primary: .init(model: .primary, title: "OK", action: {}),
                secondary: .init(model: .secondary, title: "Cancel", action: {})
            ),
            title: "Lorem ipsum dolor sit amet",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            content: { VTextField(state: .constant(.enabled), text: .constant("Lorem ipsum dolor sit amet")) }
        )
    }
}
