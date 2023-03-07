//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert
struct VAlert<Content>: View
    where Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VAlertUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let title: String?
    private let message: String?
    private let content: VAlertContent<Content>
    private let buttons: [any VAlertButtonProtocol]
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var titleMessageContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0
    private var buttonsStackShouldScroll: Bool {
        let safeAreaHeight: CGFloat =
            UIScreen.main.bounds.height -
            UIDevice.safeAreaInsetTop -
            UIDevice.safeAreaInsetBottom
        
        let alertHeight: CGFloat =
            titleMessageContentHeight +
            buttonsStackHeight
        
        return alertHeight > safeAreaHeight
    }
    
    // MARK: Initializers
    init(
        uiModel: VAlertUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        title: String?,
        message: String?,
        content: VAlertContent<Content>,
        buttons: [any VAlertButtonProtocol]
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.title = title
        self.message = message
        self.content = content
        self.buttons = VAlertButtonBuilder.process(buttons)
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            alert
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
    }
    
    private var alert: some View {
        VSheet(uiModel: uiModel.sheetSubUIModel, content: {
            VStack(spacing: 0, content: {
                VStack(spacing: 0, content: {
                    titleView
                    messageView
                    contentView
                })
                    .padding(uiModel.layout.titleMessageContentMargins)
                    .readSize(onChange: { titleMessageContentHeight = $0.height })

                buttonsScrollView
            })
        })
            .frame(width: uiModel.layout.sizes._current.size.width)
            .ignoresSafeArea(.container, edges: .horizontal)
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

    @ViewBuilder private var titleView: some View {
        if let title, !title.isEmpty {
            VText(
                type: .multiLine(alignment: .center, lineLimit: uiModel.layout.titleLineLimit),
                color: uiModel.colors.title,
                font: uiModel.fonts.title,
                text: title
            )
                .padding(uiModel.layout.titleMargins)
        }
    }

    @ViewBuilder private var messageView: some View {
        if let message, !message.isEmpty {
            VText(
                type: .multiLine(alignment: .center, lineLimit: uiModel.layout.messageLineLimit),
                color: uiModel.colors.message,
                font: uiModel.fonts.message,
                text: message
            )
                .padding(uiModel.layout.messageMargins)
        }
    }

    private var contentView: some View {
        Group(content: {
            switch content {
            case .empty:
                EmptyView()
                
            case .custom(let content):
                content()
                    .padding(uiModel.layout.contentMargins)
            }
        })
    }
    
    @ViewBuilder private var buttonsScrollView: some View {
        if buttonsStackShouldScroll {
            ScrollView(content: { buttonsStack }).padding(.bottom, 1) // Fixes SwiftUI `ScrollView` safe area bug
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
                HStack(
                    spacing: uiModel.layout.horizontalButtonSpacing,
                    content: { buttonsContent(reversesOrder: true) } // Cancel button is last
                )
            
            case 3...:
                VStack(
                    spacing: uiModel.layout.verticalButtonSpacing,
                    content: { buttonsContent() }
                )
            
            default:
                fatalError()
            }
        })
            .padding(uiModel.layout.buttonMargins)
            .readSize(onChange: { buttonsStackHeight = $0.height })
    }
    
    private func buttonsContent(reversesOrder: Bool = false) -> some View {
        let buttons: [any VAlertButtonProtocol] = self.buttons.reversed(if: reversesOrder)
        
        return ForEach(buttons.indices, id: \.self, content: { i in
            buttons[i].makeBody(
                uiModel: uiModel,
                animateOut: { animateOut(completion: $0) }
            )
        })
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

    private func animateOut(completion: (() -> Void)?) {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?(); completion?() })
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

// MARK: - Preview
struct VAlert_Previews: PreviewProvider {
    static var previews: some View {
        VAlert(
            uiModel: .init(),
            onPresent: nil,
            onDismiss: nil,
            title: "Lorem Ipsum Dolor Sit Amet",
            message: "Lorem ipsum dolor sit amet",
            content: {
                .custom(content: {
                    VTextField(text: .constant("Lorem ipsum dolor sit amet"))
                })
            }(),
            buttons: [
                VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                VAlertCancelButton(action: nil)
            ]
        )
    }
}
