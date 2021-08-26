//
//  _VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- _ V Toast
struct _VToast: View {
    // MARK: Properties
    private let model: VToastModel
    private let toastType: VToastType
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let title: String
    
    @State private var height: CGFloat = .zero
    
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
}

// MARK:- Body
extension _VToast {
    var body: some View {
        Group(content: {
            contentView
        })
            .edgesIgnoringSafeArea(.all)
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
            font: model.fonts.text,
            color: model.colors.text,
            title: title
        )
            .padding(.horizontal, model.layout.contentMargins.horizontal)
            .padding(.vertical, model.layout.contentMargins.vertical)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(model.colors.background)
    }
}

// MARK:- Offsets
extension _VToast {
    private var initialOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top: return -height
        case .bottom: return UIScreen.main.bounds.height
        }
    }
    
    private var presentedOffset: CGFloat {
        switch model.layout.presentationEdge {
        case .top:
            return UIView.topSafeAreaHeight + model.layout.presentationOffsetFromSafeEdge
        
        case .bottom:
            return UIScreen.main.bounds.height - UIView.bottomSafeAreaHeight - height - model.layout.presentationOffsetFromSafeEdge
        }
    }
}

// MARK:- Corner Radius
extension _VToast {
    private var cornerRadius: CGFloat {
        switch model.layout.cornerRadiusType {
        case .rounded: return height / 2
        case .custom(let value): return value
        }
    }
}

// MARK:- Animations
extension _VToast {
    func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isViewPresented = true })
    }
    
    func animateOut() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }
    
    func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + model.animations.duration, execute: animateOut)
    }
}

// MARK:- Preview
struct _VToast_Previews: PreviewProvider {
    static var previews: some View {
        _VToast(
            model: .init(),
            toastType: .oneLine,
            isPresented: .constant(true),
            title: "Lorem ipsum"
        )
    }
}
