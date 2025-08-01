//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import OSLog
import VCore

@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties - Appearance
    private let appearance: VBottomSheetAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Environment(\.modalPresenterInterfaceOrientation) private var interfaceOrientation: PlatformInterfaceOrientation
    @Environment(\.modalPresenterContainerSize) private var containerSize: CGSize
    @Environment(\.modalPresenterSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: CGFloat {
        appearance.sizeGroup.current(orientation: interfaceOrientation).width.toAbsolute(dimension: containerSize.width)
    }
    
    private var currentHeightsObject: VBottomSheetAppearance.Heights {
        appearance.sizeGroup.current(orientation: interfaceOrientation).heights
            .withFixedValues(in: containerSize.height)
    }
    
    @State private var dragIndicatorHeight: CGFloat = 0

    @State private var _offset: CGFloat? // If `nil`, will be set from body render.
    private var offset: CGFloat { _offset ?? getResetedHeight(from: currentHeightsObject) }

    @State private var offsetBeforeDrag: CGFloat?

    // MARK: Properties - Presentation API
    @Environment(\.modalPresenterPresentationMode) private var presentationMode: ModalPresenterPresentationMode!
    
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
            .onChange(of: interfaceOrientation) { (_, newValue) in
                if
                    appearance.dismissesKeyboardWhenInterfaceOrientationChanges,
                    newValue != interfaceOrientation
                {
#if canImport(UIKit) && !os(watchOS)
                    UIApplication.shared.sendResignFirstResponderAction()
#endif
                }
                
                resetHeightFromEnvironmentOrAppearanceChange(from: currentHeightsObject)
            }
            .onChange(of: appearance.sizeGroup) { (_, newValue) in
                resetHeightFromEnvironmentOrAppearanceChange(
                    from: newValue.current(orientation: interfaceOrientation).heights
                        .withFixedValues(in: containerSize.height)
                )
            }

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView)
    }

    private var bottomSheetView: some View {
        ZStack {
            VGroupBox(appearance: appearance.groupBoxAppearance)
                .applyIf(!appearance.contentIsDraggable) {
                    $0
                        .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
                        .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                }
                .shadow(
                    color: appearance.shadowColor,
                    radius: appearance.shadowRadius,
                    offset: appearance.shadowOffset
                )

            bottomSheetContentView
                .frame(maxHeight: .infinity, alignment: .top)

                // Fixes issue of content-clipping, as it's not in `VGroupBox`.
                // No need to reverse corners for RTL.
                // `compositingGroup` helps fix glitches within subviews.
                .compositingGroup()
                .clipShape(.rect(cornerRadii: appearance.cornerRadii))

                .applyIf(!appearance.contentIsDraggable) {
                    $0
                        .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
                        .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                }
        }
        .frame(width: currentWidth)
        .applyIf(appearance.contentIsDraggable) {
            $0
                .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
                .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        }
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
        ZStack {
            if !appearance.contentIsDraggable {
                Color.clear
                    .contentShape(.rect)
            }
            
            content()
                .padding(appearance.contentMargins)
        }
        .safeAreaPaddings(edges: appearance.contentSafeAreaEdges, insets: safeAreaInsets)
        .frame(maxWidth: .infinity)
        .applyIf(appearance.autoresizesContent && currentHeightsObject.isResizable(in: containerSize.height)) {
            $0
                .frame(
                    height: max( // Autoresized content shouldn't get smaller that the `min` height
                        containerSize.height - offset - dragIndicatorHeight,
                        currentHeightsObject.min.toAbsolute(dimension: containerSize.height) - dragIndicatorHeight
                    )
                )
        } else: {
            $0.frame(maxHeight: .infinity)
        }
        .clipped() // Clips off-bound content that might clip into header
    }

    // MARK: Actions
    private func didTapDimmingView() {
        guard appearance.dismissType.contains(.backTap) else { return }

        isPresented = false
    }

    private func dismissFromSwipe() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        guard let offsetBeforeDrag else { fatalError() }

        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height

        withAnimation(.linear(duration: 0.1)) { // Gets rid of stuttering
            _offset = {
                switch newOffset {
                case ...currentHeightsObject.maxOffset(in: containerSize.height):
                    return currentHeightsObject.maxOffset(in: containerSize.height)

                case currentHeightsObject.minOffset(in: containerSize.height)...:
                    if appearance.dismissType.contains(.swipe) {
                        return newOffset
                    } else {
                        return currentHeightsObject.minOffset(in: containerSize.height)
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
                    containerHeight: containerSize.height,
                    heights: currentHeightsObject,
                    offset: offset,
                    velocity: dragValue.velocity.height
                )
            )
            
        } else {
            guard let offsetBeforeDrag else { return }

            animateOffsetOrPullDismissFromDragEndAction(
                .dragEndedDragEndAction(
                    containerHeight: containerSize.height,
                    heights: currentHeightsObject,
                    canSwipeToDismiss: appearance.dismissType.contains(.swipe),
                    swipeDismissDistance: appearance.swipeDismissDistance(heights: currentHeightsObject, in: containerSize.height),
                    offset: offset,
                    offsetBeforeDrag: offsetBeforeDrag,
                    translation: dragValue.translation.height
                )
            )
        }
    }

    private func animateOffsetOrPullDismissFromDragEndAction(
        _ dragEndAction: VBottomSheetDragEndAction
    ) {
        switch dragEndAction {
        case .dismiss:
            isBeingDismissedFromSwipe = true
            dismissFromSwipe()

        case .snap(let newOffset):
            withAnimation(appearance.heightSnapAnimation) { _offset = newOffset }
        }
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        withAnimation(
            appearance.appearAnimation,
            { isPresentedInternally = true }
        )
    }

    private func animateOut(
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
        heights.idealOffset(in: containerSize.height)
    }
}

#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: rootAndLink.link(linkID: "preview"),
                isPresented: $isPresented
            ) {
                Color.blue
            }
    }
    .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
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
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
    }
}

#Preview("Content Wrapping Height") {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true
    @Previewable @State var contentHeight: CGFloat?

    @Previewable @State var count: Int = 1

    ZStack {
        // `PreviewContainer` ignores safe areas, so insets must be read elsewhere
        Color.clear
            .getSafeAreaInsets { safeAreaInsets = $0 }

        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: rootAndLink.link(linkID: "preview"),
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
                        Task { @MainActor in
                            contentHeight = size.height
                        }
                    }
                }
        }
        .modalPresenterRoot(root: rootAndLink.root)
    }
}

#Preview("Scrollable Content") {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true

    ZStack {
        // `PreviewContainer` ignores safe areas, so insets must be read elsewhere
        Color.clear
            .getSafeAreaInsets { newValue in
                Task { @MainActor in
                    safeAreaInsets = newValue
                }
            }

        PreviewContainer {
            ModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    link: rootAndLink.link(linkID: "preview"),
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
        .modalPresenterRoot(root: rootAndLink.root)
    }
}

#Preview("Insetted Content") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: rootAndLink.link(linkID: "preview"),
                appearance: .insettedContent,
                isPresented: $isPresented
            ) {
                Color.blue
            }
    }
    .modalPresenterRoot(root: rootAndLink.root)
}

#Preview("No Drag Indicator") {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer {
        ModalLauncherView(isPresented: $isPresented)
            .vBottomSheet(
                link: rootAndLink.link(linkID: "preview"),
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
    .modalPresenterRoot(root: rootAndLink.root)
}

#endif

private let rootAndLink: ModalPresenterRootAndLink = .overlay

#endif
