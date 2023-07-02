//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 14.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VToast: View {
    // MARK: Properties
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VToastUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let text: String
    
    @State private var isInternallyPresented: Bool = false
    
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
        ZStack(alignment: uiModel.presentationEdge.alignment, content: {
            dimmingView
            contentView
        })
        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)
        .onAppear(perform: animateIn)
        .onAppear(perform: animateOutAfterLifecycle)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )
    }

    private var dimmingView: some View {
        Color.clear
            .ignoresSafeArea()
    }
    
    private var contentView: some View {
        Text(text)
            .multilineTextAlignment(uiModel.textLineType.toVCoreTextLineType.textAlignment ?? .leading)
            .lineLimit(type: uiModel.textLineType.toVCoreTextLineType.textLineLimitType)
            .minimumScaleFactor(uiModel.textMinimumScaleFactor)
            .foregroundColor(uiModel.textColor)
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
                            alignment: alignment.toAlignment
                        )

                case .fixedPoint(let width, let alignment):
                    view
                        .frame(
                            width: width,
                            alignment: alignment.toAlignment
                        )

                case .fixedFraction(let ratio, let alignment):
                    view
                        .frame(
                            width: MultiplatformConstants.screenSize.width * ratio,
                            alignment: alignment.toAlignment
                        )
                }
            })
            .cornerRadius(cornerRadius)
            .background(background)
            .onSizeChange(perform: { height = $0.height })
            .padding(.horizontal, uiModel.widthType.marginHor)
            .offset(y: isInternallyPresented ? presentedOffset : initialOffset)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(uiModel.backgroundColor)
            .shadow(
                color: uiModel.shadowColor,
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    // MARK: Offsets
    private var initialOffset: CGFloat {
        switch uiModel.presentationEdge {
        case .top: return -(MultiplatformConstants.safeAreaInsets.top + height)
        case .bottom: return MultiplatformConstants.safeAreaInsets.bottom + 100
        }
    }
    
    private var presentedOffset: CGFloat {
        switch uiModel.presentationEdge {
        case .top: return uiModel.presentationEdgeSafeAreaInset
        case .bottom: return -uiModel.presentationEdgeSafeAreaInset
        }
    }
    
    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch uiModel.cornerRadiusType {
        case .capsule: return height / 2
        case .rounded(let cornerRadius): return cornerRadius
        }
    }
    
    // MARK: Animations
    private func animateIn() {
        playHapticEffect()

        // `VToast` doesn't have an intrinsic height
        // This delay gives SwiftUI change to return height.
        // Other option was to calculate it using `UILabel`.
        DispatchQueue.main.async(execute: {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isInternallyPresented = true },
                completion: {
                    DispatchQueue.main.async(execute: { presentHandler?() })
                }
            )
        })
    }
    
    private func animateOut() {
        withBasicAnimation(
            uiModel.disappearAnimation,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + uiModel.duration,
            execute: animateOut
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.disappearAnimation,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playNotification(uiModel.haptic)
#endif
    }
}

// MARK: - Helpers
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension HorizontalAlignment {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: fatalError()
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
    private static var presentationEdge: VToastUIModel.PresentationEdge { .default }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            MultiLineTextPreview().previewDisplayName("MultiLine Text")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var text: String { "Lorem ipsum dolor sit amet".pseudoRTL(languageDirection) }
    private static var textLong: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit".pseudoRTL(languageDirection) }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VToast(
                    uiModel: {
                        var uiModel: VToastUIModel = highlights
                        uiModel.widthType = widthType
                        uiModel.presentationEdge = presentationEdge
                        uiModel.appearAnimation = nil
                        uiModel.duration = .infinity
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    text: text
                )
            })
        }
    }
    
    private struct MultiLineTextPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VToast(
                    uiModel: {
                        var uiModel: VToastUIModel = highlights
                        uiModel.widthType = widthType
                        uiModel.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                        uiModel.presentationEdge = presentationEdge
                        uiModel.appearAnimation = nil
                        uiModel.duration = .infinity
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    text: textLong
                )
            })
        }
    }
}
