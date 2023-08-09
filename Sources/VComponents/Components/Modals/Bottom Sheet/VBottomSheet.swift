//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VBottomSheetUIModel

    @State private var interfaceOrientation: _InterfaceOrientation = .initFromSystemInfo()
    @Environment(\.presentationHostGeometryReaderSize) private var screenSize: CGSize
    @Environment(\.presentationHostGeometryReaderSafeAreaInsets) private var safeAreaInsets: EdgeInsets

    private var currentSize: VBottomSheetUIModel.BottomSheetSize {
        uiModel.sizes.current(_interfaceOrientation: interfaceOrientation).size(in: screenSize)
    }

    private var hasHeader: Bool {
        headerLabel.hasLabel ||
        uiModel.dismissType.hasButton
    }

    private var hasGrabber: Bool {
        uiModel.grabberSize.height > 0 &&
        (uiModel.dismissType.contains(.pullDown) || currentSize.heights.isResizable)
    }

    private var hasDivider: Bool {
        hasHeader &&
        uiModel.dividerHeight.toPoints(scale: displayScale) > 0
    }

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - Presentation API
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @State private var isInternallyPresented: Bool = false

    // MARK: Properties - Handlers
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?

    // MARK: Properties - Label
    @State private var headerLabel: VBottomSheetHeaderLabel<AnyView> = VBottomSheetHeaderLabelPreferenceKey.defaultValue

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Sizes
    @State private var grabberHeaderAndDividerHeight: CGFloat = 0

    // MARK: Properties - Sizes - Offset
    // If `nil`, will be set from body render.
    @State private var _offset: CGFloat?
    private var offset: CGFloat { _offset ?? getResetedHeight() }

    @State private var offsetBeforeDrag: CGFloat?

    @State private var currentDragValue: DragGesture.Value?
    @State private var previousDragValue: DragGesture.Value?

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
        syncOffsetWithProperStateIfNeeded()

        return ZStack(alignment: .top, content: {
            dimmingView
            bottomSheet
        })
        .environment(\.colorScheme, uiModel.colorScheme ?? colorScheme)

        ._getInterfaceOrientation({
            interfaceOrientation = $0
            resetHeightFromOrientationChange()
        })

        .onAppear(perform: animateIn)
        .onChange(
            of: presentationMode.isExternallyDismissed,
            perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
        )

        .onPreferenceChange(VBottomSheetHeaderLabelPreferenceKey.self, perform: { headerLabel = $0 })
    }
    
    private var dimmingView: some View {
        uiModel.dimmingViewColor
            .ignoresSafeArea()
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
                            maxHeight: currentSize.heights.max
                        )
                        .offset(y: isInternallyPresented ? offset : currentSize.heights.hiddenOffset(in: screenSize.height))
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
                    grabber
                    header
                    divider
                })
                .getSize({ grabberHeaderAndDividerHeight = $0.height })
                .safeAreaMargins(edges: uiModel.headerSafeAreaEdges, safeAreaInsets)

                contentView
            })
            .frame(maxHeight: .infinity, alignment: .top)
            .cornerRadius(uiModel.cornerRadius, corners: .topCorners) // Fixes issue of content-clipping, as it's not in `VGroupBox`
            .applyIf(!uiModel.contentIsDraggable, transform: {
                $0
                    .frame( // Max dimension fixes issue of safe areas and/or landscape
                        maxHeight: currentSize.heights.max
                    )
                    .offset(y: isInternallyPresented ? offset : currentSize.heights.hiddenOffset(in: screenSize.height))
            })
        })
        .frame(width: currentSize.width)
        .applyIf(uiModel.contentIsDraggable, transform: {
            $0
                .frame( // Max dimension fixes issue of safe areas and/or landscape
                    maxHeight: currentSize.heights.max
                )
                .offset(y: isInternallyPresented ? offset : currentSize.heights.hiddenOffset(in: screenSize.height))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        })
        .ignoresSafeArea(.container, edges: .all)
        .ignoresSafeArea(.keyboard, edges: uiModel.ignoredKeyboardSafeAreaEdges)
    }
    
    @ViewBuilder private var grabber: some View {
        if hasGrabber {
            RoundedRectangle(cornerRadius: uiModel.grabberCornerRadius)
                .frame(size: uiModel.grabberSize)
                .padding(uiModel.grabberMargins)
                .foregroundColor(uiModel.grabberColor)
        }
    }
    
    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(
                alignment: uiModel.headerAlignment,
                spacing: uiModel.headerLabelAndCloseButtonSpacing,
                content: {
                    Group(content: {
                        if uiModel.dismissType.contains(.leadingButton) {
                            closeButton
                        } else if uiModel.dismissType.contains(.trailingButton) {
                            closeButtonCompensator
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group(content: {
                        switch headerLabel {
                        case .empty:
                            EmptyView()
                            
                        case .title(let title):
                            Text(title)
                                .lineLimit(1)
                                .foregroundColor(uiModel.headerTitleTextColor)
                                .font(uiModel.headerTitleTextFont)
                            
                        case .label(let label):
                            label()
                        }
                    })
                    .layoutPriority(1)
                    
                    Group(content: {
                        if uiModel.dismissType.contains(.trailingButton) {
                            closeButton
                        } else if uiModel.dismissType.contains(.leadingButton) {
                            closeButtonCompensator
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            )
            .padding(uiModel.headerMargins)
        }
    }
    
    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: uiModel.dividerHeight.toPoints(scale: displayScale))
                .padding(uiModel.dividerMargins)
                .foregroundColor(uiModel.dividerColor)
        }
    }

    private var closeButton: some View {
        VRoundedButton(
            uiModel: uiModel.closeButtonSubUIModel,
            action: animateOut,
            icon: ImageBook.xMark.renderingMode(.template)
        )
    }

    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: uiModel.closeButtonSubUIModel.size.width)
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
        .safeAreaMargins(edges: uiModel.headerSafeAreaEdges, safeAreaInsets)
        .frame(maxWidth: .infinity)
        .applyIf(
            uiModel.autoresizesContent && currentSize.heights.isResizable,
            ifTransform: { $0.frame(height: screenSize.height - offset - grabberHeaderAndDividerHeight) },
            elseTransform: { $0.frame(maxHeight: .infinity) }
        )
    }
    
    // MARK: Animation
    private func animateIn() {
        withBasicAnimation(
            uiModel.appearAnimation,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }
    
    private func animateOut() {
        withBasicAnimation(
            uiModel.disappearAnimation,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.pullDownDismissAnimation,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.disappearAnimation,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        guard let offsetBeforeDrag else { fatalError() }
        
        previousDragValue = currentDragValue
        currentDragValue = dragValue
        
        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height
        
        withAnimation(.linear(duration: 0.1), { // Gets rid of stuttering
            _offset = {
                switch newOffset {
                case ...currentSize.heights.maxOffset(in: screenSize.height):
                    return currentSize.heights.maxOffset(in: screenSize.height)
                    
                case currentSize.heights.minOffset(in: screenSize.height)...:
                    if uiModel.dismissType.contains(.pullDown) {
                        return newOffset
                    } else {
                        return currentSize.heights.minOffset(in: screenSize.height)
                    }
                    
                default:
                    return newOffset
                }
            }()
        })
    }
    
    private func dragEnded(dragValue: DragGesture.Value) {
        defer {
            offsetBeforeDrag = nil
            previousDragValue = nil
            currentDragValue = nil
        }
        
        let velocityExceedsNextAreaSnapThreshold: Bool =
            abs(dragValue.velocity(inRelationTo: previousDragValue).height) >=
            abs(uiModel.velocityToSnapToNextHeight)
        
        switch velocityExceedsNextAreaSnapThreshold {
        case false:
            guard let offsetBeforeDrag else { return }
            
            animateOffsetOrPullDismissFromSnapAction(.dragEndedSnapAction(
                screenHeight: screenSize.height,
                heights: currentSize.heights,
                canPullDownToDismiss: uiModel.dismissType.contains(.pullDown),
                pullDownDismissDistance: uiModel.pullDownDismissDistance(size: currentSize),
                offset: offset,
                offsetBeforeDrag: offsetBeforeDrag,
                translation: dragValue.translation.height
            ))
            
        case true:
            animateOffsetOrPullDismissFromSnapAction(.dragEndedHighVelocitySnapAction(
                screenHeight: screenSize.height,
                heights: currentSize.heights,
                offset: offset,
                velocity: dragValue.velocity(inRelationTo: previousDragValue).height
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
    private func syncOffsetWithProperStateIfNeeded() {
        DispatchQueue.main.async(execute: {
            if _offset == nil { resetHeightFromOrientationChange() }
        })
    }

    private func resetHeightFromOrientationChange() {
        _offset = getResetedHeight()
    }

    private func getResetedHeight() -> CGFloat {
        currentSize.heights.idealOffset(in: screenSize.height)
    }
    
    // MARK: Assertion
    private static func assertUIModel(_ uiModel: VBottomSheetUIModel) {
        let sizes: [VBottomSheetUIModel.BottomSheetSize] = [
            uiModel.sizes.portrait.size(in: CGSize(dimension: 1)),
            uiModel.sizes.landscape.size(in: CGSize(dimension: 1))
        ]

        for size in sizes {
            guard size.heights.min <= size.heights.ideal else {
                VCoreFatalError("`VBottomSheet`'s `min` height must be less than or equal to `ideal` height", module: "VComponents")
            }

            guard size.heights.ideal <= size.heights.max else {
                VCoreFatalError("`VBottomSheet`'s `ideal` height must be less than or equal to `max` height", module: "VComponents")
            }
        }
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
            OnlyGrabberPreview().previewDisplayName("Only Grabber")
            FullSizedContentPreview().previewDisplayName("Full-Sized Content")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var headerTitle: String { "Lorem Ipsum Dolor Sit Amet".pseudoRTL(languageDirection) }
    
    private static func content() -> some View {
        ColorBook.accentBlue
            .vBottomSheetHeaderTitle(headerTitle)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct FixedHeightMinIdealPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.sizes = VBottomSheetUIModel.Sizes(
                                portrait: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 1,
                                    heights: .init(min: 0.6, ideal: 0.6, max: 0.9)
                                )),
                                landscape: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 0.7,
                                    heights: .init(min: 0.6, ideal: 0.6, max: 0.9)
                                ))
                            )
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct FixedHeightIdealMaxPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.sizes = VBottomSheetUIModel.Sizes(
                                portrait: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 1,
                                    heights: .init(min: 0.6, ideal: 0.9, max: 0.9)
                                )),
                                landscape: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 0.7,
                                    heights: .init(min: 0.6, ideal: 0.9, max: 0.9)
                                ))
                            )
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct FixedHeightMinIdealMaxLargePreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.sizes = VBottomSheetUIModel.Sizes(
                                portrait: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 1,
                                    heights: VBottomSheetUIModel.BottomSheetHeights(0.9)
                                )),
                                landscape: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 0.7,
                                    heights: VBottomSheetUIModel.BottomSheetHeights(0.9)
                                ))
                            )
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct FixedHeightMinIdealMaxSmallPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .init()
                            uiModel.sizes = VBottomSheetUIModel.Sizes(
                                portrait: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 1,
                                    heights: VBottomSheetUIModel.BottomSheetHeights(0.2)
                                )),
                                landscape: .fraction(VBottomSheetUIModel.BottomSheetSize(
                                    width: 0.7,
                                    heights: VBottomSheetUIModel.BottomSheetHeights(0.2)
                                ))
                            )
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .insettedContent
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: content
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct ScrollableContentPreview: View {
        var body: some View {
#if os(iOS)
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .scrollableContent
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: {
                            List(content: {
                                ForEach(0..<20, content: { number in
                                    VListRow(uiModel: .noFirstAndLastSeparators(isFirst: number == 0), content: {
                                        Text(String(number))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                                })
                            })
                            .vListStyle()
                            .vBottomSheetHeaderTitle(headerTitle)
                        }
                    )
                })
                .ignoresSafeArea()
            })
#endif
        }
    }
    
    private struct FullSizedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .fullSizedContent
                            uiModel.contentIsDraggable = true
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: { ColorBook.accentBlue }
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
    
    private struct OnlyGrabberPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PresentationHostGeometryReader(content: {
                    VBottomSheet(
                        uiModel: {
                            var uiModel: VBottomSheetUIModel = .onlyGrabber
                            uiModel.contentIsDraggable = true
                            uiModel.appearAnimation = nil
                            return uiModel
                        }(),
                        onPresent: nil,
                        onDismiss: nil,
                        content: { ColorBook.accentBlue }
                    )
                })
                .ignoresSafeArea()
            })
        }
    }
}
