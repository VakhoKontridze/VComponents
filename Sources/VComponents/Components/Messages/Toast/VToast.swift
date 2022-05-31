//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
struct VToast: View {
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VToastModel
    private let toastType: VToastType
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let text: String
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var height: CGFloat = 0
    
    // MARK: Initializers
    init(
        model: VToastModel,
        type toastType: VToastType,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        text: String
    ) {
        self.model = model
        self.toastType = toastType
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.text = text
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(.container, edges: .vertical) // Should have horizontal safe area
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, model.layout.toastHorizontalMargin) // Must be applied here
            .ignoresSafeArea(.container, edges: .vertical) // Should have horizontal safe area
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
            color: model.colors.text,
            font: .init(model.fonts.text),
            text: text
        )
            .padding(model.layout.textMargins)
            .background(background)
            .readSize(onChange: { height = $0.height })
            .offset(y: isInternallyPresented ? presentedOffset : initialOffset)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(model.colors.background)
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        let initialHeight: CGFloat = {
            switch toastType._textType {
            case .singleLine:
                let label: UILabel = .init()
                label.font = model.fonts.text
                
                return label.singleLineHeight + 2 * model.layout.textMargins.vertical
                
            case .multiLine(let alignment, let lineLimit):
                let label: UILabel = .init()
                label.textAlignment = alignment.toNSTextAlignmnet
                lineLimit.map { label.numberOfLines = $0 }
                label.font = model.fonts.text
                
                return
                    label.multiLineHeight(
                        width: UIScreen.main.bounds.width,  // width can't be calculated
                        text: text
                    ) +
                    2 * model.layout.textMargins.vertical
            }
        }()
        
        switch model.layout.presentationEdge {
        case .top: return -initialHeight
        case .bottom: return UIScreen.main.bounds.height + initialHeight
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
        guard
            let instanceID: Int = presentationMode.instanceID,
            !VToastSessionManager.shared.isVisible(instanceID)
        else {
            return
        }
        VToastSessionManager.shared.didAppear(instanceID)

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
                
                presentationMode.instanceID.map { VToastSessionManager.shared.didDisappear($0) }
            }
        )
    }

    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + model.animations.duration,
            execute: {
                guard
                    let instanceID: Int = presentationMode.instanceID,
                    VToastSessionManager.shared.isVisible(instanceID)
                else {
                    return
                }
                
                animateOut()
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
                
                presentationMode.instanceID.map { VToastSessionManager.shared.didDisappear($0) }
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
            .vToast(
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
    }
}

// MARK: - Helpers
extension TextAlignment {
    fileprivate var toNSTextAlignmnet: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .center: return .center
        case .trailing: return .right
        }
    }
}
