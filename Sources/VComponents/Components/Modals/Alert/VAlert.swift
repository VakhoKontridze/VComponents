//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 14.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
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
            MultiplatformConstants.screenSize.height -
            MultiplatformConstants.safeAreaInsets.top -
            MultiplatformConstants.safeAreaInsets.bottom
        
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
                    .onSizeChange(perform: { titleMessageContentHeight = $0.height })

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
                type: uiModel.layout.titleTextLineType,
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
                type: uiModel.layout.messageTextLineType,
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
                
            case .content(let content):
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
            .onSizeChange(perform: { buttonsStackHeight = $0.height })
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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VAlert_Previews: PreviewProvider {
    private static var title: String { "Lorem Ipsum Dolor Sit Amet" }
    private static var message: String { "Lorem ipsum dolor sit amet" }
    
    @ViewBuilder private static func content() -> some View {
#if os(iOS)
        if #available(iOS 15.0, *) {
            VTextField(text: .constant("Lorem ipsum dolor sit amet"))
        } else {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .foregroundColor(ColorBook.accentBlue)
        }
#endif
    }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        
//        NoContentPreview().previewDisplayName("No Content")
        
//        NoButtonPreview().previewDisplayName("No Button")
//        SingleButtonPreview().previewDisplayName("Single Button")
//        ManyButtonsPreview().previewDisplayName("Many Buttons")
        
//        ButtonStatesPreview_Pressed().previewDisplayName("Button States - Pressed")
//        ButtonStatesPreview_Disabled().previewDisplayName("Button States - Disabled")
        
//        NoTitlePreview().previewDisplayName("No Title")
//        NoMessagePreview().previewDisplayName("No Message")
//        NoTitleNoMessagePreview().previewDisplayName("No Title & Message")
        
//        OnlyButtonsPreview().previewDisplayName("Only Buttons")
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct NoContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert<Never>(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .empty,
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct NoButtonPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: []
                )
            })
        }
    }
    
    private struct SingleButtonPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct ManyButtonsPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: {}, title: "Option A"),
                        VAlertSecondaryButton(action: {}, title: "Option B"),
                        VAlertDestructiveButton(action: {}, title: "Delete"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct ButtonStatesPreview_Pressed: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: {
                        var uiModel: VAlertUIModel = .init()
                        uiModel.colors.primaryButtonBackground.enabled = uiModel.colors.primaryButtonBackground.pressed
                        uiModel.colors.primaryButtonTitle.enabled = uiModel.colors.primaryButtonTitle.pressed
                        uiModel.colors.secondaryButtonBackground.enabled = uiModel.colors.secondaryButtonBackground.pressed
                        uiModel.colors.secondaryButtonTitle.enabled = uiModel.colors.secondaryButtonTitle.pressed
                        uiModel.colors.destructiveButtonBackground.enabled = uiModel.colors.destructiveButtonBackground.pressed
                        uiModel.colors.destructiveButtonTitle.enabled = uiModel.colors.destructiveButtonTitle.pressed
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: {}, title: "Option A"),
                        VAlertDestructiveButton(action: {}, title: "Delete"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct ButtonStatesPreview_Disabled: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: {}, title: "Option A").disabled(true),
                        VAlertDestructiveButton(action: {}, title: "Delete").disabled(true),
                        VAlertCancelButton(action: nil).disabled(true)
                    ]
                )
            })
        }
    }
    
    private struct NoTitlePreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: nil,
                    message: message,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct NoMessagePreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: title,
                    message: nil,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct NoTitleNoMessagePreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert(
                    uiModel: .init(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: nil,
                    message: nil,
                    content: .content(content: content),
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
    
    private struct OnlyButtonsPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VAlert<Never>(
                    uiModel: {
                        var uiModel: VAlertUIModel = .init()
                        uiModel.layout.titleMessageContentMargins.top = uiModel.layout.titleMessageContentMargins.bottom
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    title: nil,
                    message: nil,
                    content: .empty,
                    buttons: [
                        VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm"),
                        VAlertCancelButton(action: nil)
                    ]
                )
            })
        }
    }
}
