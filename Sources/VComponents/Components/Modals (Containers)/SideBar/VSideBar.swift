//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VSideBarUIModel

    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()
    
    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize
    @Environment(\.presentationHostSafeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    private var currentWidth: CGFloat {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).width.toAbsolute(dimension: containerSize.width)
    }
    
    private var currentHeight: CGFloat {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).height.toAbsolute(dimension: containerSize.height)
    }

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Swipe
    // Prevents `dismissFromDrag` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

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
            .getPlatformInterfaceOrientation({ newValue in
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
            contentView
                .frame(
                    width: currentWidth,
                    height: currentHeight
                )
        })
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

    private var contentView: some View {
        content()
            .padding(uiModel.contentMargins)
            .safeAreaPaddings(edges: uiModel.contentSafeAreaEdges, insets: safeAreaInsets)
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
            uiModel.dismissType.contains(.swipe),
            !isBeingDismissedFromSwipe,
            isDraggedInCorrectDirection(dragValue),
            didExceedSwipeDismissDistance(dragValue)
        else {
            return
        }

        isBeingDismissedFromSwipe = true

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
            if isBeingDismissedFromSwipe {
                uiModel.swipeDismissAnimation
            } else {
                uiModel.disappearAnimation
            }
        }()

        withAnimation(
            animation?.toSwiftUIAnimation,
            { isPresentedInternally = false },
            completion: completion
        )
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
    
    private func didExceedSwipeDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.presentationEdge {
        case .leading, .trailing: abs(dragValue.translation.width) >= uiModel.swipeDismissDistance(in: currentWidth)
        case .top, .bottom: abs(dragValue.translation.height) >= uiModel.swipeDismissDistance(in: currentHeight)
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

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

#if !os(macOS)

#Preview("Safe Area Leading", body: {
    Preview_SafeAreaContentView()
})

#endif

#if !os(macOS)

#Preview("Safe Area Trailing", body: {
    Preview_SafeAreaContentView(uiModel: .trailing)
})

#endif

#if !os(macOS)

#Preview("Safe Area Top", body: {
    Preview_SafeAreaContentView(uiModel: .top)
})

#endif

#if !os(macOS)


#Preview("Safe Area Bottom", body: {
    Preview_SafeAreaContentView(uiModel: .bottom)
})

#endif

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
        .presentationHostLayer(
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
#if os(macOS)
                uiModel.dimmingViewColor = Color.clear
                uiModel.dimmingViewTapAction = .passTapsThrough
#endif
                return uiModel
            }()
        )
    }
}

#if !os(macOS)

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
        .presentationHostLayer(
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
#if os(macOS)
                uiModel.dimmingViewColor = Color.clear
                uiModel.dimmingViewTapAction = .passTapsThrough
#endif
                return uiModel
            }()
        )
    }
}

#endif

#endif

#endif
