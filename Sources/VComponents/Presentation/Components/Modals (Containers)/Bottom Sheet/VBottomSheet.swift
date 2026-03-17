//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties - Appearance
    private let appearance: VBottomSheetAppearance

    private var currentWidth: CGFloat {
        appearance.sizeGroup.current(orientation: modalPresenterContext.interfaceOrientation)
            .width
            .toAbsolute(dimension: modalPresenterContext.containerSize.width)
    }
    
    private var currentHeights: VBottomSheetAppearance.Heights {
        appearance.sizeGroup.current(orientation: modalPresenterContext.interfaceOrientation)
            .heights
            .withFixedValues(in: modalPresenterContext.containerSize.height)
    }
    
    @State private var dragIndicatorHeight: CGFloat = 0
    
    private var hasUnifiedDragGesture: Bool { appearance.contentIsDraggable }

    @State private var _offset: CGFloat? // If `nil`, will be set from body render.
    private var offset: CGFloat { _offset ?? getResetedHeight(from: currentHeights) }

    @State private var offsetBeforeDrag: CGFloat?

    // MARK: Properties - Presentation API
    @Environment(ModalPresenterContext.self) private var modalPresenterContext: ModalPresenterContext
    
    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false
    
    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Swipe
    @State private var isBeingDismissedFromSwipe: Bool = false

    // MARK: Initializers
    init(
        appearance: VBottomSheetAppearance,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.appearance = appearance
        self._isPresented = isPresented
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        bottomSheetView
            .onChange(of: modalPresenterContext.interfaceOrientation) { (_, newValue) in
                if
                    appearance.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != modalPresenterContext.interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
                
                resetHeightFromEnvironmentOrAppearanceChange(from: currentHeights)
            }
            .onChange(of: appearance.sizeGroup) { (_, newValue) in
                resetHeightFromEnvironmentOrAppearanceChange(
                    from: newValue.current(orientation: modalPresenterContext.interfaceOrientation).heights
                        .withFixedValues(in: modalPresenterContext.containerSize.height)
                )
            }

            .onReceive(modalPresenterContext.presentPublisher, perform: onPresent)
            .onReceive(modalPresenterContext.dismissPublisher, perform: onDismiss)
            .onReceive(modalPresenterContext.dimmingViewTapActionPublisher, perform: onTapDimmingView)
    }

    private var bottomSheetView: some View {
        let height: CGFloat = currentHeights.max.toAbsolute(dimension: modalPresenterContext.containerSize.height)
        let offset: CGFloat = isPresentedInternally ? offset : currentHeights.hiddenOffset(in: modalPresenterContext.containerSize.height)
        
        let dragGesture: some Gesture = DragGesture(minimumDistance: 0)
            .onChanged(dragChanged)
            .onEnded(dragEnded)
        
        return ZStack {
            VGroupBox(appearance: appearance.groupBoxAppearance)
                .frame(height: hasUnifiedDragGesture ? nil : height)
                .offset(y: hasUnifiedDragGesture ? 0 : offset)
                .gesture(dragGesture, isEnabled: !hasUnifiedDragGesture)
                .shadow(
                    color: appearance.shadowColor,
                    radius: appearance.shadowRadius,
                    offset: appearance.shadowOffset
                )

            ZStack {
                bottomSheetContentView
                    // Fixes issue of content-clipping, as it's not in `VGroupBox`.
                    //
                    // No need to reverse corners for RTL.
                    //
                    // `compositingGroup` helps fix glitches within subviews.
                    .compositingGroup()
                
                    .clipShape(.rect(cornerRadii: appearance.cornerRadii))
            }
            .frame(height: hasUnifiedDragGesture ? nil : height)
            .offset(y: hasUnifiedDragGesture ? 0 : offset)
        }
        .frame(width: currentWidth)
        .frame(height: hasUnifiedDragGesture ? height : nil)
        .offset(y: hasUnifiedDragGesture ? offset : 0)
        .gesture(dragGesture, isEnabled: hasUnifiedDragGesture)
    }

    private var bottomSheetContentView: some View {
        VStack(spacing: 0) {
            dragIndicatorView
            contentView
        }
    }

    private var dragIndicatorView: some View {
        ZStack {
            if appearance.dragIndicatorSize.height > 0 {
                RoundedRectangle(cornerRadius: appearance.dragIndicatorCornerRadius)
                    .frame(size: appearance.dragIndicatorSize)
                    .padding(appearance.dragIndicatorMargins)
                    .foregroundStyle(appearance.dragIndicatorColor)
            }
        }
        .onGeometryChange(of: { $0.size.height }) { dragIndicatorHeight = $0 } // If it's not rendered, `0` will be returned
    }
    
    private var contentView: some View {
        let autoresizesContent: Bool =
            appearance.autoresizesContent &&
        currentHeights.isResizable(in: modalPresenterContext.containerSize.height)
        
        return ZStack {
            ZStack {
                ZStack {
                    if !hasUnifiedDragGesture {
                        Color.clear
                            .contentShape(.rect)
                    }
                    
                    content()
                        .padding(appearance.contentMargins)
                }
                .safeAreaPaddings(edges: appearance.contentSafeAreaEdges, insets: modalPresenterContext.safeAreaInsets)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Height 1 - Gives max frame to content, if needed
            }
            .frame(
                height: { // Height 2 - Limits height to visible frame, if autoresizing is enabled
                    guard autoresizesContent else { return nil }
                    
                    return max( // Autoresized content shouldn't get smaller that the `min` height
                        modalPresenterContext.containerSize.height - offset - dragIndicatorHeight,
                        currentHeights.min.toAbsolute(dimension: modalPresenterContext.containerSize.height) - dragIndicatorHeight
                    )
                }()
            )
            .clipped() // Clips off-bound content that might clip into header
        }
        .frame(maxHeight: .infinity, alignment: .top) // Height 3 - positions content in top position, just in case autoresizing is used
    }

    // MARK: Actions
    private func onTapDimmingView() {
        guard appearance.dismissType.contains(.backTap) else { return }

        isPresented = false
    }

    private func dismissFromSwipe() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        let offsetBeforeDrag: CGFloat = {
            if let offsetBeforeDrag: CGFloat = self.offsetBeforeDrag {
                return offsetBeforeDrag
                
            } else {
                let newValue: CGFloat = offset
                self.offsetBeforeDrag = newValue
                return newValue
            }
        }()

        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height

        withAnimation(.linear(duration: 0.1)) { // Gets rid of stuttering
            _offset = {
                switch newOffset {
                case ...currentHeights.maxOffset(in: modalPresenterContext.containerSize.height):
                    return currentHeights.maxOffset(in: modalPresenterContext.containerSize.height)

                case currentHeights.minOffset(in: modalPresenterContext.containerSize.height)...:
                    if appearance.dismissType.contains(.swipe) {
                        return newOffset
                    } else {
                        return currentHeights.minOffset(in: modalPresenterContext.containerSize.height)
                    }

                default:
                    return newOffset
                }
            }()
        }
    }

    private func dragEnded(dragValue: DragGesture.Value) {
        defer { offsetBeforeDrag = nil }

        let velocityExceedsNextAreaSnapThreshold: Bool =
            abs(dragValue.velocity.height) >=
            abs(appearance.velocityToSnapToNextHeight)
        
        if velocityExceedsNextAreaSnapThreshold {
            animateOffsetOrPullDismissFromDragEndAction(
                .dragEndedHighVelocityDragEndAction(
                    containerHeight: modalPresenterContext.containerSize.height,
                    heights: currentHeights,
                    offset: offset,
                    velocity: dragValue.velocity.height
                )
            )
            
        } else {
            guard let offsetBeforeDrag else { return }

            animateOffsetOrPullDismissFromDragEndAction(
                .dragEndedDragEndAction(
                    containerHeight: modalPresenterContext.containerSize.height,
                    heights: currentHeights,
                    canSwipeToDismiss: appearance.dismissType.contains(.swipe),
                    swipeDismissDistance: appearance.swipeDismissDistance(heights: currentHeights, in: modalPresenterContext.containerSize.height),
                    offset: offset,
                    offsetBeforeDrag: offsetBeforeDrag,
                    translation: dragValue.translation.height
                )
            )
        }
    }

    private func animateOffsetOrPullDismissFromDragEndAction(
        _ dragEndAction: VBottomSheetDragEndAction?
    ) {
        guard let dragEndAction else { return }
        
        switch dragEndAction {
        case .dismiss:
            isBeingDismissedFromSwipe = true
            dismissFromSwipe()

        case .snap(let newOffset):
            withAnimation(appearance.heightSnapAnimation) { _offset = newOffset }
        }
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

    // MARK: Orientation
    private func resetHeightFromEnvironmentOrAppearanceChange(
        from heights: VBottomSheetAppearance.Heights
    ) {
        _offset = getResetedHeight(from: heights)
    }

    private func getResetedHeight(
        from heights: VBottomSheetAppearance.Heights
    ) -> CGFloat {
        heights.idealOffset(in: modalPresenterContext.containerSize.height)
    }
}

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: ModalPresenterLink(linkID: "preview"),
                isPresented: $isPresented
            ) {
                Color.blue
            }
    }
    .modalPresenterRoot()
}

#if !os(macOS) // Doesn't follow HIG

#Preview("Min & Ideal & Max") {
    ContentView_MinIdealMax()
}

// Macros aren't allowed in Preview macro
private struct ContentView_MinIdealMax: View {
    // MARK: Properties
    @State private var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()

                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            )
                        )

                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot()
    }
}

#endif

#if !os(macOS) // Doesn't follow HIG

#Preview("Min & Ideal") {
    ContentView_MinIdeal()
}

// Macros aren't allowed in Preview macro
private struct ContentView_MinIdeal: View {
    // MARK: Properties
    @State private var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()

                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.6, ideal: 0.9, max: 0.9)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.6, ideal: 0.9, max: 0.9)
                            )
                        )

                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot()
    }
}

#endif

#if !os(macOS) // Doesn't follow HIG

#Preview("Ideal & Max") {
    ContentView_IdealMax()
}

// Macros aren't allowed in Preview macro
private struct ContentView_IdealMax: View {
    // MARK: Properties
    @State private var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()

                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
                            )
                        )

                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot()
    }
}

#endif

#if !os(macOS) // Doesn't follow HIG

#Preview("Ideal (Small)") {
    ContentView_IdealSmall()
}

// Macros aren't allowed in Preview macro
private struct ContentView_IdealSmall: View {
    // MARK: Properties
    @State private var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()

                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(0.2)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(0.2)
                            )
                        )

                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot()
    }
}

#endif

#if !os(macOS) // Doesn't follow HIG

#Preview("Ideal (Large)") {
    ContentView_IdealLarge()
}

// Macros aren't allowed in Preview macro
private struct ContentView_IdealLarge: View {
    // MARK: Properties
    @State private var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()

                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(0.9)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(0.9)
                            )
                        )

                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    Color.blue
                }
        }
        .modalPresenterRoot()
    }
}

#endif

#Preview("Content Autoresizing") {
    ContentView_ContentAutoresizing()
}

// Macros aren't allowed in Preview macro
private struct ContentView_ContentAutoresizing: View {
    // MARK: Properties
    @State var isPresented: Bool = true

    // MARK: Body
    var body: some View {
        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()
                        
                        appearance.sizeGroup = VBottomSheetAppearance.SizeGroup(
                            portrait: VBottomSheetAppearance.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            ),
                            landscape: VBottomSheetAppearance.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            )
                        )
                        appearance.autoresizesContent = true
                        
                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    VStack(spacing: 0) {
                        Text("Top")
                        Spacer(minLength: 0)
                        Text("Bottom")
                    }
                }
        }
        .modalPresenterRoot()
    }
}

#Preview("Content Wrapping Height") {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true
    @Previewable @State var contentHeight: CGFloat?

    @Previewable @State var count: Int = 1

    ZStack {
        // `PreviewContainer` ignores safe areas, so insets must be read differently
        Color.clear
            .onGeometryChange(of: { $0.safeAreaInsets }) { safeAreaInsets = $0 }

        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()
                        
                        appearance.contentMargins = EdgeInsets(
                            leading: 15,
                            trailing: 15,
                            top: 5,
                            bottom: max(15, safeAreaInsets.bottom)
                        )
                        
                        if let contentHeight {
                            let height: CGFloat = appearance.contentWrappingHeight(
                                contentHeight: contentHeight,
                                safeAreaInsets: safeAreaInsets
                            )
                            
                            appearance.sizeGroup.portrait.heights = .absolute(height)
                            appearance.sizeGroup.portrait.heights = .absolute(height)
                        }
                        
                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    VStack(spacing: 20) {
                        ForEach(0..<count, id: \.self) { _ in
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere sem consequat felis imperdiet, eu ornare velit tincidunt. Praesent viverra sem lacus, sed gravida dui cursus sit amet.")
                        }
                        
                        Button("Toggle") {
                            count = count == 1 ? 2 : 1
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .onGeometryChange(of: { $0.size }) { size in
                        Task {
                            contentHeight = size.height
                        }
                    }
                }
        }
        .modalPresenterRoot()
    }
}

#Preview("Scrollable Content") {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true

    ZStack {
        // `PreviewContainer` ignores safe areas, so insets must be read differently
        Color.clear
            .onGeometryChange(of: { $0.safeAreaInsets }) { newValue in
                Task {
                    safeAreaInsets = newValue
                }
            }

        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: ModalPresenterLink(linkID: "preview"),
                    appearance: {
                        var appearance: VBottomSheetAppearance = .init()
                        appearance.autoresizesContent = true
                        return appearance
                    }(),
                    isPresented: $isPresented
                ) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(0..<20) { number in
                                Text(String(number))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 9)
                            }
                        }
                    }
                    .safeAreaPadding(.bottom, safeAreaInsets.bottom)
                }
        }
        .modalPresenterRoot()
    }
}

#Preview("Insetted Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: .insettedContent,
                isPresented: $isPresented
            ) {
                Color.blue
            }
    }
    .modalPresenterRoot()
}

#Preview("No Drag Indicator") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: ModalPresenterLink(linkID: "preview"),
                appearance: {
                    var appearance: VBottomSheetAppearance = .noDragIndicator
                    appearance.contentIsDraggable = true
                    return appearance
                }(),
                isPresented: $isPresented
            ) {
                Color.blue
            }
    }
    .modalPresenterRoot()
}

#endif

#endif
