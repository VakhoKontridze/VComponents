//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import OSLog
import VCore

// MARK: - V Bottom Sheet
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VBottomSheetUIModel

    private var currentWidth: CGFloat {
        uiModel.sizes.current(orientation: interfaceOrientation).width.toAbsolute(in: containerSize.width)
    }
    private var currentHeightsObject: VBottomSheetUIModel.Heights {
        uiModel.sizes.current(orientation: interfaceOrientation).heights
    }
    
    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize
    @Environment(\.presentationHostSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()

    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!
    
    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false
    
    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Frame
    @State private var headerHeight: CGFloat = 0

    // If `nil`, will be set from body render.
    @State private var _offset: CGFloat?
    private var offset: CGFloat { _offset ?? getResetedHeight(from: currentHeightsObject) }

    @State private var offsetBeforeDrag: CGFloat?

    // MARK: Properties - Flags
    @State private var isBeingDismissedFromPullDown: Bool = false

    // MARK: Initializers
    init(
        uiModel: VBottomSheetUIModel,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        Self.validate(uiModel: uiModel)

        self.uiModel = uiModel
        self._isPresented = isPresented
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        bottomSheetView
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
                
                resetHeightFromEnvironmentOrUIModelChange(from: currentHeightsObject)
            })
            .onChange(
                of: uiModel.sizes,
                perform: { resetHeightFromEnvironmentOrUIModelChange(from: $0.current(orientation: interfaceOrientation).heights) }
            )

            .onReceive(presentationMode.presentPublisher, perform: animateIn)
            .onReceive(presentationMode.dismissPublisher, perform: animateOut)
            .onReceive(presentationMode.dimmingViewTapActionPublisher, perform: didTapDimmingView)
    }

    private var bottomSheetView: some View {
        ZStack(content: {
            VGroupBox(uiModel: uiModel.groupBoxSubUIModel)
                .applyIf(!uiModel.contentIsDraggable, transform: {
                    $0
                        .frame( // Max dimension fixes issue of safe areas and/or landscape
                            maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                        )
                        .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                })
                .shadow(
                    color: uiModel.shadowColor,
                    radius: uiModel.shadowRadius,
                    offset: uiModel.shadowOffset
                )

            VStack(spacing: 0, content: {
                dragIndicatorView
                contentView
            })
            .frame(maxHeight: .infinity, alignment: .top)
            
            // Fixes issue of content-clipping, as it's not in `VGroupBox`.
            // No need to reverse corners for RTL.
            // `compositingGroup` helps fix glitches within subviews.
            .compositingGroup()
            .clipShape(.rect(cornerRadii: uiModel.cornerRadii))
            
            .applyIf(!uiModel.contentIsDraggable, transform: {
                $0
                    .frame( // Max dimension fixes issue of safe areas and/or landscape
                        maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                    )
                    .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
            })
        })
        .frame(width: currentWidth)
        .applyIf(uiModel.contentIsDraggable, transform: {
            $0
                .frame( // Max dimension fixes issue of safe areas and/or landscape
                    maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                )
                .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        })
    }

    private var dragIndicatorView: some View {
        ZStack(content: {
            if uiModel.dragIndicatorSize.height > 0 {
                RoundedRectangle(cornerRadius: uiModel.dragIndicatorCornerRadius)
                    .frame(size: uiModel.dragIndicatorSize)
                    .padding(uiModel.dragIndicatorMargins)
                    .foregroundStyle(uiModel.dragIndicatorColor)
            }
        })
        .getSize({ headerHeight = $0.height }) // If it's not rendered, `0` will be returned
    }
    
    private var contentView: some View {
        ZStack(content: {
            if !uiModel.contentIsDraggable {
                Color.clear
                    .contentShape(.rect)
            }
            
            content()
                .padding(uiModel.contentMargins)
        })
        .applyModifier({
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                $0.safeAreaPaddings(edges: uiModel.contentSafeAreaEdges, insets: safeAreaInsets)
            } else {
                $0.safeAreaMargins(edges: uiModel.contentSafeAreaEdges, insets: safeAreaInsets)
            }
        })
        .frame(maxWidth: .infinity)
        .applyIf(
            uiModel.autoresizesContent && currentHeightsObject.isResizable,
            ifTransform: { $0.frame(height: containerSize.height - offset - headerHeight) },
            elseTransform: { $0.frame(maxHeight: .infinity) }
        )
    }

    // MARK: Actions
    private func didTapDimmingView() {
        guard uiModel.dismissType.contains(.backTap) else { return }

        isPresented = false
    }

    private func dismissFromPullDown() {
        isPresented = false
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        guard let offsetBeforeDrag else { fatalError() }

        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height

        withAnimation(.linear(duration: 0.1), { // Gets rid of stuttering
            _offset = {
                switch newOffset {
                case ...currentHeightsObject.maxOffset(in: containerSize.height):
                    return currentHeightsObject.maxOffset(in: containerSize.height)

                case currentHeightsObject.minOffset(in: containerSize.height)...:
                    if uiModel.dismissType.contains(.pullDown) {
                        return newOffset
                    } else {
                        return currentHeightsObject.minOffset(in: containerSize.height)
                    }

                default:
                    return newOffset
                }
            }()
        })
    }

    private func dragEnded(dragValue: DragGesture.Value) {
        defer { offsetBeforeDrag = nil }

        let velocityExceedsNextAreaSnapThreshold: Bool =
            abs(dragValue.velocity.height) >=
            abs(uiModel.velocityToSnapToNextHeight)

        switch velocityExceedsNextAreaSnapThreshold {
        case false:
            guard let offsetBeforeDrag else { return }

            animateOffsetOrPullDismissFromSnapAction(
                .dragEndedSnapAction(
                    containerHeight: containerSize.height,
                    heights: currentHeightsObject,
                    canPullDownToDismiss: uiModel.dismissType.contains(.pullDown),
                    pullDownDismissDistance: uiModel.pullDownDismissDistance(heights: currentHeightsObject, in: containerSize.height),
                    offset: offset,
                    offsetBeforeDrag: offsetBeforeDrag,
                    translation: dragValue.translation.height
                )
            )

        case true:
            animateOffsetOrPullDismissFromSnapAction(
                .dragEndedHighVelocitySnapAction(
                    containerHeight: containerSize.height,
                    heights: currentHeightsObject,
                    offset: offset,
                    velocity: dragValue.velocity.height
                )
            )
        }
    }

    private func animateOffsetOrPullDismissFromSnapAction(
        _ snapAction: VBottomSheetSnapAction
    ) {
        switch snapAction {
        case .dismiss:
            isBeingDismissedFromPullDown = true
            dismissFromPullDown()

        case .snap(let newOffset):
            withAnimation(uiModel.heightSnapAnimation, { _offset = newOffset })
        }
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
            if isBeingDismissedFromPullDown {
                uiModel.pullDownDismissAnimation
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

    // MARK: Orientation
    private func resetHeightFromEnvironmentOrUIModelChange(
        from heights: VBottomSheetUIModel.Heights
    ) {
        _offset = getResetedHeight(from: heights)
    }

    private func getResetedHeight(
        from heights: VBottomSheetUIModel.Heights
    ) -> CGFloat {
        heights.idealOffset(in: containerSize.height)
    }

    // MARK: Validation
    private static func validate(
        uiModel: VBottomSheetUIModel
    ) {
        let heightsGroup: [VBottomSheetUIModel.Heights] = [
            uiModel.sizes.portrait.heights,
            uiModel.sizes.landscape.heights
        ]

        for heights in heightsGroup {
            guard heights.min.value <= heights.ideal.value else {
                Logger.bottomSheet.critical("'min' height must be less than or equal to 'ideal' height in 'VBottomSheet'")
                fatalError()
            }

            guard heights.ideal.value <= heights.max.value else {
                Logger.bottomSheet.critical("'ideal' height must be less than or equal to 'max' height in 'VBottomSheet'")
                fatalError()
            }
        }
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS))

#Preview("*", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        layerID: "sheets",
                        id: "preview",
                        isPresented: $isPresented,
                        content: { Color.blue }
                    )
            })
            .presentationHostLayer(
                id: "sheets",
                uiModel: {
                    var uiModel: PresentationHostLayerUIModel = .init()
                    uiModel.dimmingViewColor = Color.clear
                    return uiModel
                }()
            )
        }
    }

    return ContentView()
})

#if !os(macOS)

#Preview("Min & Ideal & Max", body: { // TODO: Move into macro when nested macro expansions are supported
    ContentView_MinIdealMax()
})
private struct ContentView_MinIdealMax: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizes = VBottomSheetUIModel.Sizes(
                            portrait: VBottomSheetUIModel.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            ),
                            landscape: VBottomSheetUIModel.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.3, ideal: 0.6, max: 0.9)
                            )
                        )

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer(
            id: "sheets",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#if !os(macOS)

#Preview("Min & Ideal", body: {
    ContentView_MinIdeal()
})
private struct ContentView_MinIdeal: View { // TODO: Move into macro when nested macro expansions are supported
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizes = VBottomSheetUIModel.Sizes(
                            portrait: VBottomSheetUIModel.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.6, ideal: 0.9, max: 0.9)
                            ),
                            landscape: VBottomSheetUIModel.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.6, ideal: 0.9, max: 0.9)
                            )
                        )

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer(
            id: "sheets",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#if !os(macOS)

#Preview("Ideal & Max", body: {
    ContentView_IdealMax()
})
private struct ContentView_IdealMax: View { // TODO: Move into macro when nested macro expansions are supported
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizes = VBottomSheetUIModel.Sizes(
                            portrait: VBottomSheetUIModel.Size(
                                width: .fraction(1),
                                heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
                            ),
                            landscape: VBottomSheetUIModel.Size(
                                width: .fraction(0.7),
                                heights: .fraction(min: 0.6, ideal: 0.6, max: 0.9)
                            )
                        )

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer(
            id: "sheets",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#if !os(macOS)

#Preview("Ideal Small", body: {
    ContentView_IdealSmall()
})
private struct ContentView_IdealSmall: View { // TODO: Move into macro when nested macro expansions are supported
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizes = VBottomSheetUIModel.Sizes(
                            portrait: VBottomSheetUIModel.Size(
                                width: .fraction(1),
                                heights: .fraction(0.2)
                            ),
                            landscape: VBottomSheetUIModel.Size(
                                width: .fraction(0.7),
                                heights: .fraction(0.2)
                            )
                        )

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer(
            id: "sheets",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#if !os(macOS)

#Preview("Ideal Large", body: {
    ContentView_IdealLarge()
})
private struct ContentView_IdealLarge: View { // TODO: Move into macro when nested macro expansions are supported
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizes = VBottomSheetUIModel.Sizes(
                            portrait: VBottomSheetUIModel.Size(
                                width: .fraction(1),
                                heights: .fraction(0.9)
                            ),
                            landscape: VBottomSheetUIModel.Size(
                                width: .fraction(0.7),
                                heights: .fraction(0.9)
                            )
                        )

                        return uiModel
                    }(),
                    isPresented: $isPresented,
                    content: { Color.blue }
                )
        })
        .presentationHostLayer(
            id: "sheets",
            uiModel: {
                var uiModel: PresentationHostLayerUIModel = .init()
                uiModel.dimmingViewColor = Color.clear
                return uiModel
            }()
        )
    }
}

#endif

#Preview("Wrapped Content", body: {
    struct ContentView: View {
        @State private var safeAreaInsets: EdgeInsets = .init()

        @State private var isPresented: Bool = true
        @State private var contentHeight: CGFloat?

        @State private var count: Int = 1

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .getSafeAreaInsets({ safeAreaInsets = $0 })
                    .vBottomSheet(
                        layerID: "sheets",
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.contentMargins = VBottomSheetUIModel.Margins(
                                leading: 15,
                                trailing: 15,
                                top: 5,
                                bottom: max(15, safeAreaInsets.bottom)
                            )

                            if let contentHeight {
                                let height: CGFloat = uiModel.contentWrappingHeight(
                                    contentHeight: contentHeight,
                                    safeAreaInsets: safeAreaInsets
                                )

                                uiModel.sizes.portrait.heights = .absolute(height)
                                uiModel.sizes.portrait.heights = .absolute(height)
                            }

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: {
                            VStack(spacing: 20, content: {
                                ForEach(0..<count, id: \.self, content: { _ in
                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce posuere sem consequat felis imperdiet, eu ornare velit tincidunt. Praesent viverra sem lacus, sed gravida dui cursus sit amet.")
                                })

                                Button(
                                    "Toggle",
                                    action: { count = count == 1 ? 2 : 1 }
                                )
                            })
                            .fixedSize(horizontal: false, vertical: true)
                            .getSize({ size in
                                Task(operation: { contentHeight = size.height })
                            })
                        }
                    )
            })
            .presentationHostLayer(
                id: "sheets",
                uiModel: {
                    var uiModel: PresentationHostLayerUIModel = .init()
                    uiModel.dimmingViewColor = Color.clear
                    return uiModel
                }()
            )
        }
    }

    return ContentView()
})

#Preview("Scrollable Content", body: {
    guard #available(iOS 17.0, macOS 14.0, *) else { return EmptyView() }

    struct ContentView: View {
        @State private var safeAreaInsets: EdgeInsets = .init()

        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .getSafeAreaInsets({ safeAreaInsets = $0 })
                    .vBottomSheet(
                        layerID: "sheets",
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.autoresizesContent = true
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: {
                            ScrollView(content: {
                                VStack(spacing: 0, content: {
                                    ForEach(0..<20, content: { number in
                                        Text(String(number))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 9)
                                    })
                                })
                            })
                            .safeAreaPadding(.bottom, safeAreaInsets.bottom)
                        }
                    )
            })
            .presentationHostLayer(
                id: "sheets",
                uiModel: {
                    var uiModel: PresentationHostLayerUIModel = .init()
                    uiModel.dimmingViewColor = Color.clear
                    return uiModel
                }()
            )
        }
    }

    return ContentView()
})

#Preview("Insetted Content", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        layerID: "sheets",
                        id: "preview",
                        uiModel: .insettedContent,
                        isPresented: $isPresented,
                        content: { Color.blue }
                    )
            })
            .presentationHostLayer(
                id: "sheets",
                uiModel: {
                    var uiModel: PresentationHostLayerUIModel = .init()
                    uiModel.dimmingViewColor = Color.clear
                    return uiModel
                }()
            )
        }
    }

    return ContentView()
})

#Preview("No Drag Indicator", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        layerID: "sheets",
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .noDragIndicator
                            uiModel.contentIsDraggable = true
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: { Color.blue }
                    )
            })
            .presentationHostLayer(
                id: "sheets",
                uiModel: {
                    var uiModel: PresentationHostLayerUIModel = .init()
                    uiModel.dimmingViewColor = Color.clear
                    return uiModel
                }()
            )
        }
    }

    return ContentView()
})

#endif

#endif
