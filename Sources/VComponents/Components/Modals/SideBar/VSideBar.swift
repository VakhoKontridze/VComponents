//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VSideBarUIModel

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).width.toAbsolute(in: containerSize.width)
    }
    private var currentHeight: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).height.toAbsolute(in: containerSize.height)
    }

    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handlers
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Initializers
    init(
        uiModel: VSideBarUIModel,
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
        ZStack(
            alignment: uiModel.presentationEdge.alignment,
            content: {
                dimmingView
                sideBar
            }
        )
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
    
    private var sideBar: some View {
        ZStack(content: {
            VGroupBox(uiModel: uiModel.groupBoxSubUIModel)
                .shadow(
                    color: uiModel.shadowColor,
                    radius: uiModel.shadowRadius,
                    offset: uiModel.shadowOffset
                )
            
            content()
                .padding(uiModel.contentMargins)
                .safeAreaMargins(edges: uiModel.contentSafeAreaMargins, insets: safeAreaInsets)
        })
        .frame( // Max dimension fixes issue of safe areas and/or landscape
            maxWidth: currentWidth,
            maxHeight: currentHeight
        )
        .offset(isInternallyPresented ? .zero : initialOffset)
        .gesture(
            DragGesture(minimumDistance: 20) // Non-zero value prevents collision with scrolling
                .onChanged(dragChanged)
        )
    }
    
    // MARK: Actions
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
    
    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.dragBackDismissAnimation,
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
    
    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            uiModel.dismissType.contains(.dragBack),
            isDraggedInCorrectDirection(dragValue),
            didExceedDragBackDismissDistance(dragValue)
        else {
            return
        }
        
        animateOutFromDrag()
    }
    
    // MARK: Presentation Edge Offsets
    private var initialOffset: CGSize {
        let x: CGFloat = {
            switch uiModel.presentationEdge {
            case .leading: return -(currentWidth + safeAreaInsets.leading)
            case .trailing: return currentWidth + safeAreaInsets.trailing
            case .top: return 0
            case .bottom: return 0
            }
        }()
        
        let y: CGFloat = {
            switch uiModel.presentationEdge {
            case .leading: return 0
            case .trailing: return 0
            case .top: return -(currentHeight + safeAreaInsets.top)
            case .bottom: return currentHeight + safeAreaInsets.bottom
            }
        }()
        
        return CGSize(width: x, height: y)
    }
    
    // MARK: Presentation Edge Dismiss
    private func isDraggedInCorrectDirection(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.presentationEdge {
        case .leading:
            switch layoutDirection {
            case .leftToRight: return dragValue.translation.width <= 0
            case .rightToLeft: return dragValue.translation.width >= 0
            @unknown default: fatalError()
            }
            
        case .trailing:
            switch layoutDirection {
            case .leftToRight: return dragValue.translation.width >= 0
            case .rightToLeft: return dragValue.translation.width <= 0
            @unknown default: fatalError()
            }
            
        case .top:
            return dragValue.translation.height <= 0
            
        case .bottom:
            return dragValue.translation.height >= 0
        }
    }
    
    private func didExceedDragBackDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.presentationEdge {
        case .leading, .trailing: return abs(dragValue.translation.width) >= uiModel.dragBackDismissDistance(in: currentWidth)
        case .top, .bottom: return abs(dragValue.translation.height) >= uiModel.dragBackDismissDistance(in: currentHeight)
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VSideBar_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    private static var presentationEdge: VSideBarUIModel { .init() }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            InsettedContentPreview().previewDisplayName("Insetted Content")
#if os(iOS)
            SafeAreaPreview().previewDisplayName("Safe Area")
#endif
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
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
                    .vSideBar(
                        id: "preview",
                        uiModel: {
                            var uiModel: VSideBarUIModel = presentationEdge
                            uiModel.colorScheme = VSideBar_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: content
                    )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vSideBar(
                        id: "preview",
                        uiModel: {
                            var uiModel: VSideBarUIModel = presentationEdge

                            uiModel.colorScheme = VSideBar_Previews.colorScheme

                            uiModel.contentMargins = VSideBarUIModel.insettedContent.contentMargins
                            
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: content
                    )
            })
        }
    }

#if os(iOS)
    private struct SafeAreaPreview: View {
        @State private var isPresented: Bool = true
        @State private var interfaceOrientation: UIInterfaceOrientation = .unknown

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .getInterfaceOrientation({ interfaceOrientation = $0 })
                    .vSideBar(
                        id: "preview",
                        uiModel: {
                            var uiModel: VSideBarUIModel = .init() // No `presentationEdge`

                            uiModel.colorScheme = VSideBar_Previews.colorScheme

                            uiModel.contentSafeAreaMargins = {
                                if interfaceOrientation.isLandscape {
                                    return .leading
                                } else {
                                    return .vertical
                                }
                            }()

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: content
                    )
            })
        }
    }
#endif
}
