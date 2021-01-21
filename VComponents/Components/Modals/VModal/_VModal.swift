//
//  _VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- _ V Modal
struct _VModal<Content, HeaderContent>: View
    where
        Content: View,
        HeaderContent: View
{
    // MARK: Properties
    public var model: VModalModel
    
    @Binding private var isPresented: Bool
    
    let headerContent: (() -> HeaderContent)?
    let content: () -> Content
    
    let appearAction: (() -> Void)?
    let disappearAction: (() -> Void)?
    
    var headerExists: Bool { headerContent != nil || model.layout.closeButton.hasButton }
    
    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        modal: VModal<Content, HeaderContent>
    ) {
        self.init(
            model: modal.model,
            isPresented: isPresented,
            headerContent: modal.headerContent,
            content: modal.content,
            appearAction: modal.appearAction,
            disappearAction: modal.disappearAction
        )
    }
    
    private init(
        model: VModalModel,
        isPresented: Binding<Bool>,
        headerContent: (() -> HeaderContent)?,
        @ViewBuilder content: @escaping () -> Content,
        appearAction: (() -> Void)?,
        disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isPresented = isPresented
        self.headerContent = headerContent
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
        if headerExists {
            HStack(spacing: model.layout.headerSpacing, content: {
                if model.layout.closeButton.contains(.leading) {
                    closeButton
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let headerContent = headerContent {
                    headerContent()
                        .layoutPriority(1)  // Overrides close button's maxWidth: .infinity. Also, header content is by default maxWidth and leading justified.
                }
                
                if model.layout.closeButton.contains(.trailing) {
                    closeButton
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            })
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
        VCloseButton(model: model.closeButtonModel, action: dismiss)
    }

    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: model.layout.closeButtonDimension)
    }
}

// MARK:- Dismiss
private extension _VModal {
    func dismiss() {
        withAnimation { isPresented = false }
    }
}

// MARK:- Helpers
private extension Set where Element == VModalModel.Layout.CloseButtonType {
    var hasButton: Bool {
        contains(where: { [.leading, .trailing].contains($0) })
    }
}

// MARK:- Previews
struct VModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            VModalModel.Colors().blinding.edgesIgnoringSafeArea(.all)
            
            _VModal(isPresented: .constant(true), modal: VModal(
                header: { VModalDefaultHeader(title: "Lorem ipsum dolor sit amet") },
                content: { Color.red }
            ))
        })
    }
}
