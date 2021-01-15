//
//  _VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- _ V Modal
struct _VModal<Content, TitleContent>: View
    where
        Content: View,
        TitleContent: View
{
    // MARK: Properties
    public var model: VModalModel
    
    @Binding private var isPresented: Bool
    
    let titleContent: (() -> TitleContent)?
    let content: () -> Content
    
    let appearAction: (() -> Void)?
    let disappearAction: (() -> Void)?
    
    var headerExists: Bool { titleContent != nil || model.layout.closeButtonPosition.exists }
    
    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        modal: VModal<Content, TitleContent>
    ) {
        self.init(
            model: modal.model,
            isPresented: isPresented,
            titleContent: modal.titleContent,
            content: modal.content,
            appearAction: modal.appearAction,
            disappearAction: modal.disappearAction
        )
    }
    
    private init(
        model: VModalModel,
        isPresented: Binding<Bool>,
        titleContent: (() -> TitleContent)?,
        @ViewBuilder content: @escaping () -> Content,
        appearAction: (() -> Void)?,
        disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isPresented = isPresented
        self.titleContent = titleContent
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Body
extension _VModal {
    var body: some View {
        ZStack(alignment: .top, content: {
            sheetView
            contentView
        })
            .frame(size: model.layout.size)
            .onAppear(perform: appearAction)
            .onDisappear(perform: disappearAction)
    }
    
    private var sheetView: some View {
        VSheet(model: model.sheetModel)
    }

    private var contentView: some View {
        VStack(spacing: model.layout.spacing, content: {
            headerView
            dividerView
            content()
        })
            .padding(model.layout.margin)
    }
    
    @ViewBuilder private var headerView: some View {
        switch (titleContent, model.layout.closeButtonPosition) {
        case (nil, .leading):
            closeButton
                .frame(maxWidth: .infinity, alignment: .leading)
            
        case (nil, .trailing):
            closeButton
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        case (nil, _):
            EmptyView()
            
        case (let titleContent?, .leading):
            HStack(spacing: model.layout.headerSpacing, content: {
                closeButton
                titleContent()
            })
            
        case (let titleContent?, .trailing):
            HStack(spacing: 0, content: {
                titleContent()
                Spacer()
                closeButton
            })
            
        case (let titleContent?, _):
            titleContent()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private var dividerView: some View {
        if headerExists && model.layout.hasDivider {
            Rectangle()
                .frame(height: model.layout.dividerHeight)
                .foregroundColor(model.colors.divider)
        }
    }
    
    private var closeButton: some View {
        VCloseButton(action: dismiss)
    }

    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: model.layout.closeButtonWidth)
    }
}

// MARK:- Dismiss
private extension _VModal {
    func dismiss() {
        withAnimation { isPresented = false }
    }
}

// MARK:- Previews
struct VModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            VModalModel.Colors().blinding.edgesIgnoringSafeArea(.all)
            
            _VModal(isPresented: .constant(true), modal: VModal(
                title: { VModalDefaultTitle(title: "Lorem ipsum dolor sit amet") },
                content: { Color.red }
            ))
        })
    }
}
