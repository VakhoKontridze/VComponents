//
//  VNotification.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 15.07.24.
//

import SwiftUI
import VCore

// MARK: - V Notification
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VNotification<CustomContent>: View where CustomContent: View {
    // MARK: Properties - Appearance
    private let appearance: VNotificationAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Environment(\.modalPresenterInterfaceOrientation) private var interfaceOrientation: PlatformInterfaceOrientation
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    private var currentWidth: VNotificationAppearance.Width {
        appearance.widthGroup.current(orientation: interfaceOrientation)
    }
    
    @State private var height: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: VNotificationContent<CustomContent>

    // MARK: Properties - Swipe
    // Prevents `dismissFromSwipe` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

    // MARK: Initializers
    init(
        appearance: VNotificationAppearance,
        isPresented: Binding<Bool>,
        content: VNotificationContent<CustomContent>
    ) {
        self.appearance = appearance
        self._isPresented = isPresented
        self.content = content
    }

    // MARK: Body
    var body: some View {
        notificationView
            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }

    private var notificationView: some View {
        ZStack {
            contentView
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

                .background { backgroundView }
                .overlay { borderView }

                .clipShape(.rect(cornerRadius: appearance.cornerRadius))

                .onGeometryChange(of: { $0.size.height }) { height = $0 }

                .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        }
        // Prevents UI from breaking in some scenarios, such as previews
        .drawingGroup()
        
        // Shadow cannot be applied in `backgroundView` because of `drawingGroup` modifier written above
        .shadow(
            color: appearance.shadowColor,
            radius: appearance.shadowRadius,
            offset: appearance.shadowOffset
        )

        .offset(y: isPresentedInternally ? presentedOffset : initialOffset)

        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(dragChanged)
        )
    }

    private var contentView: some View {
        Group {
            switch content {
            case .imageAndTitleAndMessage(let image, let title, let message):
                HStack(spacing: appearance.imageAndTextsSpacing) {
                    imageView(image: image)
                    titleAndMessageView(title: title, message: message)
                }

            case .custom(let builder):
                builder()
            }
        }
        .padding(appearance.bodyMargins)
    }

    @ViewBuilder
    private func imageView(
        image: Image?
    ) -> some View {
        if let image {
            ZStack {
                RoundedRectangle(cornerRadius: appearance.imageBackgroundCornerRadius)
                    .frame(size: appearance.imageBackgroundSize)
                    .foregroundStyle(appearance.imageBackgroundColor)

                image
                    .applyIf(appearance.isImageResizable) { $0.resizable() }
                    .applyIfLet(appearance.imageContentMode) { $0.aspectRatio(nil, contentMode: $1) }
                    .applyIfLet(appearance.imageColor) { $0.foregroundStyle($1) }
                    .applyIfLet(appearance.imageOpacity) { $0.opacity($1) }
                    .font(appearance.imageFont)
                    .applyIfLet(appearance.imageDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
                    .frame(size: appearance.imageSize)
            }
        }
    }

    private func titleAndMessageView(
        title: String?,
        message: String?
    ) -> some View {
        // Space should still be reserved for both title and message, even if they are `nil`
        _titleAndMessageView(
            title: title ?? "A",
            message: message ?? "A"
        )
        .opacity(0)
        .overlay {
            _titleAndMessageView(
                title: title,
                message: message
            )
        }
    }

    private func _titleAndMessageView(
        title: String?,
        message: String?
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: appearance.titleTextAndMessageTextSpacing
        ) {
            titleText(title: title)
            messageText(message: message)
        }
    }

    @ViewBuilder
    private func titleText(
        title: String?
    ) -> some View {
        if let title {
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
        }
    }

    @ViewBuilder
    private func messageText(
        message: String?
    ) -> some View {
        if let message {
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
        }
    }

    private var backgroundView: some View {
        Rectangle()
            .foregroundStyle(appearance.backgroundColor)
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColor, lineWidth: borderWidth)
        }
    }

    // MARK: Actions
    private func dismissFromTimeout() {
        guard appearance.dismissType.contains(.timeout) else { return }

        // No need to handle reentrancy and cancellation
        Task { @MainActor in
            try await Task.sleep(for: .seconds(appearance.timeoutDuration))
            isPresented = false
        }
    }

    private func dismissFromSwipe() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            appearance.dismissType.contains(.swipe),
            !isBeingDismissedFromSwipe,
            isDraggedInCorrectDirection(dragValue),
            didExceedSwipeDismissDistance(dragValue)
        else {
            return
        }

        isBeingDismissedFromSwipe = true

        dismissFromSwipe()
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        playHapticEffect()

        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true },
            completion: dismissFromTimeout
        )
    }

    private func animateOut(
        completion: @escaping () -> Void
    ) {
        let animation: Animation? = {
            if isBeingDismissedFromSwipe {
                appearance.swipeDismissAnimation
            } else {
                appearance.disappearAnimation
            }
        }()

        withAnimation(
            animation,
            { isPresentedInternally = false },
            completion: completion
        )
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch appearance.presentationEdge {
        case .top: -height
        case .bottom: height
        }
    }

    private var presentedOffset: CGFloat {
        switch appearance.presentationEdge {
        case .top: safeAreaInsets.top + appearance.marginPresentedEdge
        case .bottom: -(safeAreaInsets.bottom + appearance.marginPresentedEdge)
        }
    }

    // MARK: Presentation Edge Dismiss
    private func isDraggedInCorrectDirection(_ dragValue: DragGesture.Value) -> Bool {
        switch appearance.presentationEdge {
        case .top: dragValue.translation.height <= 0
        case .bottom: dragValue.translation.height >= 0
        }
    }

    private func didExceedSwipeDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        abs(dragValue.translation.height) >= appearance.swipeDismissDistance(in: height)
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playNotification(appearance.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Image & Title & Message") {
    ContentView(
        image: Image(systemName: "swift"),
        title: "Lorem Ipsum Dolor Sit Amet",
        message: "Lorem ipsum dolor sit amet"
    )
}

#Preview("Title & Message") {
    ContentView(
        image: nil,
        title: "Lorem Ipsum Dolor Sit Amet",
        message: "Lorem ipsum dolor sit amet"
    )
}

#Preview("Image & Title") {
    ContentView(
        image: Image(systemName: "swift"),
        title: "Lorem Ipsum Dolor Sit Amet",
        message: nil
    )
}

#Preview("Image & Message") {
    ContentView(
        image: Image(systemName: "swift"),
        title: nil,
        message: "Lorem ipsum dolor sit amet"
    )
}

#Preview("No Content") {
    ContentView(
        image: nil,
        title: nil,
        message: nil
    )
}

#Preview("Bottom") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vNotification(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VNotificationAppearance = .init()
                    appearance.presentationEdge = .bottom
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                image: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

#Preview("Width Types") {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var width: VNotificationAppearance.Width?

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vNotification(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VNotificationAppearance = .init()

                    width.map { appearance.widthGroup = VNotificationAppearance.WidthGroup($0) }
                    
                    appearance.timeoutDuration = 60

                    return appearance
                }(),
                isPresented: $isPresented,
                image: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
            .onFirstAppear {
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(1))
                    
                    while true {
                        width = .fixed(width: .fraction(0.75))
                        try await Task.sleep(for: .seconds(1))
                        
                        width = .stretched(margin: .absolute(15))
                        try await Task.sleep(for: .seconds(1))
                    }
                }
            }
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

#Preview("Highlights") {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var appearance: VNotificationAppearance = .init()
    
    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vNotification(
                link: rootAndLink.link(linkID: "preview"),
                appearance: {
                    var appearance: VNotificationAppearance = appearance
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                image: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
            .onFirstAppear {
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(1))
                    
                    while true {
                        appearance = .info
                        try await Task.sleep(for: .seconds(1))
                        
                        appearance = .success
                        try await Task.sleep(for: .seconds(1))
                        
                        appearance = .warning
                        try await Task.sleep(for: .seconds(1))
                        
                        appearance = .error
                        try await Task.sleep(for: .seconds(1))
                    }
                }
            }
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

private struct ContentView: View {
    @State private var isPresented: Bool = true

    private let image: Image?
    private let title: String?
    private let message: String?

    init(
        image: Image?,
        title: String?,
        message: String?
    ) {
        self.image = image
        self.title = title
        self.message = message
    }

    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vNotification(
                    link: rootAndLink.link(linkID: "preview"),
                    appearance: {
                        var appearance: VNotificationAppearance = .init()
                        appearance.timeoutDuration = 60
                        return appearance
                    }(),
                    isPresented: $isPresented,
                    image: image,
                    title: title,
                    message: message
                )
        }
        .modalPresenterRoot(
            root: rootAndLink.root,
            appearance: {
                var appearance: ModalPresenterRootAppearance = .init()
                appearance.dimmingViewColor = Color.clear
                appearance.dimmingViewTapAction = .passTapsThrough
                return appearance
            }()
        )
    }
}

#endif

private let rootAndLink: ModalPresenterRootAndLink = .overlay

#endif
