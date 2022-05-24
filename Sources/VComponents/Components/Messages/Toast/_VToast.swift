//
//  _VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - _ V Toast
struct _VToast: View {
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VToastModel
    private let toastType: VToastType
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let title: String
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var height: CGFloat = 0
    
    // MARK: Initializers
    init(
        model: VToastModel,
        type toastType: VToastType,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        title: String
    ) {
        self.model = model
        self.toastType = toastType
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.title = title
    }

    // MARK: Body
    var body: some View {
        Group(content: {
            contentView
        })
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateIn)
            .onAppear(perform: animateOutAfterLifecycle)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var contentView: some View {
        VText(
            type: toastType,
            color: model.colors.title,
            font: model.fonts.title,
            title: title
        )
            .padding(model.layout.titleMargins)
            .background(background)
            .frame(maxWidth: model.layout.sizes._current.size.width)
            .readSize(onChange: { height = $0.height })
            .offset(y: isInternallyPresented ? presentedOffset : initialOffset)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(model.colors.background)
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top: return -height
        case .bottom: return UIScreen.main.bounds.height
        }
    }

    private var presentedOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top:
            return
                UIDevice.safeAreaInsetTop +
                model.layout.presentationEdgeSafeAreaInset

        case .bottom:
            return
                UIScreen.main.bounds.height -
                UIDevice.safeAreaInsetBottom -
                height -
                model.layout.presentationEdgeSafeAreaInset
        }
    }

    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch model.layout.cornerRadiusType {
        case .capsule: return height / 2
        case .rounded(let cornerRadius): return cornerRadius
        }
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

    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + model.animations.duration,
            execute: animateOut
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

// MARK: - Preview
struct _VToast_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vToast(isPresented: $isPresented, toast: {
                VToast(title: "Lorem ipsum")
            })
    }
}
