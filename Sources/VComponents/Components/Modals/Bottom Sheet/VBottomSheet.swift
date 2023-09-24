//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet
@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS, unavailable) // No `View.presentationHost(...)` support
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
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handlers
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Frame
    @State private var headerHeight: CGFloat = 0

    // If `nil`, will be set from body render.
    @State private var _offset: CGFloat?
    private var offset: CGFloat { _offset ?? getResetedHeight(from: currentHeightsObject) }

    @State private var offsetBeforeDrag: CGFloat?

    // MARK: Initializers
    init(
        uiModel: VBottomSheetUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        Self.assertUIModel(uiModel)
        
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: .top, content: {
            dimmingView
            bottomSheet
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
    
    private var bottomSheet: some View {
        ZStack(content: {
            VGroupBox(uiModel: uiModel.groupBoxSubUIModel)
                .applyIf(!uiModel.contentIsDraggable, transform: {
                    $0
                        .frame( // Max dimension fixes issue of safe areas and/or landscape
                            maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                        )
                        .offset(y: isInternallyPresented ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
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
                    dragIndicator
                })
                .getSize({ headerHeight = $0.height })

                contentView
            })
            .frame(maxHeight: .infinity, alignment: .top)
            .cornerRadius(uiModel.cornerRadius, corners: .topCorners) // Fixes issue of content-clipping, as it's not in `VGroupBox`
            .applyIf(!uiModel.contentIsDraggable, transform: {
                $0
                    .frame( // Max dimension fixes issue of safe areas and/or landscape
                        maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                    )
                    .offset(y: isInternallyPresented ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
            })
        })
        .frame(width: currentWidth)
        .applyIf(uiModel.contentIsDraggable, transform: {
            $0
                .frame( // Max dimension fixes issue of safe areas and/or landscape
                    maxHeight: currentHeightsObject.max.toAbsolute(in: containerSize.height)
                )
                .offset(y: isInternallyPresented ? offset : currentHeightsObject.hiddenOffset(in: containerSize.height))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        })
    }
    
    @ViewBuilder private var dragIndicator: some View {
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
                $0.safeAreaPaddings(edges: uiModel.contentSafeAreaMargins, insets: safeAreaInsets)
            } else {
                $0.safeAreaMargins(edges: uiModel.contentSafeAreaMargins, insets: safeAreaInsets)
            }
        })
        .frame(maxWidth: .infinity)
        .applyIf(
            uiModel.autoresizesContent && currentHeightsObject.isResizable,
            ifTransform: { $0.frame(height: containerSize.height - offset - headerHeight) },
            elseTransform: { $0.frame(maxHeight: .infinity) }
        )
    }
    
    // MARK: Animation
    private func animateIn() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.appearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = true },
                completion: { presentHandler?() }
            )

        } else {
            withBasicAnimation(
                uiModel.appearAnimation,
                body: { isInternallyPresented = true },
                completion: {
                    DispatchQueue.main.async(execute: { presentHandler?() })
                }
            )
        }
    }
    
    private func animateOut() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
            )
        }
    }
    
    private func animateOutFromDrag() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.pullDownDismissAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.pullDownDismissAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.dismiss()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
            )
        }
    }
    
    private func animateOutFromExternalDismiss() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            withAnimation(
                uiModel.disappearAnimation?.toSwiftUIAnimation,
                { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    dismissHandler?()
                }
            )

        } else {
            withBasicAnimation(
                uiModel.disappearAnimation,
                body: { isInternallyPresented = false },
                completion: {
                    presentationMode.externalDismissCompletion()
                    DispatchQueue.main.async(execute: { dismissHandler?() })
                }
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
        case .dismiss: animateOutFromDrag()
        case .snap(let newOffset): withAnimation(uiModel.heightSnapAnimation, { _offset = newOffset })
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
    
    // MARK: Assertion
    private static func assertUIModel(_ uiModel: VBottomSheetUIModel) {
        let heightsGroup: [VBottomSheetUIModel.Heights] = [
            uiModel.sizes.portrait.heights,
            uiModel.sizes.landscape.heights
        ]

        for heights in heightsGroup {
            guard heights.min.value <= heights.ideal.value else {
                VCoreFatalError("'VBottomSheet''s 'min' height must be less than or equal to 'ideal' height", module: "VComponents")
            }

            guard heights.ideal.value <= heights.max.value else {
                VCoreFatalError("'VBottomSheet''s 'ideal' height must be less than or equal to 'max' height", module: "VComponents")
            }
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VBottomSheet_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            FixedHeightMinIdealPreview().previewDisplayName("Fixed Height (Min & Ideal)")
            FixedHeightIdealMaxPreview().previewDisplayName("Fixed Height (Ideal & Max)")
            FixedHeightMinIdealMaxLargePreview().previewDisplayName("Fixed Height (Large)")
            FixedHeightMinIdealMaxSmallPreview().previewDisplayName("Fixed Height (Small)")
            InsettedContentPreview().previewDisplayName("Insetted Content")
            ScrollableContentPreview().previewDisplayName("Scrollable Content")
            NoDragIndicatorPreview().previewDisplayName("No Drag Indicator")
            WrappedContentPreview().previewDisplayName("Wrapped Content")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem Ipsum Dolor Sit Amet".pseudoRTL(languageDirection) }
    
    private static func content() -> some View {
        ColorBook.accentBlue
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: content
                    )
            })
        }
    }
    
    private struct FixedHeightMinIdealPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

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
                        content: content
                    )
            })
        }
    }
    
    private struct FixedHeightIdealMaxPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

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
                        content: content
                    )
            })
        }
    }
    
    private struct FixedHeightMinIdealMaxLargePreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

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
                        content: content
                    )
            })
        }
    }
    
    private struct FixedHeightMinIdealMaxSmallPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

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
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .insettedContent
                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme
                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: content
                    )
            })
        }
    }
    
    private struct ScrollableContentPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
#if os(iOS)
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

                            uiModel.autoresizesContent = true

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: {
                            ScrollView(content: {
                                VStack(spacing: 0, content: {
                                    ForEach(0..<20, content: { number in
                                        VListRow(
                                            uiModel: .noFirstAndLastSeparators(isFirst: number == 0),
                                            content: {
                                                Text(String(number))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        )
                                    })
                                })
                            })
                            .safeAreaPadding(.bottom, UIDevice.safeAreaInsets.bottom)
                        }
                    )
            })
#endif
        }
    }
    
    private struct NoDragIndicatorPreview: View {
        @State private var isPresented: Bool = true

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .noDragIndicator

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

                            uiModel.contentIsDraggable = true

                            return uiModel
                        }(),
                        isPresented: $isPresented,
                        content: { ColorBook.accentBlue }
                    )
            })
        }
    }

    private struct WrappedContentPreview: View {
        @State private var safeAreaInsets: EdgeInsets = .init()

        @State private var isPresented: Bool = true
        @State private var contentHeight: CGFloat?

        @State private var count: Int = 1

        var body: some View {
            PreviewContainer(content: {
                ModalLauncherView(isPresented: $isPresented)
                    .getSafeAreaInsets({ safeAreaInsets = $0 })
                    .vBottomSheet(
                        id: "preview",
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()

                            uiModel.colorScheme = VBottomSheet_Previews.colorScheme

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
                            .getSize({ contentHeight = $0.height })
                        }
                    )
            })
        }
    }
}
