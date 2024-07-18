//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VToast: View {
    // MARK: Properties - UI Model
    private let uiModel: VToastUIModel

    private var currentWidth: VToastUIModel.Width {
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

    // MARK: Properties - Text
    private let text: String
    
    // MARK: Properties - Frame
    @State private var height: CGFloat = 0

    // MARK: Properties - Flags
    // Prevents `dismissFromSwipe` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

    // MARK: Properties - Misc
    @State private var timeoutDismissTask: Task<Void, Never>?

    // MARK: Initializers
    init(
        uiModel: VToastUIModel,
        isPresented: Binding<Bool>,
        text: String
    ) {
        self.uiModel = uiModel
        self._isPresented = isPresented
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        toastView
            .onDisappear(perform: { timeoutDismissTask?.cancel() })

            .getPlatformInterfaceOrientation({ interfaceOrientation = $0 })

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }
    
    private var toastView: some View {
        ZStack(content: {
            contentView
                .applyModifier({
                    switch currentWidth.storage {
                    case .fixed(let width):
                        $0
                            .frame(
                                width: width.toAbsolute(dimension: containerSize.width),
                                alignment: Alignment(
                                    horizontal: uiModel.bodyHorizontalAlignment,
                                    vertical: .center
                                )
                            )

                    case .wrapped:
                        $0

                    case .wrappedMaxWidth:
                        $0

                    case .stretched:
                        $0
                            .frame(
                                maxWidth: .infinity,
                                alignment: Alignment(
                                    horizontal: uiModel.bodyHorizontalAlignment,
                                    vertical: .center
                                )
                            )
                    }
                })

                .background(content: { backgroundView })
                .overlay(content: { borderView })

                .clipShape(.rect(cornerRadius: cornerRadius))

                .applyModifier({
                    switch currentWidth.storage {
                    case .fixed:
                        $0

                    case .wrapped:
                        $0

                    case .wrappedMaxWidth(let maxWidth, _):
                        $0
                            .frame(maxWidth: maxWidth.toAbsolute(dimension: containerSize.width))

                    case .stretched:
                        $0
                    }
                })

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
        Text(text)
            .multilineTextAlignment(uiModel.textLineType.toVCoreTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.textLineType.toVCoreTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.textMinimumScaleFactor)
            .foregroundStyle(uiModel.textColor)
            .font(uiModel.textFont)
            .applyIfLet(uiModel.textDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

            .padding(uiModel.bodyMargins)
    }

    private var backgroundView: some View {
        Rectangle()
            .foregroundStyle(uiModel.backgroundColor)
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: cornerRadius)
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
            // `VToast` doesn't have an intrinsic height
            // This delay gives SwiftUI change to return height.
            // Other option was to calculate it using `UILabel`.
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

    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch uiModel.cornerRadiusType {
        case .capsule: height / 2
        case .rounded(let cornerRadius): cornerRadius
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

#Preview("Singleline", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.timeoutDuration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
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

    return ContentView()
})

#Preview("Multiline", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                            uiModel.timeoutDuration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
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

    return ContentView()
})

#Preview("Top", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.presentationEdge = .top
                            uiModel.timeoutDuration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
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

    return ContentView()
})

#Preview("Width Types", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true
        
        @State private var width: VToastUIModel.Width?
        @State private var alignment: HorizontalAlignment?

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()

                            width.map { uiModel.widthGroup = VToastUIModel.WidthGroup($0) }

                            alignment.map { uiModel.bodyHorizontalAlignment = $0 }

                            uiModel.timeoutDuration = 60

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
                    )
                    .task({
                        try? await Task.sleep(seconds: 1)

                        while true {
                            width = .fixed(width: .fraction(0.75))
                            alignment = .leading
                            try? await Task.sleep(seconds: 1)

                            width = .fixed(width: .fraction(0.75))
                            alignment = .center
                            try? await Task.sleep(seconds: 1)

                            width = .fixed(width: .fraction(0.75))
                            alignment = .trailing
                            try? await Task.sleep(seconds: 1)

                            width = .wrapped(margin: .absolute(15))
                            alignment = .center
                            try? await Task.sleep(seconds: 1)

                            width = .wrapped(maxWidth: .fraction(0.75), margin: .absolute(15))
                            alignment = .center
                            try? await Task.sleep(seconds: 1)

                            width = .stretched(margin: .absolute(15))
                            alignment = .leading
                            try? await Task.sleep(seconds: 1)

                            width = .stretched(margin: .absolute(15))
                            alignment = .center
                            try? await Task.sleep(seconds: 1)

                            width = .stretched(margin: .absolute(15))
                            alignment = .trailing
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
        }
    }

    return ContentView()
})

#Preview("Highlights", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true
        @State private var uiModel: VToastUIModel = .init()

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel = uiModel
                            uiModel.timeoutDuration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
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
        }
    }

    return ContentView()
})

#endif

#endif
