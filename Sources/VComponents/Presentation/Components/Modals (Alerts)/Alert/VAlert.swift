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

    private var currentWidth: VAlertAppearance.Width {
        appearance.widthGroup.current(orientation: modalPresenterContext.interfaceOrientation)
    }

    @State private var alertHeight: CGFloat = 0
    @State private var titleMessageContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(ModalPresenterContext.self) private var modalPresenterContext: ModalPresenterContext
    
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
            .onChange(of: modalPresenterContext.interfaceOrientation) { (_, newValue) in
                if
                    appearance.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != modalPresenterContext.interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
            }

            .onReceive(modalPresenterContext.presentPublisher, perform: onPresent)
            .onReceive(modalPresenterContext.dismissPublisher, perform: onDismiss)
            //.onReceive(modalPresenterContext.dimmingViewTapActionPublisher, perform: onTapDimmingView) // Not dismissible from dimming view
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
                        .frame(width: width.toAbsolute(dimension: modalPresenterContext.containerSize.width))

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

        .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: modalPresenterContext.containerSize.width))
        .padding(.vertical, appearance.marginVertical)
        .safeAreaPaddings(edges: .vertical, insets: modalPresenterContext.safeAreaInsets) // Since alert doesn't have an explicit height, prevents clipping into safe areas

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
                .textConfiguration(appearance.titleTextConfiguration)

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
                .textConfiguration(appearance.messageTextConfiguration)

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
                    .onAppear { isFirst in
                        if isFirst {
                            Logger.alert.critical("Invalid number of buttons '(\(buttons.count))' in 'VAlert'")
                        }
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
        return ForEach(buttons.enumeratedArray(), id: \.offset) { (_, button) in
            button.makeBody(
                appearance: appearance,
                animateOut: { completion in
                    isPresented = false
                    completion?()
                }
            )
        }
    }

    // MARK: Lifecycle Animations
    private func onPresent() {
        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true }
        )
    }

    private func onDismiss(
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
            modalPresenterContext.containerSize.height -
            modalPresenterContext.safeAreaInsets.top -
            modalPresenterContext.safeAreaInsets.bottom

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
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("Title, Message") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot()
}

#Preview("Title, Content") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("Message, Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("Title") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: nil,
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot()
}

#Preview("Message") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
    }
    .modalPresenterRoot()
}

#Preview("Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("No Declared Buttons") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {}
            )
    }
    .modalPresenterRoot()
}

#Preview("One Button") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "OK", role: .secondary)
                }
            )
    }
    .modalPresenterRoot()
}

#Preview("Many Buttons") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("Width Types") {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var width: VAlertAppearance.Width?

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
            .onAppear { isFirst in
                if isFirst {
                    Task {
                        while true {
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .fixed(width: .fraction(0.75))

                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .stretched(margin: .absolute(15))
                        }
                    }
                }
            }
    }
    .modalPresenterRoot()
}

#Preview("Max Height") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
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
    .modalPresenterRoot()
}

#Preview("Button States (Pressed)") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VAlertAppearance = .init()

                    appearance.primaryButtonAppearance.backgroundColors.enabled = appearance.primaryButtonAppearance.backgroundColors.pressed
                    appearance.primaryButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.primaryButtonAppearance.labelTextConfiguration.colors!.pressed // Unsafe (DEBUG)

                    appearance.secondaryButtonAppearance.backgroundColors.enabled = appearance.secondaryButtonAppearance.backgroundColors.pressed
                    appearance.secondaryButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.secondaryButtonAppearance.labelTextConfiguration.colors!.pressed // Unsafe (DEBUG)

                    appearance.destructiveButtonAppearance.backgroundColors.enabled = appearance.destructiveButtonAppearance.backgroundColors.pressed
                    appearance.destructiveButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.destructiveButtonAppearance.labelTextConfiguration.colors!.pressed // Unsafe (DEBUG)

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
    .modalPresenterRoot()
}

#Preview("Button States (Disabled)") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VAlertAppearance = .init()

                    appearance.primaryButtonAppearance.backgroundColors.enabled = appearance.primaryButtonAppearance.backgroundColors.disabled
                    appearance.primaryButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.primaryButtonAppearance.labelTextConfiguration.colors!.disabled // Unsafe (DEBUG)

                    appearance.secondaryButtonAppearance.backgroundColors.enabled = appearance.secondaryButtonAppearance.backgroundColors.disabled
                    appearance.secondaryButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.secondaryButtonAppearance.labelTextConfiguration.colors!.disabled // Unsafe (DEBUG)

                    appearance.destructiveButtonAppearance.backgroundColors.enabled = appearance.destructiveButtonAppearance.backgroundColors.disabled
                    appearance.destructiveButtonAppearance.labelTextConfiguration.colors!.enabled = appearance.destructiveButtonAppearance.labelTextConfiguration.colors!.disabled // Unsafe (DEBUG)

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
    .modalPresenterRoot()
}

@ViewBuilder
private var content: some View {
    TextField( // `VTextField` causes preview crash
        "",
        text: .constant("Lorem ipsum dolor sit amet")
    )
    .textFieldStyle(.roundedBorder)
}

#endif

#endif
