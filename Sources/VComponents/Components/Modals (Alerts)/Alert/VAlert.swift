//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import OSLog
import VCore

@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VAlert<Content>: View
    where Content: View
{
    // MARK: Properties - Appearance
    private let appearance: VAlertAppearance
    
    @Environment(\.modalPresenterInterfaceOrientation) private var interfaceOrientation: PlatformInterfaceOrientation
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: VAlertAppearance.Width {
        appearance.widthGroup.current(orientation: interfaceOrientation)
    }

    @State private var alertHeight: CGFloat = 0
    @State private var titleMessageContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode! // Unsafe
    
    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Text, Content, and Buttons
    private let title: String?
    private let message: String?
    private let content: VAlertContent<Content>
    private let buttons: [any VAlertButtonProtocol]
    
    // MARK: Initializers
    init(
        appearance: VAlertAppearance,
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        content: VAlertContent<Content>,
        buttons: [any VAlertButtonProtocol]
    ) {
        self.appearance = appearance
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.content = content
        self.buttons = VAlertButtonBuilder.process(buttons)
    }
    
    // MARK: Body
    var body: some View {
        alertView
            .onChange(of: interfaceOrientation) { (_, newValue) in
                if
                    appearance.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
            }

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }
    
    private var alertView: some View {
        VGroupBox(appearance: appearance.groupBoxAppearance) {
            ZStack {
                alertContentView
            }
            .apply {
                switch currentWidth {
                case .fixed(let width):
                    $0
                        .frame(width: width.toAbsolute(dimension: containerSize.width))

                case .stretched:
                    $0
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxHeight: .infinity)
        
        .shadow(
            color: appearance.shadowColor,
            radius: appearance.shadowRadius,
            offset: appearance.shadowOffset
        )

        .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        .padding(.vertical, appearance.marginVertical)
        .safeAreaPaddings(edges: .vertical, insets: safeAreaInsets) // Since alert doesn't have an explicit height, prevents clipping into safe areas

        .scaleEffect(isPresentedInternally ? 1 : appearance.scaleEffect)
    }

    private var alertContentView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                titleText
                messageText
                contentView
            }
            .padding(appearance.titleTextAndMessageTextAndContentMargins)
            .onGeometryChange(of: { $0.size.height }) { titleMessageContentHeight = $0 }

            buttonsScrollView
        }
        .onGeometryChange(of: { $0.size.height }) { alertHeight = $0 }
    }

    @ViewBuilder
    private var titleText: some View {
        if let title = title?.nonEmpty {
            Text(title)
                .multilineTextAlignment(appearance.titleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: appearance.titleTextLineType.textLineLimitType)
                .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
                .foregroundStyle(appearance.titleTextColor)
                .font(appearance.titleTextFont)
                .applyIfLet(appearance.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: appearance.titleTextFrameAlignment,
                        vertical: .center
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

                .padding(appearance.titleTextMargins)
        }
    }
    
    @ViewBuilder
    private var messageText: some View {
        if let message = message?.nonEmpty {
            Text(message)
                .multilineTextAlignment(appearance.messageTextLineType.textAlignment ?? .leading)
                .lineLimit(type: appearance.messageTextLineType.textLineLimitType)
                .minimumScaleFactor(appearance.messageTextMinimumScaleFactor)
                .foregroundStyle(appearance.messageTextColor)
                .font(appearance.messageTextFont)
                .applyIfLet(appearance.messageTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: appearance.messageTextFrameAlignment,
                        vertical: .center
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

                .padding(appearance.messageTextMargins)
        }
    }
    
    private var contentView: some View {
        Group {
            switch content {
            case .empty:
                EmptyView()
                
            case .content(let content):
                content()
                    .padding(appearance.contentMargins)
            }
        }
    }
    
    @ViewBuilder
    private var buttonsScrollView: some View {
        if isButtonContentLargerThanContainer {
            ScrollView { buttonStackView }
                .clipped()

        } else {
            buttonStackView
        }
    }
    
    private var buttonStackView: some View {
        ZStack {
            switch buttons.count {
            case 1:
                buttonContentView()
                
            case 2:
                HStack(spacing: appearance.horizontalButtonSpacing) {
                    buttonContentView(reversesOrder: true) // Cancel button is last
                }
                
            case 3...:
                VStack(spacing: appearance.verticalButtonSpacing) {
                    buttonContentView()
                }
                
            default:
                EmptyView()
                    .onFirstAppear {
                        Logger.alert.critical("Invalid number of buttons '(\(buttons.count))' in 'VAlert'")
                    }
            }
        }
        .padding(appearance.buttonMargins)
        .onGeometryChange(of: { $0.size.height }) { buttonsStackHeight = $0 }
    }
    
    private func buttonContentView(
        reversesOrder: Bool = false
    ) -> some View {
        let buttons: [any VAlertButtonProtocol] = self.buttons.reversed(reversesOrder)

        // Native `View.alert(...)` doesn't react to changes, so using `offset` as ID is okay
        return ForEach(buttons.enumeratedArray(), id: \.offset) { (i, button) in
            button.makeBody(
                appearance: appearance,
                animateOutHandler: { completion in
                    isPresented = false
                    completion?()
                }
            )
        }
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true }
        )
    }

    private func animateOut(
        completion: @escaping () -> Void
    ) {
        withAnimation(
            appearance.disappearAnimation,
            { isPresentedInternally = false },
            completion: completion
        )
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

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Title, Message, Content") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                content: { content },
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Title, Message") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Title, Content") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: nil,
                content: { content },
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Message, Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: "Lorem ipsum dolor sit amet",
                content: { content },
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Title") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: nil,
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Message") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: nil,
                content: { content },
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("No Declared Buttons") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {}
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("One Button") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Ok", role: .secondary)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Many Buttons") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Option A", role: .primary)
                    VAlertButton(action: nil, title: "Option B", role: .secondary)
                    VAlertButton(action: nil, title: "Delete", role: .destructive)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Width Types") {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var width: VAlertAppearance.Width?

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VAlertAppearance = .init()
                    width.map { appearance.widthGroup = VAlertAppearance.WidthGroup($0) }
                    return appearance
                }(),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
            .onFirstAppear {
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1))
                    
                    while true {
                        width = .fixed(width: .fraction(0.75))
                        try? await Task.sleep(for: .seconds(1))
                        
                        width = .stretched(margin: .absolute(15))
                        try? await Task.sleep(for: .seconds(1))
                    }
                }
            }
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Max Height") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    for i in 0..<20 {
                        VAlertButton(action: nil, title: "Confirm \(i+1)", role: .primary)
                    }

                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Button States (Pressed)") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VAlertAppearance = .init()

                    appearance.primaryButtonBackgroundColors.enabled = appearance.primaryButtonBackgroundColors.pressed
                    appearance.primaryButtonTextColors.enabled = appearance.primaryButtonTextColors.pressed

                    appearance.secondaryButtonBackgroundColors.enabled = appearance.secondaryButtonBackgroundColors.pressed
                    appearance.secondaryButtonTextColors.enabled = appearance.secondaryButtonTextColors.pressed

                    appearance.destructiveButtonBackgroundColors.enabled = appearance.destructiveButtonBackgroundColors.pressed
                    appearance.destructiveButtonTextColors.enabled = appearance.destructiveButtonTextColors.pressed

                    return appearance
                }(),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Option A", role: .primary)
                    VAlertButton(action: nil, title: "Delete", role: .destructive)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Button States (Disabled)") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VAlertAppearance = .init()

                    appearance.primaryButtonBackgroundColors.enabled = appearance.primaryButtonBackgroundColors.disabled
                    appearance.primaryButtonTextColors.enabled = appearance.primaryButtonTextColors.disabled

                    appearance.secondaryButtonBackgroundColors.enabled = appearance.secondaryButtonBackgroundColors.disabled
                    appearance.secondaryButtonTextColors.enabled = appearance.secondaryButtonTextColors.disabled

                    appearance.destructiveButtonBackgroundColors.enabled = appearance.destructiveButtonBackgroundColors.disabled
                    appearance.destructiveButtonTextColors.enabled = appearance.destructiveButtonTextColors.disabled

                    return appearance
                }(),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Option A", role: .primary)
                    VAlertButton(action: nil, title: "Delete", role: .destructive)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#endif

private let rootAndLink: ModalPresenterRootAndLink = .overlay

@ViewBuilder
private var content: some View {
    TextField( // `VTextField` causes preview crash
        "",
        text: .constant("Lorem ipsum dolor sit amet")
    )
    .textFieldStyle(.roundedBorder)
}

#endif
