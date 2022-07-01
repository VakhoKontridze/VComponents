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
    
    private let uiModel: VModalUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let headerLabel: VModalHeaderLabel<HeaderLabel>
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || uiModel.misc.dismissType.hasButton }
    private var hasDivider: Bool { hasHeader && uiModel.layout.dividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    // MARK: Initializers
    init(
        uiModel: VModalUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        headerLabel: VModalHeaderLabel<HeaderLabel>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var dimmingView: some View {
        uiModel.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if uiModel.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var modal: some View {
        ZStack(content: {
            VSheet(uiModel: uiModel.sheetSubUIModel)
                .shadow(
                    color: uiModel.colors.shadow,
                    radius: uiModel.colors.shadowRadius,
                    x: uiModel.colors.shadowOffset.width,
                    y: uiModel.colors.shadowOffset.height
                )

            VStack(spacing: 0, content: {
                header
                divider
                contentView
            })
                .frame(maxHeight: .infinity, alignment: .top)
                .cornerRadius(uiModel.layout.cornerRadius, corners: uiModel.layout.roundedCorners) // Fixes clipping when `contentMargin` is zero
        })
            .frame(size: uiModel.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeybordSafeAreaEdges)
            .scaleEffect(isInternallyPresented ? 1 : uiModel.animations.scaleEffect)
            .opacity(isInternallyPresented ? 1 : uiModel.animations.opacity)
            .blur(radius: isInternallyPresented ? 0 : uiModel.animations.blur)
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(alignment: uiModel.layout.headerAlignment, spacing: uiModel.layout.labelCloseButtonSpacing, content: {
                Group(content: {
                    if uiModel.misc.dismissType.contains(.leadingButton) {
                        closeButton
                    } else if uiModel.misc.dismissType.contains(.trailingButton) {
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
                            color: uiModel.colors.headerTitle,
                            font: uiModel.fonts.header,
                            text: title
                        )
                        
                    case .custom(let label):
                        label()
                    }
                })
                    .layoutPriority(1)

                Group(content: {
                    if uiModel.misc.dismissType.contains(.trailingButton) {
                        closeButton
                    } else if uiModel.misc.dismissType.contains(.leadingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
                .padding(uiModel.layout.headerMargins)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: uiModel.layout.dividerHeight)
                .padding(uiModel.layout.dividerMargins)
                .foregroundColor(uiModel.colors.divider)
        }
    }

    private var contentView: some View {
        content()
            .padding(uiModel.layout.contentMargins)
            .frame(maxHeight: .infinity)
    }

    private var closeButton: some View {
        VSquareButton.close(
            uiModel: uiModel.closeButtonSubUIModel,
            action: animateOut
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: uiModel.layout.closeButtonDimension)
    }

    // MARK: Animations
    private func animateIn() {
        withBasicAnimation(
            uiModel.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.animations.disappear,
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
