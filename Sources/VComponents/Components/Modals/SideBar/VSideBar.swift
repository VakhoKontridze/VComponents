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
    
    private let model: VSideBarModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let content: () -> Content
    
    @State private var isInternallyPresented: Bool = false

    // MARK: Initializers
    init(
        model: VSideBarModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        content: @escaping () -> Content
    ) {
        self.model = model
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
        model.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if model.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var sideBar: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)
                .shadow(
                    color: model.colors.shadow,
                    radius: model.colors.shadowRadius,
                    x: model.colors.shadowOffset.width,
                    y: model.colors.shadowOffset.height
                )

            content()
                .padding(model.layout.contentMargins)
                .safeAreaMarginInsets(edges: model.layout.contentSafeAreaEdges)
        })
            .frame(size: model.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .offset(x: isInternallyPresented ? 0 : -model.layout.sizes._current.size.width)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(dragChanged)
                
            ).delayTouches()
    }

    // MARK: Actions
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

    private func animateOutFromDrag() {
        withBasicAnimation(
            model.animations.dragBackDismiss,
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

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard model.misc.dismissType.contains(.dragBack) else { return }
        
        let isDraggedLeft: Bool = dragValue.translation.width <= 0
        guard isDraggedLeft else { return }

        guard abs(dragValue.translation.width) >= model.layout.dragBackDismissDistance else { return }

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
