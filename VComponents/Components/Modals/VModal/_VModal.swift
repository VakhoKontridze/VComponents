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
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let headerContent: (() -> HeaderContent)?
    private let content: () -> Content
    
    private let appearAction: (() -> Void)?
    private let disappearAction: (() -> Void)?
    
    private var headerExists: Bool { headerContent != nil || model.misc.dismissType.hasButton }
    
    // MARK: Initializers
    init(
        model: VModalModel,
        isPresented: Binding<Bool>,
        headerContent: (() -> HeaderContent)?,
        @ViewBuilder content: @escaping () -> Content,
        appearAction: (() -> Void)?,
        disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isHCPresented = isPresented
        self.headerContent = headerContent
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Body
extension _VModal {
    var body: some View {
        ZStack(content: {
            blinding
            modalView
        })
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: animateIn)
    }
    
    private var blinding: some View {
        model.colors.blinding
            .onTapGesture(perform: animateOut)
    }
    
    private var modalView: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)
            
            VStack(spacing: model.layout.spacing, content: {
                headerView
                dividerView
                content()
            })
                .padding(model.layout.margin)
        })
            .frame(size: model.layout.size)
            .scaleEffect(isViewPresented ? 1 : model.animations.scaleEffect)
            .opacity(isViewPresented ? 1 : model.animations.opacity)
            .blur(radius: isViewPresented ? 0 : model.animations.blur)
            .onAppear(perform: appearAction)
            .onDisappear(perform: disappearAction)
    }
    
    @ViewBuilder private var headerView: some View {
        if headerExists {
            HStack(spacing: model.layout.headerSpacing, content: {
                if model.misc.dismissType.contains(.leading) {
                    closeButton
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let headerContent = headerContent {
                    headerContent()
                        .layoutPriority(1)  // Overrides close button's maxWidth: .infinity. Also, header content is by default maxWidth and leading justified.
                }
                
                if model.misc.dismissType.contains(.trailing) {
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
        VCloseButton(model: model.closeButtonSubModel, action: animateOut)
    }
}

// MARK:- Animations
private extension _VModal {
    func animateIn() {
        withAnimation(model.animations.appear?.swiftUIAnimation, { isViewPresented = true })
    }
    
    func animateOut() {
        withAnimation(model.animations.disappear?.swiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }
}

// MARK:- Previews
struct VModal_Previews: PreviewProvider {
    static var previews: some View {
        _VModal(
            model: .init(),
            isPresented: .constant(true),
            headerContent: { VModalDefaultHeader(title: "Lorem ipsum dolor sit amet") },
            content: { ColorBook.accent },
            appearAction: nil,
            disappearAction: nil
        )
    }
}
