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
    private let model: VToastModel
    private let toastType: VToastType
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let title: String
    
    @State private var height: CGFloat = 0
    
    // MARK: Initializers
    init(
        model: VToastModel,
        toastType: VToastType,
        isPresented: Binding<Bool>,
        title: String
    ) {
        self.model = model
        self.toastType = toastType
        self._isHCPresented = isPresented
        self.title = title
    }

    // MARK: Body
    var body: some View {
        Group(content: {
            contentView
        })
            .ignoresSafeArea(.all, edges: .all)
            .frame(maxHeight: .infinity, alignment: .top)
            .onAppear(perform: animateIn)
            .onAppear(perform: animateOutAfterLifecycle)
    }
    
    private var contentView: some View {
        textView
            .background(background)
            .frame(maxWidth: model.layout.maxWidth)
            .readSize(onChange: { height = $0.height })
            .offset(y: isViewPresented ? presentedOffset : initialOffset)
    }
    
    private var textView: some View {
        VText(
            type: toastType,
            color: model.colors.title,
            font: model.fonts.title,
            title: title
        )
            .padding(model.layout.contentMargins)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(model.colors.background)
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top: return -height
        case .bottom: return UIScreen.main.bounds.height // FIXME: Add landscape
        }
    }
    
    private var presentedOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top:
            return UIDevice.safeAreaInsetTop + model.layout.presentationOffsetFromSafeEdge
        
        case .bottom:
            return UIScreen.main.bounds.height - UIDevice.safeAreaInsetBottom - height - model.layout.presentationOffsetFromSafeEdge // FIXME: Add landscape
        }
    }

    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch model.layout.cornerRadiusType {
        case .rounded: return height / 2
        case .custom(let value): return value
        }
    }

    // MARK: Animations
    private func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isViewPresented = true })
    }
    
    private func animateOut() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }
    
    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + model.animations.duration, execute: animateOut)
    }
}

// MARK: - Preview
struct _VToast_Previews: PreviewProvider {
    static var previews: some View {
        _VToast(
            model: .init(),
            toastType: .singleLine,
            isPresented: .constant(true),
            title: "Lorem ipsum"
        )
    }
}
