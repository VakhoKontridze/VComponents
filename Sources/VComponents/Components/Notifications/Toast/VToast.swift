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

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    @State private var lifecycleDismissTask: Task<Void, Never>?

    // MARK: Properties - Text
    private let text: String
    
    // MARK: Properties - Frame
    @State private var height: CGFloat = 0

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
        ZStack(alignment: uiModel.presentationEdge.toAlignment, content: {
            dimmingView
            toastView
        })
        .onDisappear(perform: { lifecycleDismissTask?.cancel() })

        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)

        ._getInterfaceOrientation({ interfaceOrientation = $0 })

        .onReceive(presentationMode.presentPublisher, perform: animateIn)
        .onReceive(presentationMode.dismissPublisher, perform: animateOut)
    }

    private var dimmingView: some View {
        Color.clear
            .contentShape(.rect)
    }
    
    private var toastView: some View {
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
            .getSize({ height = $0.height })
            .padding(.horizontal, uiModel.widthType.marginHorizontal)
            .offset(y: isPresentedInternally ? presentedOffset : initialOffset)
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
    
    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch uiModel.presentationEdge {
        case .top: -(safeAreaInsets.top + height)
        case .bottom: safeAreaInsets.bottom + height
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

    // MARK: Lifecycle
    private func dismissAfterLifecycle() {
        lifecycleDismissTask?.cancel()
        lifecycleDismissTask = Task(operation: { @MainActor in
            try? await Task.sleep(seconds: uiModel.duration)
            guard !Task.isCancelled else { return }

            isPresented = false
        })
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        playHapticEffect()

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = true },
                completion: dismissAfterLifecycle
            )

        } else {
            // `VToast` doesn't have an intrinsic height
            // This delay gives SwiftUI change to return height.
            // Other option was to calculate it using `UILabel`.
            Task(operation: { @MainActor in
                withBasicAnimation(
                    uiModel.appearAnimation,
                    body: { isPresentedInternally = true },
                    completion: dismissAfterLifecycle
                )
            })
        }
    }

    private func animateOut() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = false },
                completion: presentationMode.dismissCompletion
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isPresentedInternally = false },
                completion: presentationMode.dismissCompletion
            )
        }
    }

    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playNotification(uiModel.haptic)
#endif
    }
}

// MARK: - Helpers
extension VerticalEdge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        }
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
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.duration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
                    )
            })
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
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                            uiModel.duration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
                    )
            })
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
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            uiModel.presentationEdge = .top
                            uiModel.duration = 60
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: "Lorem ipsum dolor sit amet"
                    )
            })
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
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = .init()
                            widthType.map { uiModel.widthType = $0 }
                            uiModel.duration = 60
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

                            // `fixedPoint` not demoed

                            widthType = .fixedFraction(ratio: 0.5, alignment: .leading)
                            try? await Task.sleep(seconds: 1)
                        }
                    })
            })
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
                        id: "preview",
                        uiModel: {
                            var uiModel = uiModel
                            uiModel.duration = 60
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
        }
    }

    return ContentView()
})

#endif

#endif
