//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Modal
struct VModal<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VModalModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let headerLabel: VModalHeaderLabel<HeaderLabel>
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || model.misc.dismissType.hasButton }
    private var hasDivider: Bool { hasHeader && model.layout.dividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    // MARK: Initializers
    init(
        model: VModalModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        headerLabel: VModalHeaderLabel<HeaderLabel>,
        content: @escaping () -> Content
    ) {
        self.model = model
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.headerLabel = headerLabel
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            modal
        })
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var dimmingView: some View {
        model.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if model.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var modal: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)
                .shadow(
                    color: model.colors.shadow,
                    radius: model.colors.shadowRadius,
                    x: model.colors.shadowOffset.width,
                    y: model.colors.shadowOffset.height
                )

            VStack(spacing: 0, content: {
                header
                divider
                contentView
            })
                .frame(maxHeight: .infinity, alignment: .top)
        })
            .frame(size: model.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .scaleEffect(isInternallyPresented ? 1 : model.animations.scaleEffect)
            .opacity(isInternallyPresented ? 1 : model.animations.opacity)
            .blur(radius: isInternallyPresented ? 0 : model.animations.blur)
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(alignment: model.layout.headerAlignment, spacing: model.layout.labelCloseButtonSpacing, content: {
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
                            text: title
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
                .padding(model.layout.headerMargins)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: model.layout.dividerHeight)
                .padding(model.layout.dividerMargins)
                .foregroundColor(model.colors.divider)
        }
    }

    private var contentView: some View {
        content()
            .padding(model.layout.contentMargins)
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
        withBasicAnimation(
            model.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withBasicAnimation(
            model.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            model.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
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
            .vModal(isPresented: $isPresented, headerTitle: "Lorem Ipsum", content: {
                VList(data: 0..<20, content: { num in
                    Text(String(num))
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
            })
    }
}
