//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - V Alert
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VAlert<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VAlertUIModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()
    
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: VAlertUIModel.Width {
        uiModel.widthGroup.current(orientation: interfaceOrientation)
    }

    @State private var alertHeight: CGFloat = 0
    @State private var titleMessageContentHeight: CGFloat = 0
    @State private var buttonsStackHeight: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode!
    
    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Text, Content, and Buttons
    private let title: String?
    private let message: String?
    private let content: VAlertContent<Content>
    private let buttons: [any VAlertButtonProtocol]
    
    // MARK: Initializers
    init(
        uiModel: VAlertUIModel,
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        content: VAlertContent<Content>,
        buttons: [any VAlertButtonProtocol]
    ) {
        self.uiModel = uiModel
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.content = content
        self.buttons = VAlertButtonBuilder.process(buttons)
    }
    
    // MARK: Body
    var body: some View {
        alertView
            .getPlatformInterfaceOrientation { newValue in
                if
                    uiModel.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }

                interfaceOrientation = newValue
            }

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }
    
    private var alertView: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel) {
            ZStack {
                alertContentView
            }
            .applyModifier {
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
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )

        .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        .padding(.vertical, uiModel.marginVertical)
        .safeAreaPaddings(edges: .vertical, insets: safeAreaInsets) // Since alert doesn't have an explicit height, prevents clipping into safe areas

        .scaleEffect(isPresentedInternally ? 1 : uiModel.scaleEffect)
    }

    private var alertContentView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                titleView
                messageView
                contentView
            }
            .padding(uiModel.titleTextMessageTextAndContentMargins)
            .getSize { titleMessageContentHeight = $0.height }

            buttonsScrollView
        }
        .getSize { alertHeight = $0.height }
    }

    @ViewBuilder
    private var titleView: some View {
        if let title = title?.nonEmpty {
            Text(title)
                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.titleTextColor)
                .font(uiModel.titleTextFont)
                .applyIfLet(uiModel.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.titleTextFrameAlignment,
                        vertical: .center
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

                .padding(uiModel.titleTextMargins)
        }
    }
    
    @ViewBuilder
    private var messageView: some View {
        if let message = message?.nonEmpty {
            Text(message)
                .multilineTextAlignment(uiModel.messageTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.messageTextLineType.textLineLimitType)
                .foregroundStyle(uiModel.messageTextColor)
                .font(uiModel.messageTextFont)
                .applyIfLet(uiModel.messageTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.messageTextFrameAlignment,
                        vertical: .center
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

                .padding(uiModel.messageTextMargins)
        }
    }
    
    private var contentView: some View {
        Group {
            switch content {
            case .empty:
                EmptyView()
                
            case .content(let content):
                content()
                    .padding(uiModel.contentMargins)
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
        Group {
            switch buttons.count {
            case 1:
                buttonContentView()
                
            case 2:
                HStack(spacing: uiModel.horizontalButtonSpacing) {
                    buttonContentView(reversesOrder: true) // Cancel button is last
                }
                
            case 3...:
                VStack(spacing: uiModel.verticalButtonSpacing) {
                    buttonContentView()
                }
                
            default:
                fatalError()
            }
        }
        .padding(uiModel.buttonMargins)
        .getSize { buttonsStackHeight = $0.height }
    }
    
    private func buttonContentView(
        reversesOrder: Bool = false
    ) -> some View {
        let buttons: [any VAlertButtonProtocol] = self.buttons.reversed(reversesOrder)

        // Native `View.alert(...)` doesn't react to changes, so using `offset` as ID is okay
        return ForEach(buttons.enumeratedArray(), id: \.offset) { (i, button) in
            button.makeBody(
                uiModel: uiModel,
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
            uiModel.appearAnimation?.toSwiftUIAnimation,
            { isPresentedInternally = true }
        )
    }

    private func animateOut(
        completion: @escaping () -> Void
    ) {
        withAnimation(
            uiModel.disappearAnimation?.toSwiftUIAnimation,
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

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Title, Message, Content") {
    @Previewable @State var isPresented: Bool = true
    
    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                content: { previewContent },
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: nil,
                content: { previewContent },
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
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: "Lorem ipsum dolor sit amet",
                content: { previewContent },
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented,
                title: nil,
                message: nil,
                content: { previewContent },
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
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
    @Previewable @State var width: VAlertUIModel.Width?

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VAlertUIModel = .init()
                    width.map { uiModel.widthGroup = VAlertUIModel.WidthGroup($0) }
                    return uiModel
                }(),
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet",
                actions: {
                    VAlertButton(action: nil, title: "Confirm", role: .primary)
                    VAlertButton(action: nil, title: "Cancel", role: .cancel)
                }
            )
            .task { @MainActor in
                try? await Task.sleep(for: .seconds(1))

                while true {
                    width = .fixed(width: .fraction(0.74))
                    try? await Task.sleep(for: .seconds(1))

                    width = .stretched(margin: .absolute(15))
                    try? await Task.sleep(for: .seconds(1))
                }
            }
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Max Height") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
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
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VAlertUIModel = .init()

                    uiModel.primaryButtonBackgroundColors.enabled = uiModel.primaryButtonBackgroundColors.pressed
                    uiModel.primaryButtonTitleTextColors.enabled = uiModel.primaryButtonTitleTextColors.pressed

                    uiModel.secondaryButtonBackgroundColors.enabled = uiModel.secondaryButtonBackgroundColors.pressed
                    uiModel.secondaryButtonTitleTextColors.enabled = uiModel.secondaryButtonTitleTextColors.pressed

                    uiModel.destructiveButtonBackgroundColors.enabled = uiModel.destructiveButtonBackgroundColors.pressed
                    uiModel.destructiveButtonTitleTextColors.enabled = uiModel.destructiveButtonTitleTextColors.pressed

                    return uiModel
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
        PreviewModalLauncherView(isPresented: $isPresented)
            .vAlert(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VAlertUIModel = .init()

                    uiModel.primaryButtonBackgroundColors.enabled = uiModel.primaryButtonBackgroundColors.disabled
                    uiModel.primaryButtonTitleTextColors.enabled = uiModel.primaryButtonTitleTextColors.disabled

                    uiModel.secondaryButtonBackgroundColors.enabled = uiModel.secondaryButtonBackgroundColors.disabled
                    uiModel.secondaryButtonTitleTextColors.enabled = uiModel.secondaryButtonTitleTextColors.disabled

                    uiModel.destructiveButtonBackgroundColors.enabled = uiModel.destructiveButtonBackgroundColors.disabled
                    uiModel.destructiveButtonTitleTextColors.enabled = uiModel.destructiveButtonTitleTextColors.disabled

                    return uiModel
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

private let rootAndLink: Preview_ModalPresenterRootAndLink = .overlay

@ViewBuilder
private var previewContent: some View {
    TextField( // `VTextField` causes preview crash
        "",
        text: .constant("Lorem ipsum dolor sit amet")
    )
    .textFieldStyle(.roundedBorder)
}

#endif
