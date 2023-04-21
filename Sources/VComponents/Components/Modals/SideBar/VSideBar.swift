//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VSideBarUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let content: () -> Content
    
    @State private var isInternallyPresented: Bool = false
    
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
            alignment: uiModel.layout.presentationEdge.alignment,
            content: {
                dimmingView
                sideBar
            }
        )
        .environment(\.colorScheme, uiModel.colors.colorScheme ?? colorScheme)
        .onAppear(perform: animateIn)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )
    }
    
    private var dimmingView: some View {
        uiModel.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if uiModel.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }
    
    private var sideBar: some View {
        ZStack(content: {
            VSheet(uiModel: uiModel.sheetSubUIModel)
                .ignoresSafeArea()
                .shadow(
                    color: uiModel.colors.shadow,
                    radius: uiModel.colors.shadowRadius,
                    offset: uiModel.colors.shadowOffset
                )
            
            content()
                .padding(uiModel.layout.contentMargins)
                .ignoresSafeArea(.container, edges: uiModel.layout.ignoredContainerSafeAreaEdges)
                .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeyboardSafeAreaEdges)
        })
        .frame( // Max dimension fix issue of safe areas and/or landscape
            maxWidth: uiModel.layout.sizes._current.size.width,
            maxHeight: uiModel.layout.sizes._current.size.height
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
            uiModel.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }
    
    private func animateOut() {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.animations.dragBackDismiss,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.animations.disappear,
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
            uiModel.misc.dismissType.contains(.dragBack),
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
            switch uiModel.layout.presentationEdge {
            case .leading: return -(uiModel.layout.sizes._current.size.width + MultiplatformConstants.safeAreaInsets.leading)
            case .trailing: return uiModel.layout.sizes._current.size.width + MultiplatformConstants.safeAreaInsets.trailing
            case .top: return 0
            case .bottom: return 0
            }
        }()
        
        let y: CGFloat = {
            switch uiModel.layout.presentationEdge {
            case .leading: return 0
            case .trailing: return 0
            case .top: return -(uiModel.layout.sizes._current.size.height + MultiplatformConstants.safeAreaInsets.top)
            case .bottom: return uiModel.layout.sizes._current.size.height + MultiplatformConstants.safeAreaInsets.bottom
            }
        }()
        
        return CGSize(width: x, height: y)
    }
    
    // MARK: Presentation Edge Dismiss
    private func isDraggedInCorrectDirection(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.layout.presentationEdge {
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
        switch uiModel.layout.presentationEdge {
        case .leading, .trailing: return abs(dragValue.translation.width) >= uiModel.layout.dragBackDismissDistance
        case .top, .bottom: return abs(dragValue.translation.height) >= uiModel.layout.dragBackDismissDistance
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
        var body: some View {
            PreviewContainer(content: {
                VSideBar(
                    uiModel: {
                        var uiModel: VSideBarUIModel = presentationEdge
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: content
                )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VSideBar(
                    uiModel: {
                        var uiModel: VSideBarUIModel = presentationEdge
                        uiModel.layout.contentMargins = VSideBarUIModel.insettedContent.layout.contentMargins
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: content
                )
            })
        }
    }
}
