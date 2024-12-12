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
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var interfaceOrientation: PlatformInterfaceOrientation = .initFromDeviceOrientation()
    
    @Environment(\.presentationHostContainerSize) private var containerSize: CGSize
    @Environment(\.presentationHostSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: CGFloat {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).width.toAbsolute(dimension: containerSize.width)
    }
    
    private var currentHeightsObject: VBottomSheetUIModel.Heights {
        uiModel.sizeGroup.current(orientation: interfaceOrientation).heights
    }
    
    @State private var dragIndicatorHeight: CGFloat = 0

    @State private var _offset: CGFloat? // If `nil`, will be set from body render.
    private var offset: CGFloat { _offset ?? getResetedHeight(from: currentHeightsObject) }

    @State private var offsetBeforeDrag: CGFloat?

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!
    
    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false
    
    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Flags
    @State private var isBeingDismissedFromSwipe: Bool = false

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
                of: uiModel.sizeGroup,
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
                        .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
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

            bottomSheetContentView
                .frame(maxHeight: .infinity, alignment: .top)

                // Fixes issue of content-clipping, as it's not in `VGroupBox`.
                // No need to reverse corners for RTL.
                // `compositingGroup` helps fix glitches within subviews.
                .compositingGroup()
                .clipShape(.rect(cornerRadii: uiModel.cornerRadii))

                .applyIf(!uiModel.contentIsDraggable, transform: {
                    $0
                        .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
                        .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                })
        })
        .frame(width: currentWidth)
        .applyIf(uiModel.contentIsDraggable, transform: {
            $0
                .frame(height: currentHeightsObject.max.toAbsolute(dimension: containerSize.height))
                .offset(y: isPresentedInternally ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        })
    }

    private var bottomSheetContentView: some View {
        VStack(spacing: 0, content: {
            dragIndicatorView
            contentView
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
        .getSize({ dragIndicatorHeight = $0.height }) // If it's not rendered, `0` will be returned
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
            ifTransform: { $0.frame(height: containerSize.height - offset - dragIndicatorHeight) },
            elseTransform: { $0.frame(maxHeight: .infinity) }
        )
    }

    // MARK: Actions
    private func didTapDimmingView() {
        guard uiModel.dismissType.contains(.backTap) else { return }

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

        withAnimation(.linear(duration: 0.1), { // Gets rid of stuttering
            _offset = {
                switch newOffset {
                case ...currentHeightsObject.maxOffset(in: containerSize.height):
                    return currentHeightsObject.maxOffset(in: containerSize.height)

                case currentHeightsObject.minOffset(in: containerSize.height)...:
                    if uiModel.dismissType.contains(.swipe) {
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
                    canSwipeToDismiss: uiModel.dismissType.contains(.swipe),
                    swipeDismissDistance: uiModel.swipeDismissDistance(heights: currentHeightsObject, in: containerSize.height),
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
            isBeingDismissedFromSwipe = true
            dismissFromSwipe()

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
            if isBeingDismissedFromSwipe {
                uiModel.swipeDismissAnimation
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
            uiModel.sizeGroup.portrait.heights,
            uiModel.sizeGroup.landscape.heights
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("*", body: {
    @Previewable @State var isPresented: Bool = true

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
})

#if !os(macOS)

#Preview("Min & Ideal & Max", body: {
    ContentView_MinIdealMax()
})

// Preview macro doesn’t support nested macro expansions
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

                        uiModel.sizeGroup = VBottomSheetUIModel.SizeGroup(
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

// Preview macro doesn’t support nested macro expansions
private struct ContentView_MinIdeal: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizeGroup = VBottomSheetUIModel.SizeGroup(
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

// Preview macro doesn’t support nested macro expansions
private struct ContentView_IdealMax: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizeGroup = VBottomSheetUIModel.SizeGroup(
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

// Preview macro doesn’t support nested macro expansions
private struct ContentView_IdealSmall: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizeGroup = VBottomSheetUIModel.SizeGroup(
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

// Preview macro doesn’t support nested macro expansions
private struct ContentView_IdealLarge: View {
    @State private var isPresented: Bool = true

    var body: some View {
        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
                .vBottomSheet(
                    layerID: "sheets",
                    id: "preview",
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()

                        uiModel.sizeGroup = VBottomSheetUIModel.SizeGroup(
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Content Autoresizing", body: {
    @Previewable @State var isPresented: Bool = true

    PreviewContainer(content: {
        PreviewModalLauncherView(isPresented: $isPresented)
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
                    VStack(spacing: 0, content: {
                        Text("Hello")
                        Spacer()
                        Text("World")
                    })
                    .background(content: { Color.accentColor })
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
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Content Wrapping Height", body: {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true
    @Previewable @State var contentHeight: CGFloat?

    @Previewable @State var count: Int = 1

    ZStack(content: {
        // `PreviewContainer` ignores safe areas, so insets must be read elsewhere
        Color.clear
            .getSafeAreaInsets({ safeAreaInsets = $0 })

        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
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
                            
                            uiModel.sizeGroup.portrait.heights = .absolute(height)
                            uiModel.sizeGroup.portrait.heights = .absolute(height)
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
    })
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Scrollable Content", body: {
    @Previewable @State var safeAreaInsets: EdgeInsets = .init()

    @Previewable @State var isPresented: Bool = true

    ZStack(content: {
        // `PreviewContainer` ignores safe areas, so insets must be read elsewhere
        Color.clear
            .getSafeAreaInsets({ newValue in
                Task(operation: { @MainActor in
                    safeAreaInsets = newValue
                })
            })

        PreviewContainer(content: {
            PreviewModalLauncherView(isPresented: $isPresented)
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
    })
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("Insetted Content", body: {
    @Previewable @State var isPresented: Bool = true

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
})

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview("No Drag Indicator", body: {
    @Previewable @State var isPresented: Bool = true

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
})

#endif

#endif
