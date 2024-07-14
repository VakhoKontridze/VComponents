//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
@available(macOS, unavailable) // No `View.presentationHost(...)`
@available(tvOS, unavailable) // No `View.presentationHost(...)`
@available(watchOS, unavailable) // No `View.presentationHost(...)`
@available(visionOS, unavailable) // No `View.presentationHost(...)`
struct VToast: View {
    // MARK: Properties - UI Model
    private let uiModel: VToastUIModel

    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()

    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
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
    // Prevents `dismissFromPullDown` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromPullDown: Bool = false

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

            ._getInterfaceOrientation({ interfaceOrientation = $0 })

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView)
    }
    
    private var toastView: some View {
        ZStack(content: {
            Text(text)
                .multilineTextAlignment(uiModel.textLineType.toVCoreTextLineType.textAlignment ?? .leading)
                .lineLimit(type: uiModel.textLineType.toVCoreTextLineType.textLineLimitType)
                .minimumScaleFactor(uiModel.textMinimumScaleFactor)
                .foregroundStyle(uiModel.textColor)
                .font(uiModel.textFont)
                .applyIfLet(uiModel.textDynamicTypeSizeType, transform: { $0.dynamicTypeSize(type: $1) })

                .padding(uiModel.textMargins)
                .applyModifier({ view in
                    switch uiModel.widthType {
                    case .wrapped:
                        view

                    case .stretched(let alignment, _):
                        view
                            .frame(
                                maxWidth: .infinity,
                                alignment: Alignment(
                                    horizontal: alignment,
                                    vertical: .center
                                )
                            )

                    case .fixedPoint(let width, let alignment):
                        view
                            .frame(
                                width: width,
                                alignment: Alignment(
                                    horizontal: alignment,
                                    vertical: .center
                                )
                            )

                    case .fixedFraction(let ratio, let alignment):
                        view
                            .frame(
                                width: containerSize.width * ratio,
                                alignment: Alignment(
                                    horizontal: alignment,
                                    vertical: .center
                                )
                            )
                    }
                })
                
                .clipShape(.rect(cornerRadius: cornerRadius)) // No need for clipping for preventing content from overflowing here, since background is applied via modifier
                
                .background(content: { backgroundView })
                .padding(.horizontal, uiModel.widthType.marginHorizontal)
                
                .getSize({ height = $0.height })
        })
        .drawingGroup() // Prevents UI from breaking in some scenarios, such as previews
        .offset(y: isPresentedInternally ? presentedOffset : initialOffset)

        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(dragChanged)
        )
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundStyle(uiModel.backgroundColor)
            .shadow(
                color: uiModel.shadowColor,
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }

    // MARK: Actions
    private func didTapDimmingView() {} // Not dismissible from dimming view

    private func dismissFromTimeout() {
        guard uiModel.dismissType.contains(.timeout) else { return }

        timeoutDismissTask?.cancel()
        timeoutDismissTask = Task(operation: { @MainActor in
            try? await Task.sleep(seconds: uiModel.timeoutDuration)
            guard !Task.isCancelled else { return }

            isPresented = false
        })
    }

    private func dismissFromPullDown() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            uiModel.dismissType.contains(.pullDown),
            !isBeingDismissedFromPullDown,
            isDraggedInCorrectDirection(dragValue),
            didExceedDragBackDismissDistance(dragValue)
        else {
            return
        }

        isBeingDismissedFromPullDown = true

        dismissFromPullDown()
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
            if isBeingDismissedFromPullDown {
                uiModel.pullDownDismissAnimation
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
        case .top: safeAreaInsets.top + uiModel.presentationEdgeSafeAreaInset
        case .bottom: -(safeAreaInsets.bottom + uiModel.presentationEdgeSafeAreaInset)
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

    private func didExceedDragBackDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        abs(dragValue.translation.height) >= uiModel.pullDownDismissDistance(in: height)
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
        @State private var widthType: VToastUIModel.WidthType?

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        layerID: "notifications",
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            widthType.map { uiModel.widthType = $0 }
                            uiModel.timeoutDuration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
                    )
                    .task({
                        try? await Task.sleep(seconds: 1)

                        while true {
                            widthType = .wrapped(margin: 20)
                            try? await Task.sleep(seconds: 1)

                            widthType = .stretched(alignment: .leading, margin: 20)
                            try? await Task.sleep(seconds: 1)

                            widthType = .stretched(alignment: .center, margin: 20)
                            try? await Task.sleep(seconds: 1)

                            widthType = .stretched(alignment: .trailing, margin: 20)
                            try? await Task.sleep(seconds: 1)

                            widthType = .stretched(alignment: .leading, margin: 0)
                            try? await Task.sleep(seconds: 1)

                            // `fixedPoint` not demoed

                            widthType = .fixedFraction(ratio: 0.5, alignment: .leading)
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
