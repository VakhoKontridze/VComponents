//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - V Modal
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VModal<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VModalUIModel

    private var currentWidth: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).width.points(in: containerSize.width)
    }
    private var currentHeight: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).height.points(in: containerSize.height)
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
                UIApplication.shared.sendResignFirstResponderAction()
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
                            layoutDirection == .rightToLeft
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
        withBasicAnimation(
            uiModel.appearAnimation,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
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
}

// MARK: - Previews
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VModal_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            InsettedContentPreview().previewDisplayName("Insetted Content")
            WrappedContentPreview().previewDisplayName("Wrapped Content")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static func content() -> some View {
        ColorBook.accentBlue
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vModal(
                        id: "preview",
                        isPresented: $isPresented,
                        content: {
                            content()
                                .onTapGesture(perform: { isPresented = false })
                        }
                    )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vModal(
                        id: "preview",
                        uiModel: .insettedContent,
                        isPresented: $isPresented,
                        content: {
                            content()
                                .onTapGesture(perform: { isPresented = false })
                        }
                    )
            })
        }
    }

    private struct WrappedContentPreview: View {
        @State private var isPresented: Bool = true
        @State private var contentHeight: CGFloat?

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vModal(
                        id: "preview",
                        uiModel: {
                            var uiModel: VModalUIModel = .init()

                            uiModel.contentMargins = VModalUIModel.Margins(15)

                            if let contentHeight {
                                let height: CGFloat = uiModel.contentWrappingHeight(contentHeight: contentHeight)

                                uiModel.sizes.portrait.height = .point(height)
                                uiModel.sizes.landscape.height = .point(height)
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
}
