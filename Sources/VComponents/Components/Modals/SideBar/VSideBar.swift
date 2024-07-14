//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(macOS, unavailable) // No `View.presentationHost(...)`
@available(tvOS, unavailable) // No `View.presentationHost(...)`
@available(watchOS, unavailable) // No `View.presentationHost(...)`
@available(visionOS, unavailable) // No `View.presentationHost(...)`
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VSideBarUIModel

    private var currentWidth: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).width.toAbsolute(in: containerSize.width)
    }
    private var currentHeight: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).height.toAbsolute(in: containerSize.height)
    }

    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()

    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Flags
    // Prevents `dismissFromDrag` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromDragBack: Bool = false

    // MARK: Initializers
    init(
        uiModel: VSideBarUIModel,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self._isPresented = isPresented
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        sideBarView
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
    
    private var sideBarView: some View {
        VGroupBox(uiModel: uiModel.groupBoxSubUIModel, content: {
            content()
                .padding(uiModel.contentMargins)
                .applyModifier({
                    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                        $0.safeAreaPaddings(edges: uiModel.contentSafeAreaEdges, insets: safeAreaInsets)
                    } else {
                        $0.safeAreaMargins(edges: uiModel.contentSafeAreaEdges, insets: safeAreaInsets)
                    }
                })
        })
        .frame( // Max dimension fixes issue of safe areas and/or landscape
            maxWidth: currentWidth,
            maxHeight: currentHeight
        )
        .shadow(
            color: uiModel.shadowColor,
            radius: uiModel.shadowRadius,
            offset: uiModel.shadowOffset
        )
        .offset(isPresentedInternally ? .zero : initialOffset)
        .gesture(
            DragGesture(minimumDistance: 20) // Non-zero value prevents collision with scrolling
                .onChanged(dragChanged)
        )
    }

    // MARK: Actions
    private func didTapDimmingView() {
        guard uiModel.dismissType.contains(.backTap) else { return }

        isPresented = false
    }

    private func dismissFromDrag() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            uiModel.dismissType.contains(.dragBack),
            !isBeingDismissedFromDragBack
            isDraggedInCorrectDirection(dragValue),
            didExceedDragBackDismissDistance(dragValue)
        else {
            return
        }

        isBeingDismissedFromDragBack = true

        dismissFromDrag()
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
        let animation: BasicAnimation? = {
            if isBeingDismissedFromDragBack {
                uiModel.dragBackDismissAnimation
            } else {
                uiModel.disappearAnimation
            }
        }()

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                animation?.toSwiftUIAnimation,
                { isPresentedInternally = false },
                completion: completion
            )

        } else {
            withBasicAnimation(
                animation,
                body: { isPresentedInternally = false },
                completion: completion
            )
        }
    }
    
    // MARK: Presentation Edge Offsets
    private var initialOffset: CGSize {
        let x: CGFloat = {
            switch uiModel.presentationEdge {
            case .leading: -(currentWidth + safeAreaInsets.leading)
            case .trailing: currentWidth + safeAreaInsets.trailing
            case .top: 0
            case .bottom: 0
            }
        }()
        
        let y: CGFloat = {
            switch uiModel.presentationEdge {
            case .leading: 0
            case .trailing: 0
            case .top: -(currentHeight + safeAreaInsets.top)
            case .bottom: currentHeight + safeAreaInsets.bottom
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
        case .leading, .trailing: abs(dragValue.translation.width) >= uiModel.dragBackDismissDistance(in: currentWidth)
        case .top, .bottom: abs(dragValue.translation.height) >= uiModel.dragBackDismissDistance(in: currentHeight)
        }
    }
}

// MARK: - Helpers
extension Edge {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .top: .top
        case .leading: .leading
        case .bottom: .bottom
        case .trailing: .trailing
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("Leading", body: {
    Preview_ContentView()
})

#Preview("Trailing", body: {
    Preview_ContentView(uiModel: .trailing)
})

#Preview("Top", body: {
    Preview_ContentView(uiModel: .top)
})

#Preview("Bottom", body: {
    Preview_ContentView(uiModel: .bottom)
})

#Preview("Safe Area Leading", body: {
    Preview_SafeAreaContentView()
})

#Preview("Safe Area Trailing", body: {
    Preview_SafeAreaContentView(uiModel: .trailing)
})

#Preview("Safe Area Top", body: {
    Preview_SafeAreaContentView(uiModel: .top)
})

#Preview("Safe Area Bottom", body: {
    Preview_SafeAreaContentView(uiModel: .bottom)
})

private struct Preview_ContentView: View {
    private let uiModel: VSideBarUIModel
    @State private var isPresented: Bool = true

    init(
        uiModel: VSideBarUIModel = .init()
    ) {
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vSideBar(
                    id: "preview",
                    uiModel: uiModel,
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer()
    }
}

private struct Preview_SafeAreaContentView: View {
    private let uiModel: VSideBarUIModel
    @State private var isPresented: Bool = true
    @State private var interfaceOrientation: UIInterfaceOrientation = .unknown

    init(
        uiModel: VSideBarUIModel = .init()
    ) {
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .getInterfaceOrientation({ interfaceOrientation = $0 })
                .vSideBar(
                    id: "preview",
                    uiModel: {
                        var uiModel = uiModel
                        uiModel.contentSafeAreaEdges = uiModel.defaultContentSafeAreaEdges(interfaceOrientation: interfaceOrientation)
                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer()
    }
}

#endif

#endif
