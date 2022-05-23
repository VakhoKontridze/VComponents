//
//  _VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - _ V Side Bar
struct _VSideBar<Content>: View where Content: View {
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
            blinding
            sideBar
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var blinding: some View {
        model.colors.blinding
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
            .offset(x: isInternallyPresented ? 0 : -model.layout.sizes._current.size.width)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(dragChanged)
                
            ).delayTouches()
    }

    // MARK: Actions
    private func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isInternallyPresented = true })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.appear?.duration ?? 0),
            execute: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
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

    private func animateOutFromDrag() {
        withAnimation(model.animations.dragBackDissapear?.asSwiftUIAnimation, { isInternallyPresented = false })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.dragBackDissapear?.duration ?? 0),
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
            .vSideBar(isPresented: $isPresented, sideBar: {
                VSideBar(content: {
                    VList(data: 0..<20, rowContent: { num in
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                })
            })
    }
}
