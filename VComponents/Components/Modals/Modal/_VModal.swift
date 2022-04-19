//
//  _VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - _ V Modal
struct _VModal<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass? // Detects orientation changes
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass? // Detects orientation changes
    
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    
    private let model: VModalModel
    
    private let dismissHandler: (() -> Void?)?
    
    private let headerLabel: VModalHeaderLabel<HeaderLabel>
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || model.misc.dismissType.hasButton }
    private var hasHeaderDivider: Bool { hasHeader && model.layout.headerDividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    // MARK: Initializers
    init(
        model: VModalModel,
        onDismiss dismissHandler: (() -> Void)? = nil,
        headerLabel: VModalHeaderLabel<HeaderLabel>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.dismissHandler = dismissHandler
        self.headerLabel = headerLabel
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            blinding
            modal
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 { animateOutFromExternalDismiss() } }
            )
    }
    
    private var blinding: some View {
        model.colors.blinding
            .edgesIgnoringSafeArea(.all)
            .onTapGesture(perform: {
                if model.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var modal: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)

            VStack(spacing: 0, content: {
                header
                divider
                contentView
            })
                .frame(maxHeight: .infinity, alignment: .top)
        })
            .frame(size: model.layout.size)
            .scaleEffect(isInternallyPresented ? 1 : model.animations.scaleEffect)
            .opacity(isInternallyPresented ? 1 : model.animations.opacity)
            .blur(radius: isInternallyPresented ? 0 : model.animations.blur)
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(spacing: model.layout.labelCloseButtonSpacing, content: {
                Group(content: {
                    if model.misc.dismissType.contains(.leadingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.trailingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group(content: {
                    switch headerLabel {
                    case .empty:
                        EmptyView()
                        
                    case .title(let title):
                        VText(
                            color: model.colors.headerTitle,
                            font: model.fonts.header,
                            title: title
                        )
                        
                    case .custom(let label):
                        label()
                    }
                })
                    .layoutPriority(1)

                Group(content: {
                    if model.misc.dismissType.contains(.trailingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.leadingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
                .padding(.leading, model.layout.headerMargins.leading)
                .padding(.trailing, model.layout.headerMargins.trailing)
                .padding(.top, model.layout.headerMargins.top)
                .padding(.bottom, model.layout.headerMargins.bottom)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasHeaderDivider {
            Rectangle()
                .frame(height: model.layout.headerDividerHeight)
                .padding(.leading, model.layout.headerDividerMargins.leading)
                .padding(.trailing, model.layout.headerDividerMargins.trailing)
                .padding(.top, model.layout.headerDividerMargins.top)
                .padding(.bottom, model.layout.headerDividerMargins.bottom)
                .foregroundColor(model.colors.headerDivider)
        }
    }

    private var contentView: some View {
        content()
            .padding(.leading, model.layout.contentMargins.leading)
            .padding(.trailing, model.layout.contentMargins.trailing)
            .padding(.top, model.layout.contentMargins.top)
            .padding(.bottom, model.layout.contentMargins.bottom)
            .frame(maxHeight: .infinity)
    }

    private var closeButton: some View {
        VSquareButton.close(
            model: model.closeButtonSubModel,
            action: animateOut
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: model.layout.closeButtonDimension)
    }

    // MARK: Animations
    private func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isInternallyPresented = true })
    }

    private func animateOut() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isInternallyPresented = false })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.disappear?.duration ?? 0),
            execute: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromExternalDismiss() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isInternallyPresented = false })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.disappear?.duration ?? 0),
            execute: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
}

// MARK: - Previews
struct VModal_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vModal(isPresented: $isPresented, modal: {
                VModal(
                    headerTitle: "Lorem ipsum",
                    content: { ColorBook.accent }
                )
            })
    }
}
