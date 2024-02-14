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
@available(macOS, unavailable) // No `View.presentationHost(...)`
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)`
@available(watchOS, unavailable) // No `View.presentationHost(...)`
@available(visionOS, unavailable) // No `View.presentationHost(...)`
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VBottomSheetUIModel

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var containerSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentWidth: CGFloat {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).width.toAbsolute(in: containerSize.width)
    }
    private var currentHeightsObject: VBottomSheetUIModel.Heights {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).heights
    }

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode!

    @Binding private var isPresented: Bool
    @State private var isPresentedInternally: Bool = false
    @State private var didFinishInternalPresentation: Bool = false

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
        ZStack(alignment: .top, content: {
            dimmingView
            bottomSheetView
        })
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

            resetHeightFromEnvironmentOrUIModelChange(from: currentHeightsObject)
        })

        .onChange(
            of: uiModel.sizes,
            perform: { resetHeightFromEnvironmentOrUIModelChange(from: $0.current(_interfaceOrientation: interfaceOrientation).heights) }
        )

        .onReceive(presentationMode.presentPublisher, perform: animateIn)
        .onReceive(presentationMode.dismissPublisher, perform: animateOut)
    }
    
    private var dimmingView: some View {
        uiModel.dimmingViewColor
            .contentShape(Rectangle())
            .onTapGesture(perform: dismissFromDimmingViewTap)
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
                VStack(spacing: 0, content: {
                    dragIndicatorView
                })
                .getSize({ headerHeight = $0.height })

                contentView
            })
            .frame(maxHeight: .infinity, alignment: .top)
            .cornerRadius(uiModel.cornerRadius, corners: .topCorners) // Fixes issupe of content-clipping, as it's not in `VGroupBox`
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
    
    @ViewBuilder 
    private var dragIndicatorView: some View {
        if uiModel.dragIndicatorSize.height > 0 {
            RoundedRectangle(cornerRadius: uiModel.dragIndicatorCornerRadius)
                .frame(size: uiModel.dragIndicatorSize)
                .padding(uiModel.dragIndicatorMargins)
                .foregroundStyle(uiModel.dragIndicatorColor)
        }
    }
    
    private var contentView: some View {
        ZStack(content: {
            if !uiModel.contentIsDraggable {
                Color.clear
                    .contentShape(Rectangle())
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

    // MARK: Lifecycle
    private func dismissFromDimmingViewTap() {
        guard
            didFinishInternalPresentation,
            uiModel.dismissType.contains(.backTap)
        else {
            return
        }

        isPresented = false
    }

    private func dismissFromPullDown() {
        isPresented = false
    }

    // MARK: Lifecycle Animations
    private func animateIn() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isPresentedInternally = true },
                completion: { didFinishInternalPresentation = true }
            )

        } else {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isPresentedInternally = true },
                completion: { didFinishInternalPresentation = true }
            )
        }
    }

    private func animateOut() {
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
                completion: presentationMode.dismissCompletion
            )

        } else {
            withBasicAnimation(
                animation,
                body: { isPresentedInternally = false },
                completion: presentationMode.dismissCompletion
            )
        }
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
            
            animateOffsetOrPullDismissFromSnapAction(.dragEndedSnapAction(
                containerHeight: containerSize.height,
                heights: currentHeightsObject,
                canPullDownToDismiss: uiModel.dismissType.contains(.pullDown),
                pullDownDismissDistance: uiModel.pullDownDismissDistance(heights: currentHeightsObject, in: containerSize.height),
                offset: offset,
                offsetBeforeDrag: offsetBeforeDrag,
                translation: dragValue.translation.height
            ))
            
        case true:
            animateOffsetOrPullDismissFromSnapAction(.dragEndedHighVelocitySnapAction(
                containerHeight: containerSize.height,
                heights: currentHeightsObject,
                offset: offset,
                velocity: dragValue.velocity.height
            ))
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

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("Min & Ideal & Max", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        isPresented: $isPresented,
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

#Preview("Min & Ideal", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
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
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

#Preview("Ideal & Max", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
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
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

#Preview("Ideal Small", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
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
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

#Preview("Ideal Large", body: {
    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
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
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

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
                                DispatchQueue.main.async(execute: {
                                    contentHeight = size.height
                                })
                            })
                        }
                    )
            })
        }
    }

    return ContentView()
})

#Preview("Scrollable Content", body: {
    guard #available(iOS 17.0, *) else { return EmptyView() }

    struct ContentView: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                PreviewModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
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
                            .safeAreaPadding(.bottom, UIDevice.safeAreaInsets.bottom)
                        }
                    )
            })
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
                        id: "preview",
                        uiModel: .insettedContent,
                        isPresented: $isPresented,
                        content: { ColorBook.accentBlue }
                    )
            })
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
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .noDragIndicator
                            uiModel.contentIsDraggable = true
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    return ContentView()
})

#endif

#endif
