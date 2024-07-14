//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal
@available(macOS, unavailable) // No `View.presentationHost(...)`
@available(tvOS, unavailable) // No `View.presentationHost(...)`
@available(watchOS, unavailable) // No `View.presentationHost(...)`
@available(visionOS, unavailable) // No `View.presentationHost(...)`
struct VModal<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VModalUIModel

    private var currentWidth: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).width.toAbsolute(in: containerSize.width)
    }
    private var currentHeight: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).height.toAbsolute(in: containerSize.height)
    }

    @Environment(\.presentationHostGeometrySize) private var containerSize: CGSize

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()

    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

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
            ._getInterfaceOrientation({ newValue in
                if
                    uiModel.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
                
                interfaceOrientation = newValue
            })
        
            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView)
    }

    private var modalView: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel, content: {
            content()
                .padding(uiModel.contentMargins)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .frame( // Max dimension fixes issue of safe areas and/or landscape
            maxWidth: currentWidth,
            maxHeight: currentHeight
        )
        .scaleEffect(isPresentedInternally ? 1 : uiModel.scaleEffect)
        .shadow(
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )
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
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = false },
                completion: completion
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isPresentedInternally = false },
                completion: completion
            )
        }
    }
}

// MARK: - Previews
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vModal(
                        id: "preview",
                        isPresented: $isPresented,
                        content: {
                            Color.blue
                                .onTapGesture(perform: { isPresented = false })
                        }
                    )
            })
            .presentationHostLayer()
        }
    }

    return ContentView()
})

#Preview("Max Frame", body: { // TODO: Move into macro when nested macro expansions are supported
    ContentView_MaxFrame()
})
struct ContentView_MaxFrame: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vModal(
                    id: "preview",
                    uiModel: {
                        var uiModel: VModalUIModel = .init()

                        uiModel.sizes = VModalUIModel.Sizes(
                            portrait: VModalUIModel.Size(
                                width: .fraction(1),
                                height: .fraction(1)
                            ),
                            landscape: VModalUIModel.Size(
                                width: .fraction(1),
                                height: .fraction(1)
                            )
                        )

                        uiModel.contentMargins = VModalUIModel.Margins(15)

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: {
                        Color.blue
                            .onTapGesture(perform: { isPresented = false })
                    }
                )
        })
        .presentationHostLayer()
    }
}

#Preview("Wrapped Content", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true
        @State private var contentHeight: CGFloat?

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vModal(
                        id: "preview",
                        uiModel: {
                            var uiModel: VModalUIModel = .init()

                            uiModel.contentMargins = VModalUIModel.Margins(15) // Must come before calculation

                            if let contentHeight {
                                let height: CGFloat = uiModel.contentWrappingHeight(contentHeight: contentHeight)

                                uiModel.sizes.portrait.height = .absolute(height)
                                uiModel.sizes.landscape.height = .absolute(height)
                            }

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: {
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere sem consequat felis imperdiet, eu ornare velit tincidunt. Praesent viverra sem lacus, sed gravida dui cursus sit amet.")
                                .getSize({ contentHeight = $0.height })
                                .onTapGesture(perform: { isPresented = false })
                        }
                    )
            })
            .presentationHostLayer()
        }
    }

    return ContentView()
})

#endif

#endif
