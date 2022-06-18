//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Side Bar
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VSideBarUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let content: () -> Content
    
    @State private var isInternallyPresented: Bool = false

    // MARK: Initializers
    init(
        uiModel: VSideBarUIModel,
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
        ZStack(alignment: .leading, content: {
            dimmingView
            sideBar
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

    private var sideBar: some View {
        ZStack(content: {
            VSheet(uiModel: uiModel.sheetSubUIModel)
                .shadow(
                    color: uiModel.colors.shadow,
                    radius: uiModel.colors.shadowRadius,
                    x: uiModel.colors.shadowOffset.width,
                    y: uiModel.colors.shadowOffset.height
                )

            content()
                .padding(uiModel.layout.contentMargins)
                .safeAreaMarginInsets(edges: uiModel.layout.contentSafeAreaEdges)
        })
            .frame(size: uiModel.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeybordSafeAreaEdges)
            .offset(x: isInternallyPresented ? 0 : -uiModel.layout.sizes._current.size.width)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(dragChanged)
                
            ).delayTouches()
    }

    // MARK: Actions
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

    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.animations.dragBackDismiss,
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

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard uiModel.misc.dismissType.contains(.dragBack) else { return }
        
        let isDraggedLeft: Bool = dragValue.translation.width <= 0
        guard isDraggedLeft else { return }

        guard abs(dragValue.translation.width) >= uiModel.layout.dragBackDismissDistance else { return }

        animateOutFromDrag()
    }
}

// MARK: - Preview
struct VSideBar_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vSideBar(
                isPresented: $isPresented,
                content: {
                    VList(data: 0..<20, content: { num in
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            )
    }
}
