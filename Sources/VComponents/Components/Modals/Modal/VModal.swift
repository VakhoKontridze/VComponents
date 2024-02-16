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
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)`
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

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize

    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.displayScale) private var displayScale: CGFloat

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false
    @State private var didFinishInternalPresentation: Bool = false

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
        ZStack(content: {
            dimmingView
            modalView
        })
        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)

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
    }
    
    private var dimmingView: some View {
        uiModel.dimmingViewColor
            .contentShape(Rectangle())
            .onTapGesture(perform: dismissFromDimmingViewTap)
    }

    private var modalView: some View {
        ZStack(content: {
            VGroupBox(uiModel: uiModel.groupBoxSubUIModel)
                .shadow(
                    color: uiModel.shadowColor,
                    radius: uiModel.shadowRadius,
                    offset: uiModel.shadowOffset
                )

            content()
                .padding(uiModel.contentMargins)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius( // Fixes issue of content-clipping, as it's not in `VGroupBox`
                    uiModel.cornerRadius,
                    corners: uiModel.roundedCorners
                        .withReversedLeftAndRightCorners(
                            uiModel.reversesLeftAndRightCornersForRTLLanguages &&
                            layoutDirection.isRightToLeft
                        )
                )
        })
        .frame( // Max dimension fixes issue of safe areas and/or landscape
            maxWidth: currentWidth,
            maxHeight: currentHeight
        )
        .scaleEffect(isPresentedInternally ? 1 : uiModel.scaleEffect)
    }

    // MARK: Lifecycle
    private func dismissFromDimmingViewTap() {
        guard
            didFinishInternalPresentation,
            uiModel.dismissType.contains(.backTap)
        else {
            return
        }

        isPresented = false
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = true },
                completion: { didFinishInternalPresentation = true }
            )

        } else {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isPresentedInternally = true },
                completion: { didFinishInternalPresentation = true }
            )
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
        }
    }

    return ContentView()
})

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

                            uiModel.contentMargins = VModalUIModel.Margins(15)

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
        }
    }

    return ContentView()
})

#endif

#endif
