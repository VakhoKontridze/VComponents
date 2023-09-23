//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert
@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VAlert<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VAlertUIModel

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: CGFloat {
        uiModel.widths.current(_interfaceOrientation: interfaceOrientation).toAbsolute(in: containerSize.width)
    }

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handlers
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Text, Content, and Buttons
    private let title: String?
    private let message: String?
    private let content: VAlertContent<Content>
    private let buttons: [any VAlertButtonProtocol]

    // MARK: Properties - Frame
    @State private var alertHeight: CGFloat = 0
    @State private var titleMessageContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0
    
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
        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)

        ._getInterfaceOrientation({ newValue in
            if
                uiModel.dismissesKeyboardWhenInterfaceOrientationChanges,
                newValue != interfaceOrientation
            {
#if canImport(UIKit) && !os(watchOS)
                UIApplication.shared.sendResignFirstResponderAction()
#endif
            }

            interfaceOrientation = newValue
        })

        .onAppear(perform: animateIn)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )
    }
    
    private var dimmingView: some View {
        uiModel.dimmingViewColor
            .contentShape(Rectangle())
    }
    
    private var alert: some View {
        ZStack(content: {
            VGroupBox(uiModel: uiModel.groupBoxSubUIModel)
                .shadow(
                    color: uiModel.shadowColor,
                    radius: uiModel.shadowRadius,
                    offset: uiModel.shadowOffset
                )

            VStack(spacing: 0, content: {
                VStack(spacing: 0, content: {
                    titleView
                    messageView
                    contentView
                })
                .padding(uiModel.titleTextMessageTextAndContentMargins)
                .getSize({ titleMessageContentHeight = $0.height })

                buttonsScrollView
            })
            .getSize({ alertHeight = $0.height })
        })
        .frame( // Max dimension fixes issue of safe areas and/or landscape
            maxWidth: currentWidth,
            maxHeight: alertHeight
        )
        .safeAreaMargins(edges: .vertical, insets: safeAreaInsets) // Since alert doesn't have an explicit height, prevents clipping into safe areas
        .scaleEffect(isInternallyPresented ? 1 : uiModel.scaleEffect)
    }
    
    @ViewBuilder private var titleView: some View {
        if let title, !title.isEmpty {
            Text(title)
                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.titleTextColor)
                .font(uiModel.titleTextFont)

                .fixedSize(horizontal: false, vertical: true)

                .padding(uiModel.titleTextMargins)
        }
    }
    
    @ViewBuilder private var messageView: some View {
        if let message, !message.isEmpty {
            Text(message)
                .multilineTextAlignment(uiModel.messageTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.messageTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.messageTextColor)
                .font(uiModel.messageTextFont)

                .fixedSize(horizontal: false, vertical: true)

                .padding(uiModel.messageTextMargins)
        }
    }
    
    private var contentView: some View {
        Group(content: {
            switch content {
            case .empty:
                EmptyView()
                
            case .content(let content):
                content()
                    .padding(uiModel.contentMargins)
            }
        })
        .clipped() // Prevents flickering issues with keyboard handling system
    }
    
    @ViewBuilder private var buttonsScrollView: some View {
        if isButtonContentLargerThanContainer {
            ScrollView(content: { buttonStack })
                .padding(.bottom, 1) // Fixes SwiftUI `ScrollView` safe area bug

        } else {
            buttonStack
        }
    }
    
    private var buttonStack: some View {
        Group(content: {
            switch buttons.count {
            case 1:
                buttonContent()
                
            case 2:
                HStack(
                    spacing: uiModel.horizontalButtonSpacing,
                    content: { buttonContent(reversesOrder: true) } // Cancel button is last
                )
                
            case 3...:
                VStack(
                    spacing: uiModel.verticalButtonSpacing,
                    content: { buttonContent() }
                )
                
            default:
                fatalError()
            }
        })
        .padding(uiModel.buttonMargins)
        .getSize({ buttonsStackHeight = $0.height })
    }
    
    private func buttonContent(reversesOrder: Bool = false) -> some View {
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
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = true },
                completion: { presentHandler?() }
            )

        } else {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isInternallyPresented = true },
                completion: {
                    DispatchQueue.main.async(execute: { presentHandler?() })
                }
            )
        }
    }
    
    private func animateOut(completion: (() -> Void)?) {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    dismissHandler?()
                    completion?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    DispatchQueue.main.async(execute: { dismissHandler?(); completion?() })
                }
            )
        }
    }
    
    private func animateOutFromExternalDismiss() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
            )
        }
    }

    // MARK: Size that Fits
    private var isButtonContentLargerThanContainer: Bool {
        let safeAreaHeight: CGFloat =
            containerSize.height -
            safeAreaInsets.top -
            safeAreaInsets.bottom

        let alertHeight: CGFloat =
            titleMessageContentHeight +
            buttonsStackHeight

        return alertHeight > safeAreaHeight
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VAlert_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            
//            NoContentPreview().previewDisplayName("No Content")
//
//            NoButtonPreview().previewDisplayName("No Button")
//            SingleButtonPreview().previewDisplayName("Single Button")
//            ManyButtonsPreview().previewDisplayName("Many Buttons")
//
//            ButtonStatesPreview_Pressed().previewDisplayName("Button States - Pressed")
//            ButtonStatesPreview_Disabled().previewDisplayName("Button States - Disabled")

//            NoTitlePreview().previewDisplayName("No Title")
//            NoMessagePreview().previewDisplayName("No Message")
//            NoTitleNoMessagePreview().previewDisplayName("No Title & Message")

//            OnlyButtonsPreview().previewDisplayName("Only Buttons")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem Ipsum Dolor Sit Amet".pseudoRTL(languageDirection) }
    private static var message: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }

    @ViewBuilder private static func content() -> some View {
        TextField( // `VTextField` causes preview crash
            "",
            text: .constant("Lorem ipsum dolor sit amet".pseudoRTL(languageDirection))
        )
        .textFieldStyle(.roundedBorder)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct NoContentPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct NoButtonPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {}
                    )
            })
        }
    }
    
    private struct SingleButtonPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .secondary, action: nil, title: "Ok")
                        }
                    )
            })
        }
    }
    
    private struct ManyButtonsPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Option A")
                            VAlertButton(role: .secondary, action: nil, title: "Option B")
                            VAlertButton(role: .destructive, action: nil, title: "Delete")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct ButtonStatesPreview_Pressed: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()

                            uiModel.colorScheme = VAlert_Previews.colorScheme

                            uiModel.primaryButtonBackgroundColors.enabled = uiModel.primaryButtonBackgroundColors.pressed
                            uiModel.primaryButtonTitleColors.enabled = uiModel.primaryButtonTitleColors.pressed

                            uiModel.secondaryButtonBackgroundColors.enabled = uiModel.secondaryButtonBackgroundColors.pressed
                            uiModel.secondaryButtonTitleColors.enabled = uiModel.secondaryButtonTitleColors.pressed

                            uiModel.destructiveButtonBackgroundColors.enabled = uiModel.destructiveButtonBackgroundColors.pressed
                            uiModel.destructiveButtonTitleColors.enabled = uiModel.destructiveButtonTitleColors.pressed

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Option A")
                            VAlertButton(role: .destructive, action: nil, title: "Delete")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct ButtonStatesPreview_Disabled: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Option A").disabled(true)
                            VAlertButton(role: .destructive, action: nil, title: "Delete").disabled(true)
                            VAlertButton(role: .cancel, action: nil, title: "Cancel").disabled(true)
                        }
                    )
            })
        }
    }
    
    private struct NoTitlePreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: nil,
                        message: message,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct NoMessagePreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: title,
                        message: nil,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct NoTitleNoMessagePreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: nil,
                        message: nil,
                        content: content,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
    
    private struct OnlyButtonsPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vAlert(
                        id: "preview",
                        uiModel: {
                            var uiModel: VAlertUIModel = .init()
                            uiModel.colorScheme = VAlert_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        title: nil,
                        message: nil,
                        actions: {
                            VAlertButton(role: .primary, action: nil, title: "Confirm")
                            VAlertButton(role: .cancel, action: nil, title: "Cancel")
                        }
                    )
            })
        }
    }
}
