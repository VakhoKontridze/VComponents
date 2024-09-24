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
    // MARK: Properties - UI Model
    private let uiModel: VNotificationUIModel

    private var currentWidth: VNotificationUIModel.Width {
        uiModel.widthGroup.current(orientation: interfaceOrientation)
    }

    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize
    @Environment(\.presentationHostSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()

    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: VNotificationContent<CustomContent>

    // MARK: Properties - Frame
    @State private var height: CGFloat = 0

    // MARK: Properties - Flags
    // Prevents `dismissFromSwipe` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

    // MARK: Properties - Misc
    @State private var timeoutDismissTask: Task<Void, Never>?

    // MARK: Initializers
    init(
        uiModel: VNotificationUIModel,
        isPresented: Binding<Bool>,
        content: VNotificationContent<CustomContent>
    ) {
        self.uiModel = uiModel
        self._isPresented = isPresented
        self.content = content
    }

    // MARK: Body
    var body: some View {
        notificationView
            .onDisappear(perform: { timeoutDismissTask?.cancel() })

            .getPlatformInterfaceOrientation({ interfaceOrientation = $0 })

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }

    private var notificationView: some View {
        ZStack(content: {
            contentView
                .applyModifier({
                    switch currentWidth {
                    case .fixed(let width):
                        $0
                            .frame(width: width.toAbsolute(dimension: containerSize.width))

                    case .stretched:
                        $0
                            .frame(maxWidth: .infinity)
                    }
                })

                .background(content: { backgroundView })
                .overlay(content: { borderView })

                .clipShape(.rect(cornerRadius: uiModel.cornerRadius))

                .getSize({ height = $0.height })

                .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        })
        // Prevents UI from breaking in some scenarios, such as previews
        .drawingGroup()

        .offset(y: isPresentedInternally ? presentedOffset : initialOffset)

        // Shadow cannot be applied in `backgroundView` because of `drawingGroup` modifier written above
        .shadow(
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )

        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(dragChanged)
        )
    }

    private var contentView: some View {
        Group(content: {
            switch content {
            case .iconTitleMessage(let icon, let title, let message):
                HStack(
                    spacing: uiModel.iconAndTitleTextMessageTextSpacing,
                    content: {
                        iconView(icon: icon)
                        textsView(title: title, message: message)
                    }
                )

            case .custom(let custom):
                custom()
            }
        })
        .padding(uiModel.bodyMargins)
    }

    @ViewBuilder
    private func iconView(
        icon: Image?
    ) -> some View {
        if let icon {
            ZStack(content: {
                RoundedRectangle(cornerRadius: uiModel.iconBackgroundCornerRadius)
                    .frame(size: uiModel.iconBackgroundSize)
                    .foregroundStyle(uiModel.iconBackgroundColor)

                icon
                    .applyIf(uiModel.isIconResizable, transform: { $0.resizable() })
                    .applyIfLet(uiModel.iconContentMode, transform: { $0.aspectRatio(nil, contentMode: $1) })
                    .applyIfLet(uiModel.iconColor, transform: { $0.foregroundStyle($1) })
                    .applyIfLet(uiModel.iconOpacity, transform: { $0.opacity($1) })
                    .font(uiModel.iconFont)
                    .applyIfLet(uiModel.iconDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })
                    .frame(size: uiModel.iconSize)
            })
        }
    }

    private func textsView(
        title: String?,
        message: String?
    ) -> some View {
        // Space should still be reserved for both title and message, even if they are `nil`
        _textsView(
            title: title ?? "A",
            message: message ?? "A"
        )
        .opacity(0)
        .overlay(content: {
            _textsView(
                title: title,
                message: message
            )
        })
    }

    private func _textsView(
        title: String?,
        message: String?
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: uiModel.titleTextAndMessageTextSpacing,
            content: {
                titleText(title: title)
                messageText(message: message)
            }
        )
    }

    @ViewBuilder
    private func titleText(
        title: String?
    ) -> some View {
        if let title {
            Text(title)
                .multilineTextAlignment(uiModel.titleTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.titleTextLineType.textLineLimitType)
                .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
                .foregroundStyle(uiModel.titleTextColor)
                .font(uiModel.titleTextFont)
                .applyIfLet(uiModel.titleTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.titleTextFrameAlignment,
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
                .multilineTextAlignment(uiModel.messageTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.messageTextLineType.textLineLimitType)
                .minimumScaleFactor(uiModel.messageTextMinimumScaleFactor)
                .foregroundStyle(uiModel.messageTextColor)
                .font(uiModel.messageTextFont)
                .applyIfLet(uiModel.messageTextDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

                .frame(
                    maxWidth: .infinity,
                    alignment: Alignment(
                        horizontal: uiModel.messageTextFrameAlignment,
                        vertical: .center
                    )
                )
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var backgroundView: some View {
        Rectangle()
            .foregroundStyle(uiModel.backgroundColor)
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColor, lineWidth: borderWidth)
        }
    }

    // MARK: Actions
    private func dismissFromTimeout() {
        guard uiModel.dismissType.contains(.timeout) else { return }

        timeoutDismissTask?.cancel()
        timeoutDismissTask = Task(operation: { @MainActor in
            try? await Task.sleep(seconds: uiModel.timeoutDuration)
            guard !Task.isCancelled else { return }

            isPresented = false
        })
    }

    private func dismissFromSwipe() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            uiModel.dismissType.contains(.swipe),
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

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = true },
                completion: dismissFromTimeout
            )

        } else {
            // `VNotification` doesn't have an intrinsic height
            // This delay gives SwiftUI change to return height.
            Task(operation: { @MainActor in
                withBasicAnimation(
                    uiModel.appearAnimation,
                    body: { isPresentedInternally = true },
                    completion: dismissFromTimeout
                )
            })
        }
    }

    private func animateOut(
        completion: @escaping () -> Void
    ) {
        let animation: BasicAnimation? = {
            if isBeingDismissedFromSwipe {
                uiModel.swipeDismissAnimation
            } else {
                uiModel.disappearAnimation
            }
        }()

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                animation?.toSwiftUIAnimation,
                { isPresentedInternally = false },
                completion: completion
            )

        } else {
            withBasicAnimation(
                animation,
                body: { isPresentedInternally = false },
                completion: completion
            )
        }
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch uiModel.presentationEdge {
        case .top: -height
        case .bottom: height
        }
    }

    private var presentedOffset: CGFloat {
        switch uiModel.presentationEdge {
        case .top: safeAreaInsets.top + uiModel.marginPresentedEdge
        case .bottom: -(safeAreaInsets.bottom + uiModel.marginPresentedEdge)
        }
    }

    // MARK: Presentation Edge Dismiss
    private func isDraggedInCorrectDirection(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.presentationEdge {
        case .top: dragValue.translation.height <= 0
        case .bottom: dragValue.translation.height >= 0
        }
    }

    private func didExceedSwipeDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        abs(dragValue.translation.height) >= uiModel.swipeDismissDistance(in: height)
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playNotification(uiModel.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("Icon & Title & Message", body: {
    Preview_ContentView(
        icon: Image(systemName: "swift"),
        title: "Lorem Ipsum Dolor Sit Amet",
        message: "Lorem ipsum dolor sit amet"
    )
})

#Preview("Title & Message", body: {
    Preview_ContentView(
        icon: nil,
        title: "Lorem Ipsum Dolor Sit Amet",
        message: "Lorem ipsum dolor sit amet"
    )
})

#Preview("Icon & Title", body: {
    Preview_ContentView(
        icon: Image(systemName: "swift"),
        title: "Lorem Ipsum Dolor Sit Amet",
        message: nil
    )
})

#Preview("Icon & Message", body: {
    Preview_ContentView(
        icon: Image(systemName: "swift"),
        title: nil,
        message: "Lorem ipsum dolor sit amet"
    )
})

#Preview("No Content", body: {
    Preview_ContentView(
        icon: nil,
        title: nil,
        message: nil
    )
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Bottom", body: {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer(content: {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vNotification(
                layerID: "notifications",
                id: "preview",
                uiModel: {
                    var uiModel: VNotificationUIModel = .init()
                    uiModel.presentationEdge = .bottom
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                icon: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
    })
    .presentationHostLayer(
        id: "notifications",
        uiModel: {
            var uiModel: PresentationHostLayerUIModel = .init()
            uiModel.dimmingViewTapAction = .passTapsThrough
            uiModel.dimmingViewColor = Color.clear
            return uiModel
        }()
    )
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Width Types", body: {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var width: VNotificationUIModel.Width?

    PreviewContainer(content: {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vNotification(
                layerID: "notifications",
                id: "preview",
                uiModel: {
                    var uiModel: VNotificationUIModel = .init()

                    width.map { uiModel.widthGroup = VNotificationUIModel.WidthGroup($0) }
                    
                    uiModel.timeoutDuration = 60

                    return uiModel
                }(),
                isPresented: $isPresented,
                icon: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
            .task({
                try? await Task.sleep(seconds: 1)

                while true {
                    width = .fixed(width: .fraction(0.75))
                    try? await Task.sleep(seconds: 1)

                    width = .stretched(margin: .absolute(15))
                    try? await Task.sleep(seconds: 1)
                }
            })
    })
    .presentationHostLayer(
        id: "notifications",
        uiModel: {
            var uiModel: PresentationHostLayerUIModel = .init()
            uiModel.dimmingViewTapAction = .passTapsThrough
            uiModel.dimmingViewColor = Color.clear
            return uiModel
        }()
    )
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Highlights", body: {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var uiModel: VNotificationUIModel = .init()
    
    PreviewContainer(content: {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vNotification(
                layerID: "notifications",
                id: "preview",
                uiModel: {
                    var uiModel: VNotificationUIModel = uiModel
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                icon: Image(systemName: "swift"),
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet"
            )
            .task({
                try? await Task.sleep(seconds: 1)
                
                while true {
                    uiModel = .info
                    try? await Task.sleep(seconds: 1)
                    
                    uiModel = .success
                    try? await Task.sleep(seconds: 1)
                    
                    uiModel = .warning
                    try? await Task.sleep(seconds: 1)
                    
                    uiModel = .error
                    try? await Task.sleep(seconds: 1)
                }
            })
    })
    .presentationHostLayer(
        id: "notifications",
        uiModel: {
            var uiModel: PresentationHostLayerUIModel = .init()
            uiModel.dimmingViewTapAction = .passTapsThrough
            uiModel.dimmingViewColor = Color.clear
            return uiModel
        }()
    )
})

private struct Preview_ContentView: View {
    @State private var isPresented: Bool = true

    private let icon: Image?
    private let title: String?
    private let message: String?

    init(
        icon: Image?,
        title: String?,
        message: String?
    ) {
        self.icon = icon
        self.title = title
        self.message = message
    }

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vNotification(
                    layerID: "notifications",
                    id: "preview",
                    uiModel: {
                        var uiModel: VNotificationUIModel = .init()
                        uiModel.timeoutDuration = 60
                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    icon: icon,
                    title: title,
                    message: message
                )
        })
        .presentationHostLayer(
            id: "notifications",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewTapAction = .passTapsThrough
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#endif
