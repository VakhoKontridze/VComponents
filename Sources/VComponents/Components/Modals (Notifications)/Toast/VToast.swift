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

    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()

    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: VToastUIModel.Width {
        uiModel.widthGroup.current(orientation: interfaceOrientation)
    }
    
    @State private var height: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Text
    private let text: String

    // MARK: Properties - Swipe
    // Prevents `dismissFromSwipe` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

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
            .getPlatformInterfaceOrientation { interfaceOrientation = $0 }

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            //.onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView) // Not dismissible from dimming view
    }
    
    private var toastView: some View {
        ZStack {
            contentView
                .applyModifier {
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
                }

                .background { backgroundView }
                .overlay { borderView }

                .clipShape(.rect(cornerRadius: cornerRadius))

                .applyModifier {
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
                }

                .getSize { height = $0.height }

                .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        }
        // Prevents UI from breaking in some scenarios, such as previews
        .drawingGroup()
        
        // Shadow cannot be applied in `backgroundView` because of `drawingGroup` modifier written above
        .shadow(
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )

        .offset(y: isPresentedInternally ? presentedOffset : initialOffset)

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
            .applyIfLet(uiModel.textDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }

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

        // No need to handle reentrancy and cancellation
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(uiModel.timeoutDuration))
            isPresented = false
        }
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

        withAnimation(
            uiModel.appearAnimation?.toSwiftUIAnimation,
            { isPresentedInternally = true },
            completion: dismissFromTimeout
        )
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

        withAnimation(
            animation?.toSwiftUIAnimation,
            { isPresentedInternally = false },
            completion: completion
        )
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

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Singleline") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VToastUIModel = .init()
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        uiModel: {
            var uiModel: ModalPresenterRootUIModel = .init()
            uiModel.dimmingViewColor = Color.clear
            uiModel.dimmingViewTapAction = .passTapsThrough
            return uiModel
        }()
    )
}

#Preview("Multiline") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VToastUIModel = .init()
                    uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
            )
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        uiModel: {
            var uiModel: ModalPresenterRootUIModel = .init()
            uiModel.dimmingViewColor = Color.clear
            uiModel.dimmingViewTapAction = .passTapsThrough
            return uiModel
        }()
    )
}

#Preview("Top") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel: VToastUIModel = .init()
                    uiModel.presentationEdge = .top
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        uiModel: {
            var uiModel: ModalPresenterRootUIModel = .init()
            uiModel.dimmingViewColor = Color.clear
            uiModel.dimmingViewTapAction = .passTapsThrough
            return uiModel
        }()
    )
}

#Preview("Width Types") {
    @Previewable @State var isPresented: Bool = true
    
    @Previewable @State var width: VToastUIModel.Width?
    @Previewable @State var alignment: HorizontalAlignment?

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: rootAndLink.link(linkID: "preview"),
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
            .task { @MainActor in
                try? await Task.sleep(for: .seconds(1))

                while true {
                    width = .fixed(width: .fraction(0.75))
                    alignment = .leading
                    try? await Task.sleep(for: .seconds(1))

                    width = .fixed(width: .fraction(0.75))
                    alignment = .center
                    try? await Task.sleep(for: .seconds(1))

                    width = .fixed(width: .fraction(0.75))
                    alignment = .trailing
                    try? await Task.sleep(for: .seconds(1))

                    width = .wrapped(margin: .absolute(15))
                    alignment = .center
                    try? await Task.sleep(for: .seconds(1))

                    width = .wrapped(maxWidth: .fraction(0.75), margin: .absolute(15))
                    alignment = .center
                    try? await Task.sleep(for: .seconds(1))

                    width = .stretched(margin: .absolute(15))
                    alignment = .leading
                    try? await Task.sleep(for: .seconds(1))

                    width = .stretched(margin: .absolute(15))
                    alignment = .center
                    try? await Task.sleep(for: .seconds(1))

                    width = .stretched(margin: .absolute(15))
                    alignment = .trailing
                    try? await Task.sleep(for: .seconds(1))
                }
            }
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        uiModel: {
            var uiModel: ModalPresenterRootUIModel = .init()
            uiModel.dimmingViewColor = Color.clear
            uiModel.dimmingViewTapAction = .passTapsThrough
            return uiModel
        }()
    )
}

#Preview("Highlights") {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var uiModel: VToastUIModel = .init()

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: rootAndLink.link(linkID: "preview"),
                uiModel: {
                    var uiModel = uiModel
                    uiModel.timeoutDuration = 60
                    return uiModel
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
            .task { @MainActor in
                try? await Task.sleep(for: .seconds(1))

                while true {
                    uiModel = .info
                    try? await Task.sleep(for: .seconds(1))

                    uiModel = .success
                    try? await Task.sleep(for: .seconds(1))

                    uiModel = .warning
                    try? await Task.sleep(for: .seconds(1))

                    uiModel = .error
                    try? await Task.sleep(for: .seconds(1))
                }
            }
    }
    .modalPresenterRoot(
        root: rootAndLink.root,
        uiModel: {
            var uiModel: ModalPresenterRootUIModel = .init()
            uiModel.dimmingViewColor = Color.clear
            uiModel.dimmingViewTapAction = .passTapsThrough
            return uiModel
        }()
    )
}

#endif

private let rootAndLink: Preview_ModalPresenterRootAndLink = .overlay

#endif
