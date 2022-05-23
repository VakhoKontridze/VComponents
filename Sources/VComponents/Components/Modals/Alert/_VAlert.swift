//
//  _VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - _ V Alert
struct _VAlert<Content>: View
    where Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VAlertModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let title: String?
    private let description: String?
    private let content: (() -> Content)?
    private let buttons: [VAlertButton]
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var titleDescriptionContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0
    private var buttonsStackShouldScroll: Bool {
        let safeAreaHeight: CGFloat =
            UIScreen.main.bounds.height -
            UIDevice.safeAreaInsetTop -
            UIDevice.safeAreaInsetBottom
        
        let alertHeight: CGFloat =
            model.layout.margins.top +
            titleDescriptionContentHeight +
            buttonsStackHeight +
            model.layout.margins.bottom
        
        return alertHeight > safeAreaHeight
    }
    
    // MARK: Initializers
    init(
        model: VAlertModel,
        presentHandler: (() -> Void)?,
        dismissHandler: (() -> Void)?,
        title: String?,
        description: String?,
        content: (() -> Content)?,
        buttons: [VAlertButton]
    ) {
        self.model = model
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.title = title
        self.description = description
        self.content = content
        self.buttons = VAlertButton.process(buttons)
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            blinding
            alert
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .horizontal)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var blinding: some View {
        model.colors.blinding
            .ignoresSafeArea(.container, edges: .vertical)
    }
    
    private var alert: some View {
        VStack(spacing: 0, content: {
            VStack(spacing: 0, content: {
                titleView
                descriptionView
                contentView
            })
                .padding(model.layout.titleDescriptionContentMargins)
                .readSize(onChange: { titleDescriptionContentHeight = $0.height })
            
            buttonsScrollView
        })
            .padding(model.layout.margins)
            .frame(width: model.layout.sizes._current.size.width)
            .background(background)
            .scaleEffect(isInternallyPresented ? 1 : model.animations.scaleEffect)
            .opacity(isInternallyPresented ? 1 : model.animations.opacity)
            .blur(radius: isInternallyPresented ? 0 : model.animations.blur)
    }
    
    private var background: some View {
        VSheet(model: model.sheetSubModel)
            .shadow(
                color: model.colors.shadow,
                radius: model.colors.shadowRadius,
                x: model.colors.shadowOffset.width,
                y: model.colors.shadowOffset.height
            )
    }

    @ViewBuilder private var titleView: some View {
        if let title = title, !title.isEmpty {
            VText(
                type: .multiLine(alignment: .center, lineLimit: model.layout.titleLineLimit),
                color: model.colors.title,
                font: model.fonts.title,
                title: title
            )
                .padding(model.layout.titleMargins)
        }
    }

    @ViewBuilder private var descriptionView: some View {
        if let description = description, !description.isEmpty {
            VText(
                type: .multiLine(alignment: .center, lineLimit: model.layout.descriptionLineLimit),
                color: model.colors.description,
                font: model.fonts.description,
                title: description
            )
                .padding(model.layout.descirptionMargins)
        }
    }

    @ViewBuilder private var contentView: some View {
        if let content = content {
            content()
                .padding(model.layout.contentMargins)
        }
    }
    
    @ViewBuilder private var buttonsScrollView: some View {
        if buttonsStackShouldScroll {
            ScrollView(content: { buttonsStack })
        } else {
            buttonsStack
        }
    }
    
    private var buttonsStack: some View {
        Group(content: {
            switch buttons.count {
            case 1:
                buttonsContent()
            
            case 2:
                HStack(  // Cancel button is last
                    spacing: model.layout.horizontalButtonSpacing,
                    content: { buttonsContent(reverseOrder: true) }
                )
            
            case 3...:
                VStack(
                    spacing: model.layout.verticallButtonSpacing,
                    content: { buttonsContent() }
                )
            
            default:
                fatalError()
            }
        })
            .padding(model.layout.buttonMargins)
            .readSize(onChange: { buttonsStackHeight = $0.height })
    }
    
    private func buttonsContent(reverseOrder: Bool = false) -> some View {
        let buttons: [VAlertButton] = {
            switch reverseOrder {
            case false: return self.buttons
            case true: return self.buttons.reversed()
            }
        }()
        
        return ForEach(buttons.indices, id: \.self, content: { i in
            buttonView(buttons[i])
        })
    }
    
    private func buttonView(_ button: VAlertButton) -> some View {
        Group(content: {
            switch button._alertButton {
            case .primary:
                VAlertPrimaryButton(
                    model: model.primaryButtonSubModel,
                    action: { animateOut(completion: button.action) },
                    title: button.title
                )
                
            case .secondary:
                VAlertSecondaryButton(
                    model: model.secondaryButtonSubModel,
                    action: { animateOut(completion: button.action) },
                    title: button.title
                )
                
            case .destructive:
                VAlertSecondaryButton(
                    model: model.destructiveButtonSubModel,
                    action: { animateOut(completion: button.action) },
                    title: button.title
                )
            
            case .cancel:
                VAlertSecondaryButton(
                    model: model.secondaryButtonSubModel,
                    action: { animateOut(completion: button.action) },
                    title: button.title
                )
                
            case .ok:
                VAlertSecondaryButton(
                    model: model.secondaryButtonSubModel,
                    action: { animateOut(completion: button.action) },
                    title: button.title
                )
            }
        })
            .disabled(!button.isEnabled)
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

    private func animateOut(completion: (() -> Void)?) {
        withBasicAnimation(
            model.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?(); completion?() })
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

// MARK: - Preview
struct VAlert_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vAlert(isPresented: $isPresented, alert: {
                VAlert(
                    title: "Lorem ipsum",
                    description: "Lorem ipsum dolor sit amet",
                    content: {
                        VTextField(text: .constant("Lorem ipsum dolor sit amet"))
                    },
                    actions: [
                        .primary(action: { print("Confirmed") }, title: "Confirm"),
                        .cancel(action: { print("Cancelled") })
                    ]
                )
            })
    }
}
