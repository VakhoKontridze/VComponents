//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal
@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS, unavailable) // No `View.presentationHost(...)` support
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
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handles
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Initializers
    init(
        uiModel: VModalUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            modal
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

        .onAppear(perform: animateIn)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )
    }
    
    private var dimmingView: some View {
        uiModel.dimmingViewColor
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                if uiModel.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var modal: some View {
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
        .scaleEffect(isInternallyPresented ? 1 : uiModel.scaleEffect)
    }
    
    // MARK: Animations
    private func animateIn() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = true },
                completion: { presentHandler?() }
            )

        } else {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isInternallyPresented = true },
                completion: {
                    DispatchQueue.main.async(execute: { presentHandler?() })
                }
            )
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
}

// MARK: - Previews
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS))

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
                            ColorBook.accentBlue
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
