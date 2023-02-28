//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal
struct VModal<Content>: View
    where Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VModalUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    @State private var headerLabel: VModalHeaderLabelPreferenceKey.Value = VModalHeaderLabelPreferenceKey.defaultValue
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || uiModel.misc.dismissType.hasButton }
    private var hasDivider: Bool { hasHeader && uiModel.layout.dividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    // MARK: Initializers
    init(
        uiModel: VModalUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
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
            .onPreferenceChange(VModalHeaderLabelPreferenceKey.self, perform: {
                headerLabel = $0
            })
    }
    
    private var dimmingView: some View {
        uiModel.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if uiModel.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var modal: some View {
        VSheet(uiModel: uiModel.sheetSubUIModel, content: {
            VStack(spacing: 0, content: {
                VStack(spacing: 0, content: {
                    header
                    divider
                })
                    .safeAreaMarginInsets(edges: uiModel.layout.headerSafeAreaEdges)

                contentView
            })
        })
            .frame(size: uiModel.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeyboardSafeAreaEdges)
            .scaleEffect(isInternallyPresented ? 1 : uiModel.animations.scaleEffect)
            .opacity(isInternallyPresented ? 1 : uiModel.animations.opacity)
            .blur(radius: isInternallyPresented ? 0 : uiModel.animations.blur)
            .shadow(
                color: uiModel.colors.shadow,
                radius: uiModel.colors.shadowRadius,
                x: uiModel.colors.shadowOffset.width,
                y: uiModel.colors.shadowOffset.height
            )
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
        VRoundedButton(
            uiModel: uiModel.closeButtonSubUIModel,
            action: animateOut,
            icon: ImageBook.xMark
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: uiModel.layout.closeButtonSubUIModel.dimension)
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
            .vModal(
                id: "modal_preview",
                isPresented: $isPresented,
                content: {
                    List(content: {
                        ForEach(0..<20, content: { num in
                            VListRow(separator: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                                Text(String(num))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            })
                        })
                    })
                        .vListStyle()
                        .vModalHeaderTitle("Lorem Ipsum")
                }
            )
    }
}
