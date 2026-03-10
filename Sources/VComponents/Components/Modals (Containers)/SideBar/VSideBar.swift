//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import OSLog
import VCore

@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties - Appearance
    private let appearance: VSideBarAppearance

    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    @Environment(\.modalPresenterInterfaceOrientation) private var interfaceOrientation: PlatformInterfaceOrientation
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    private var currentWidth: CGFloat {
        appearance.sizeGroup.current(orientation: interfaceOrientation).width.toAbsolute(dimension: containerSize.width)
    }
    
    private var currentHeight: CGFloat {
        appearance.sizeGroup.current(orientation: interfaceOrientation).height.toAbsolute(dimension: containerSize.height)
    }

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode! // Unsafe

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Swipe
    // Prevents `dismissFromDrag` being called multiples times during active drag, which can break the animation.
    @State private var isBeingDismissedFromSwipe: Bool = false

    // MARK: Initializers
    init(
        appearance: VSideBarAppearance,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.appearance = appearance
        self._isPresented = isPresented
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        sideBarView
            .onChange(of: interfaceOrientation) { (_, newValue) in
                if
                    appearance.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
            }

            .onReceive(presentationMode.presentPublisher, perform: onPresent)
            .onReceive(presentationMode.dismissPublisher, perform: onDismiss)
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: onTapDimmingView)
    }
    
    private var sideBarView: some View {
        VGroupBox(appearance: appearance.groupBoxAppearance) {
            contentView
                .frame(
                    width: currentWidth,
                    height: currentHeight
                )
        }
        .shadow(
            color: appearance.shadowColor,
            radius: appearance.shadowRadius,
            offset: appearance.shadowOffset
        )
        
        .offset(isPresentedInternally ? .zero : initialOffset)

        .gesture(
            DragGesture(minimumDistance: 20) // Non-zero value prevents collision with scrolling
                .onChanged(dragChanged)
        )
    }

    private var contentView: some View {
        content()
            .padding(appearance.contentMargins)
            .safeAreaPaddings(edges: appearance.contentSafeAreaEdges, insets: safeAreaInsets)
    }

    // MARK: Actions
    private func onTapDimmingView() {
        guard appearance.dismissType.contains(.backTap) else { return }

        isPresented = false
    }

    private func dismissFromDrag() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            appearance.dismissType.contains(.swipe),
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
    private func onPresent() {
        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true }
        )
    }
    
    private func onDismiss(
        completion: @escaping () -> Void
    ) {
        let animation: Animation? = {
            if isBeingDismissedFromSwipe {
                appearance.swipeDismissAnimation
            } else {
                appearance.disappearAnimation
            }
        }()

        withAnimation(
            animation,
            { isPresentedInternally = false },
            completion: completion
        )
    }
    
    // MARK: Presentation Edge Offsets
    private var initialOffset: CGSize {
        let x: CGFloat = {
            switch appearance.presentationEdge {
            case .leading: -(currentWidth + safeAreaInsets.leading)
            case .trailing: currentWidth + safeAreaInsets.trailing
            case .top: 0
            case .bottom: 0
            }
        }()
        
        let y: CGFloat = {
            switch appearance.presentationEdge {
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
        switch appearance.presentationEdge {
        case .leading:
            switch layoutDirection {
            case .leftToRight:
                return dragValue.translation.width <= 0
            
            case .rightToLeft:
                return dragValue.translation.width >= 0
            
            @unknown default:
                Logger.sideBar.fault("Unhandled 'LayoutDirection' '\(String(describing: layoutDirection))' in 'VSideBar'")
                return false
            }
            
        case .trailing:
            switch layoutDirection {
            case .leftToRight:
                return dragValue.translation.width >= 0
            
            case .rightToLeft:
                return dragValue.translation.width <= 0
            
            @unknown default:
                Logger.sideBar.fault("Unhandled 'LayoutDirection' '\(String(describing: layoutDirection))' in 'VSideBar'")
                return false
            }
            
        case .top:
            return dragValue.translation.height <= 0
            
        case .bottom:
            return dragValue.translation.height >= 0
        }
    }
    
    private func didExceedSwipeDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        switch appearance.presentationEdge {
        case .leading, .trailing:
            abs(dragValue.translation.width) >= appearance.swipeDismissDistance(in: currentWidth)
            
        case .top, .bottom:
            abs(dragValue.translation.height) >= appearance.swipeDismissDistance(in: currentHeight)
        }
    }
}

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("Leading") {
    ContentView()
}

#Preview("Trailing") {
    ContentView(appearance: .trailing)
}

#Preview("Top") {
    ContentView(appearance: .top)
}

#Preview("Bottom") {
    ContentView(appearance: .bottom)
}

#if !os(macOS) // No `UIEdgeInsets`

#Preview("Safe Area Leading") {
    SafeAreaContentView()
}

#endif

#if !os(macOS) // No `UIEdgeInsets`

#Preview("Safe Area Trailing") {
    SafeAreaContentView(appearance: .trailing)
}

#endif

#if !os(macOS) // No `UIEdgeInsets`

#Preview("Safe Area Top") {
    SafeAreaContentView(appearance: .top)
}

#endif

#if !os(macOS) // No `UIEdgeInsets`


#Preview("Safe Area Bottom") {
    SafeAreaContentView(appearance: .bottom)
}

#endif

private struct ContentView: View {
    // MARK: Properties
    private let appearance: VSideBarAppearance
    @State private var isPresented: Bool = true

    // MARK: Initializers
    init(
        appearance: VSideBarAppearance = .init()
    ) {
        self.appearance = appearance
    }

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vSideBar(
                    link: rootAndLink.link(linkID: "preview"),
                    appearance: appearance,
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot(
            root: rootAndLink.root,
            appearance: {
                var appearance: ModalPresenterRootAppearance = .init()
#if os(macOS)
                appearance.dimmingViewColor = Color.clear
                appearance.dimmingViewTapAction = .passTapsThrough
#endif
                return appearance
            }()
        )
    }
}

#if !os(macOS) // No `UIEdgeInsets`

private struct SafeAreaContentView: View {
    // MARK: Properties
    private let appearance: VSideBarAppearance
    @State private var isPresented: Bool = true
    @State private var interfaceOrientation: UIInterfaceOrientation = .unknown

    // MARK: Initializers
    init(
        appearance: VSideBarAppearance = .init()
    ) {
        self.appearance = appearance
    }

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .onInterfaceOrientationChange { interfaceOrientation = $0 }
                .vSideBar(
                    link: rootAndLink.link(linkID: "preview"),
                    appearance: {
                        var appearance = appearance
                        appearance.contentSafeAreaEdges = appearance.defaultContentSafeAreaEdges(interfaceOrientation: interfaceOrientation)
                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot(
            root: rootAndLink.root,
            appearance: {
                var appearance: ModalPresenterRootAppearance = .init()
#if os(macOS)
                appearance.dimmingViewColor = Color.clear
                appearance.dimmingViewTapAction = .passTapsThrough
#endif
                return appearance
            }()
        )
    }
}

#endif

#endif

private let rootAndLink: ModalPresenterRootAndLink = .overlay

#endif
