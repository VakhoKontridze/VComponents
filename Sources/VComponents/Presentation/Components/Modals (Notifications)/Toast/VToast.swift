//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VToast: View {
    // MARK: Properties - Appearance
    private let appearance: VToastAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    private var currentWidth: VToastAppearance.Width {
        appearance.widthGroup.current(orientation: modalPresenterContext.interfaceOrientation)
    }
    
    @State private var height: CGFloat = 0

    // MARK: Properties - Presentation API
    @Environment(ModalPresenterContext.self) private var modalPresenterContext: ModalPresenterContext

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Text
    private let text: String

    // MARK: Properties - Swipe
    // Prevents `dismissFromSwipe` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()
    
    // MARK: Properties - Subscriptions
    @State private var dismissFromTimeoutTask: Task<Void, Never>?

    // MARK: Initializers
    init(
        appearance: VToastAppearance,
        isPresented: Binding<Bool>,
        text: String
    ) {
        self.appearance = appearance
        self._isPresented = isPresented
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        toastView
            .onReceive(modalPresenterContext.presentPublisher, perform: onPresent)
            .onReceive(modalPresenterContext.dismissPublisher, perform: onDismiss)
            //.onReceive(modalPresenterContext.dimmingViewTapActionPublisher, perform: onTapDimmingView) // Not dismissible from dimming view
        
            .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }
    
    private var toastView: some View {
        ZStack {
            contentView
                .apply {
                    switch currentWidth.storage {
                    case .fixed(let width):
                        $0
                            .frame(
                                width: width.toAbsolute(dimension: modalPresenterContext.containerSize.width),
                                alignment: Alignment(
                                    horizontal: appearance.bodyHorizontalAlignment,
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
                                    horizontal: appearance.bodyHorizontalAlignment,
                                    vertical: .center
                                )
                            )
                    }
                }

                .background { backgroundView }
                .overlay { borderView }

                .clipShape(.rect(cornerRadius: cornerRadius))

                .apply {
                    switch currentWidth.storage {
                    case .fixed:
                        $0

                    case .wrapped:
                        $0

                    case .wrappedMaxWidth(let maxWidth, _):
                        $0
                            .frame(maxWidth: maxWidth.toAbsolute(dimension: modalPresenterContext.containerSize.width))

                    case .stretched:
                        $0
                    }
                }

                .onGeometryChange(of: { $0.size.height }) { height = $0 }

                .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: modalPresenterContext.containerSize.width))
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
        Text(text)
            .textConfiguration(appearance.textConfiguration)
            .padding(appearance.bodyMargins)
    }

    private var backgroundView: some View {
        Rectangle()
            .foregroundStyle(appearance.backgroundColor)
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(appearance.borderColor, lineWidth: borderWidth)
        }
    }

    // MARK: Actions
    private func dismissFromTimeout() {
        guard appearance.dismissType.contains(.timeout) else { return }

        guard dismissFromTimeoutTask == nil else { return }
        dismissFromTimeoutTask = Task {
            defer { dismissFromTimeoutTask = nil }
            
            do {
                try await Task.sleep(for: .seconds(appearance.timeoutDuration))
            } catch {
                return
            }
            
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
    private func onPresent() {
        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true },
            completion: dismissFromTimeout
        )
        
        Task {
            sensoryFeedbackTrigger()
        }
    }

    private func onDismiss(
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
        case .top: modalPresenterContext.safeAreaInsets.top + appearance.marginPresentedEdge
        case .bottom: -(modalPresenterContext.safeAreaInsets.bottom + appearance.marginPresentedEdge)
        }
    }

    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch appearance.cornerRadiusType {
        case .capsule: height / 2
        case .rounded(let cornerRadius): cornerRadius
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
}

#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Singleline") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VToastAppearance = .init()
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
    }
    .modalPresenterRoot(
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

#Preview("Multiline") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VToastAppearance = .init()
                    appearance.textConfiguration.lineType = .multiLine(alignment: .leading, lineLimit: 10)
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
            )
    }
    .modalPresenterRoot(
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

#Preview("Top") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VToastAppearance = .init()
                    appearance.presentationEdge = .top
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
            )
    }
    .modalPresenterRoot(
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
    
    @Previewable @State var width: VToastAppearance.Width?
    @Previewable @State var alignment: HorizontalAlignment?

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VToastAppearance = .init()

                    width.map { appearance.widthGroup = VToastAppearance.WidthGroup($0) }

                    alignment.map { appearance.bodyHorizontalAlignment = $0 }

                    appearance.timeoutDuration = 60

                    return appearance
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
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
                            alignment = .leading
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .fixed(width: .fraction(0.75))
                            alignment = .center
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .fixed(width: .fraction(0.75))
                            alignment = .trailing
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .wrapped(margin: .absolute(15))
                            alignment = .center
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .wrapped(maxWidth: .fraction(0.75), margin: .absolute(15))
                            alignment = .center
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .stretched(margin: .absolute(15))
                            alignment = .leading
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .stretched(margin: .absolute(15))
                            alignment = .center
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            width = .stretched(margin: .absolute(15))
                            alignment = .trailing
                        }
                    }
                }
            }
    }
    .modalPresenterRoot(
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
    @Previewable @State var appearance: VToastAppearance = .init()

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vToast(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance = appearance
                    appearance.timeoutDuration = 60
                    return appearance
                }(),
                isPresented: $isPresented,
                text: "Lorem ipsum dolor sit amet"
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
                            
                            appearance = .info
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            appearance = .success
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            appearance = .warning
                            
                            do {
                                try await Task.sleep(for: .seconds(1))
                            } catch {
                                return
                            }
                            
                            appearance = .error
                        }
                    }
                }
            }
    }
    .modalPresenterRoot(
        appearance: {
            var appearance: ModalPresenterRootAppearance = .init()
            appearance.dimmingViewColor = Color.clear
            appearance.dimmingViewTapAction = .passTapsThrough
            return appearance
        }()
    )
}

#endif

#endif
