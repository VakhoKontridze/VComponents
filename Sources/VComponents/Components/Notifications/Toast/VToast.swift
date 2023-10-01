//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VToast: View {
    // MARK: Properties - UI Model
    private let uiModel: VToastUIModel

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handlers
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Text
    private let text: String
    
    // MARK: Properties - Frame
    @State private var height: CGFloat = 0
    
    // MARK: Initializers
    init(
        uiModel: VToastUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        text: String
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: uiModel.presentationEdge.toAlignment, content: {
            dimmingView
            contentView
        })
        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)

        ._getInterfaceOrientation({ interfaceOrientation = $0 })

        .onAppear(perform: animateIn)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )
    }

    private var dimmingView: some View {
        Color.clear
            .contentShape(Rectangle())
    }
    
    private var contentView: some View {
        Text(text)
            .multilineTextAlignment(uiModel.textLineType.toVCoreTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.textLineType.toVCoreTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.textMinimumScaleFactor)
            .foregroundStyle(uiModel.textColor)
            .font(uiModel.textFont)

            .padding(uiModel.textMargins)
            .applyModifier({ view in
                switch uiModel.widthType {
                case .wrapped:
                    view

                case .stretched(let alignment, _):
                    view
                        .frame(
                            maxWidth: .infinity,
                            alignment: Alignment(horizontal: alignment, vertical: .center)
                        )

                case .fixedPoint(let width, let alignment):
                    view
                        .frame(
                            width: width,
                            alignment: Alignment(horizontal: alignment, vertical: .center)
                        )

                case .fixedFraction(let ratio, let alignment):
                    view
                        .frame(
                            width: containerSize.width * ratio,
                            alignment: Alignment(horizontal: alignment, vertical: .center)
                        )
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // No need for clipping for preventing content from overflowing here, since background is applied via modifier
            .background(content: { backgroundView })
            .getSize({ height = $0.height })
            .padding(.horizontal, uiModel.widthType.marginHorizontal)
            .offset(y: isInternallyPresented ? presentedOffset : initialOffset)
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
    
    // MARK: Animations
    private func animateIn() {
        playHapticEffect()

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = true },
                completion: {
                    animateOutAfterLifecycle()
                    presentHandler?()
                }
            )

        } else {
            // `VToast` doesn't have an intrinsic height
            // This delay gives SwiftUI change to return height.
            // Other option was to calculate it using `UILabel`.
            DispatchQueue.main.async(execute: {
                withBasicAnimation(
                    uiModel.appearAnimation,
                    body: { isInternallyPresented = true },
                    completion: {
                        animateOutAfterLifecycle()
                        DispatchQueue.main.async(execute: { presentHandler?() })
                    }
                )
            })
        }
    }
    
    private func animateOut() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
            )
        }
    }
    
    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + uiModel.duration,
            execute: animateOut
        )
    }
    
    private func animateOutFromExternalDismiss() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VerticalEdge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VToast_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    private static var highlights: VToastUIModel { .init() }
    private static var widthType: VToastUIModel.WidthType { .default }
    private static var presentationEdge: VerticalEdge { .bottom }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            MultiLineTextPreview().previewDisplayName("MultiLine Text")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var text: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var textLong: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = highlights

                            uiModel.colorScheme = VToast_Previews.colorScheme
                            uiModel.widthType = widthType
                            uiModel.presentationEdge = presentationEdge
                            uiModel.duration = .infinity

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: text
                    )
            })
        }
    }
    
    private struct MultiLineTextPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vToast(
                        id: "preview",
                        uiModel: {
                            var uiModel: VToastUIModel = highlights

                            uiModel.colorScheme = VToast_Previews.colorScheme
                            uiModel.widthType = widthType
                            uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                            uiModel.presentationEdge = presentationEdge
                            uiModel.duration = .infinity

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        text: textLong
                    )
            })
        }
    }
}
