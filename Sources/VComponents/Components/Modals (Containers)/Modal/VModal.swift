//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal
@available(watchOS, unavailable) // Doesn't follow HIG
struct VModal<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VModalUIModel
    
    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    
    private var currentWidth: VModalUIModel.Dimension {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).width
    }
    
    private var currentHeight: VModalUIModel.Dimension {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).height
    }

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Initializers
    init(
        uiModel: VModalUIModel,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._isPresented = isPresented
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        modalView
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
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView)
    }

    private var modalView: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel) {
            contentView
                .applyModifier {
                    switch currentWidth {
                    case .fixed(let dimension):
                        $0
                            .frame(width: dimension.toAbsolute(dimension: containerSize.width))

                    case .wrapped:
                        $0

                    case .stretched:
                        $0
                            .frame(maxWidth: .infinity)
                    }
                }
                .applyModifier {
                    switch currentHeight {
                    case .fixed(let dimension):
                        $0
                            .frame(height: dimension.toAbsolute(dimension: containerSize.height))

                    case .wrapped:
                        $0

                    case .stretched:
                        $0
                            .frame(maxHeight: .infinity)
                    }
                }
        }
        .shadow(
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )
        
        .padding(.horizontal, currentWidth.margin.toAbsolute(dimension: containerSize.width))
        .padding(.vertical, currentHeight.margin.toAbsolute(dimension: containerSize.height))

        .scaleEffect(isPresentedInternally ? 1 : uiModel.scaleEffect)
    }

    private var contentView: some View {
        content()
            .padding(uiModel.contentMargins)
    }

    // MARK: Actions
    private func didTapDimmingView() {
        guard uiModel.dismissType.contains(.backTap) else { return }

        isPresented = false
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
}

// MARK: - Previews
#if DEBUG

#if !os(watchOS) // Redundant

#Preview("*") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        PreviewModalLauncherView(isPresented: $isPresented)
            .vModal(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented
            ) {
                Color.blue
                    .onTapGesture { isPresented = false }
            }
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("Size Types") {
    ContentView_SizeTypes()
}

// Preview macro doesn’t support nested macro expansions
private struct ContentView_SizeTypes: View {
    @State private var isPresented: Bool = true
    @State private var size: VModalUIModel.Size?

    var body: some View {
        PreviewContainer {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vModal(
                    link: rootAndLink.link(linkID: "preview"),
                    uiModel: {
                        var uiModel: VModalUIModel = .init()
                        size.map { uiModel.sizeGroup = VModalUIModel.SizeGroup($0) }
                        return uiModel
                    }(),
                    isPresented: $isPresented
                ) {
                    Text("Lorem ipsum dolor sit amet")
                        .contentShape(.rect)
                        .onTapGesture { isPresented = false }
                }
                .task { @MainActor in
                    try? await Task.sleep(for: .seconds(1))

                    while true {
                        size = VModalUIModel.Size(
                            width: .fixed(dimension: .fraction(0.75)),
                            height: .fixed(dimension: .fraction(0.75))
                        )
                        try? await Task.sleep(for: .seconds(1))

                        size = VModalUIModel.Size(
                            width: .wrapped(margin: .absolute(15)),
                            height: .wrapped(margin: .absolute(15))
                        )
                        try? await Task.sleep(for: .seconds(1))

                        size = VModalUIModel.Size(
                            width: .stretched(margin: .absolute(15)),
                            height: .stretched(margin: .absolute(15))
                        )
                        try? await Task.sleep(for: .seconds(1))
                    }
                }
        }
        .modalPresenterRoot(root: rootAndLink.root)
    }
}

#endif

private let rootAndLink: Preview_ModalPresenterRootAndLink = .overlay

#endif
