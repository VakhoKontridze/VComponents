//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - V Bottom Sheet
@available(iOS 15.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 16.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VBottomSheet<Content>: View
    where Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VBottomSheetUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    @State private var headerLabel: VBottomSheetHeaderLabel<AnyView> = VBottomSheetHeaderLabelPreferenceKey.defaultValue
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || uiModel.misc.dismissType.hasButton }
    private var hasGrabber: Bool {
        uiModel.layout.grabberSize.height > 0 &&
        (uiModel.misc.dismissType.contains(.pullDown) || uiModel.layout.sizes._current.size.heights.isResizable)
    }
    private var hasDivider: Bool { hasHeader && uiModel.layout.dividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var headerDividerHeight: CGFloat = 0
    @State private var offset: CGFloat
    @State private var offsetBeforeDrag: CGFloat? // Used for adding to translation
    @State private var currentDragValue: DragGesture.Value? // Used for storing "last" value for writing in `previousDragValue`. Equals to `dragValue` in methods.
    @State private var previousDragValue: DragGesture.Value? // Used for calculating velocity

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
        
        _offset = State(initialValue: uiModel.layout.sizes._current.size.heights.idealOffset)
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            bottomSheet
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
            .onChange(of: interfaceOrientationChangeObserver.orientation, perform: { _ in resetHeightFromOrientationChange() })
            .onPreferenceChange(VBottomSheetHeaderLabelPreferenceKey.self, perform: {
                headerLabel = $0
            })
    }
    
    private var dimmingView: some View {
        uiModel.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if uiModel.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }
    
    private var bottomSheet: some View {
        ZStack(content: {
            VSheet(uiModel: uiModel.sheetSubUIModel)
                .if(!uiModel.misc.contentIsDraggable, transform: {
                    $0
                        .frame(height: uiModel.layout.sizes._current.size.heights.max)
                        .offset(y: isInternallyPresented ? offset : uiModel.layout.sizes._current.size.heights.hiddenOffset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                })
                .shadow(
                    color: uiModel.colors.shadow,
                    radius: uiModel.colors.shadowRadius,
                    offset: uiModel.colors.shadowOffset
                )
                    
            VStack(spacing: 0, content: {
                VStack(spacing: 0, content: {
                    grabber
                    header
                    divider
                })
                    .onSizeChange(perform: { headerDividerHeight = $0.height })
                    .safeAreaMarginInsets(edges: uiModel.layout.headerSafeAreaEdges)

                contentView
            })
                .frame(maxHeight: .infinity, alignment: .top)
                .cornerRadius(uiModel.layout.cornerRadius, corners: .topCorners) // NOTE: Fixes issue of content-clipping, as it's not in `VSheet`
                .if(!uiModel.misc.contentIsDraggable, transform: {
                    $0
                        .frame(height: uiModel.layout.sizes._current.size.heights.max)
                        .offset(y: isInternallyPresented ? offset : uiModel.layout.sizes._current.size.heights.hiddenOffset)
                })
        })
            .frame(width: uiModel.layout.sizes._current.size.width)
            .if(uiModel.misc.contentIsDraggable, transform: {
                $0
                    .frame(height: uiModel.layout.sizes._current.size.heights.max)
                    .offset(y: isInternallyPresented ? offset : uiModel.layout.sizes._current.size.heights.hiddenOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged(dragChanged)
                            .onEnded(dragEnded)
                    )
            })
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeyboardSafeAreaEdges)
    }

    @ViewBuilder private var grabber: some View {
        if hasGrabber {
            RoundedRectangle(cornerRadius: uiModel.layout.grabberCornerRadius)
                .frame(size: uiModel.layout.grabberSize)
                .padding(uiModel.layout.grabberMargins)
                .foregroundColor(uiModel.colors.grabber)
        }
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(alignment: uiModel.layout.headerAlignment, spacing: uiModel.layout.labelCloseButtonSpacing, content: {
                Group(content: {
                    if uiModel.misc.dismissType.contains(.leadingButton) {
                        closeButton
                    } else if uiModel.misc.dismissType.contains(.trailingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group(content: {
                    switch headerLabel {
                    case .empty:
                        EmptyView()
                        
                    case .title(let title):
                        VText(
                            color: uiModel.colors.headerTitle,
                            font: uiModel.fonts.header,
                            text: title
                        )
                        
                    case .label(let label):
                        label()
                    }
                })
                    .layoutPriority(1)

                Group(content: {
                    if uiModel.misc.dismissType.contains(.trailingButton) {
                        closeButton
                    } else if uiModel.misc.dismissType.contains(.leadingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
                .padding(uiModel.layout.headerMargins)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasDivider {
            Rectangle()
                .frame(height: uiModel.layout.dividerHeight)
                .padding(uiModel.layout.dividerMargins)
                .foregroundColor(uiModel.colors.divider)
        }
    }

    private var contentView: some View {
        ZStack(content: {
            if !uiModel.misc.contentIsDraggable {
                Color.clear
                    .contentShape(Rectangle())
            }
            
            content()
                .padding(uiModel.layout.contentMargins)
        })
            .safeAreaMarginInsets(edges: uiModel.layout.contentSafeAreaEdges)
            .frame(maxWidth: .infinity)
            .if(
                uiModel.layout.autoresizesContent && uiModel.layout.sizes._current.size.heights.isResizable,
                ifTransform: { $0.frame(height: MultiplatformConstants.screenSize.height - offset - headerDividerHeight) },
                elseTransform: { $0.frame(maxHeight: .infinity) }
            )
    }

    private var closeButton: some View {
        VRoundedButton(
            uiModel: uiModel.closeButtonSubUIModel,
            action: animateOut,
            icon: ImageBook.xMark
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: uiModel.layout.closeButtonSubUIModel.size.width)
    }

    // MARK: Animation
    private func animateIn() {
        withBasicAnimation(
            uiModel.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.animations.pullDownDismiss,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.animations.disappear,
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
            offset = {
                switch newOffset {
                case ...uiModel.layout.sizes._current.size.heights.maxOffset:
                    return uiModel.layout.sizes._current.size.heights.maxOffset
                    
                case uiModel.layout.sizes._current.size.heights.minOffset...:
                    if uiModel.misc.dismissType.contains(.pullDown) {
                        return newOffset
                    } else {
                        return uiModel.layout.sizes._current.size.heights.minOffset
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
            abs(uiModel.layout.velocityToSnapToNextHeight)
        
        switch velocityExceedsNextAreaSnapThreshold {
        case false:
            guard let offsetBeforeDrag else { return }
            
            animateOffsetOrPullDismissFromSnapAction(.dragEndedSnapAction(
                heights: uiModel.layout.sizes._current.size.heights,
                canPullDownToDismiss: uiModel.misc.dismissType.contains(.pullDown),
                pullDownDismissDistance: uiModel.layout.pullDownDismissDistance,
                offset: offset,
                offsetBeforeDrag: offsetBeforeDrag,
                translation: dragValue.translation.height
            ))
            
        case true:
            animateOffsetOrPullDismissFromSnapAction(.dragEndedHighVelocitySnapAction(
                heights: uiModel.layout.sizes._current.size.heights,
                offset: offset,
                velocity: dragValue.velocity(inRelationTo: previousDragValue).height
            ))
        }
    }
    
    private func animateOffsetOrPullDismissFromSnapAction(_ snapAction: VBottomSheetSnapAction) {
        switch snapAction {
        case .dismiss: animateOutFromDrag()
        case .snap(let newOffset): withAnimation(uiModel.animations.heightSnap, { offset = newOffset })
        }
    }
    
    // MARK: Orientation
    private func resetHeightFromOrientationChange() {
        offset = uiModel.layout.sizes._current.size.heights.idealOffset
    }
    
    // MARK: Assertion
    private static func assertUIModel(_ uiModel: VBottomSheetUIModel) {
        guard uiModel.layout.sizes._current.size.heights.min <= uiModel.layout.sizes._current.size.heights.ideal else {
            VCoreFatalError("`VBottomSheet`'s `min` height must be less than or equal to `ideal` height", module: "VComponents")
        }
        
        guard uiModel.layout.sizes._current.size.heights.ideal <= uiModel.layout.sizes._current.size.heights.max else {
            VCoreFatalError("`VBottomSheet`'s `ideal` height must be less than or equal to `max` height", module: "VComponents")
        }
    }
}

// MARK: - Preview
@available(iOS 15.0, *)
@available(macOS 12.0, *)@available(macOS, unavailable)
@available(tvOS 15.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
struct VBottomSheet_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            InsettedContentPreview().previewDisplayName("Insetted Content")
            ScrollableContentPreview().previewDisplayName("Scrollable Content")
            OnlyGrabberPreview().previewDisplayName("Only Grabber")
            FullSizedContentPreview().previewDisplayName("Full-Sized Content")
        })
            .previewInterfaceOrientation(interfaceOrientation)
            .environment(\.layoutDirection, languageDirection)
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
                VBottomSheet(
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .init()
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: content
                )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VBottomSheet(
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .insettedContent
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: content
                )
            })
        }
    }
    
    private struct ScrollableContentPreview: View {
        var body: some View {
#if os(iOS)
            PreviewContainer(content: {
                VBottomSheet(
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .scrollableContent
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: {
                        List(content: {
                            ForEach(0..<20, content: { num in
                                VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                                    Text(String(num))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                })
                            })
                        })
                            .vListStyle()
                            .vBottomSheetHeaderTitle(headerTitle)
                    }
                )
            })  
#endif
        }
    }
    
    private struct FullSizedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VBottomSheet(
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .fullSizedContent
                        uiModel.misc.contentIsDraggable = true
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: { ColorBook.accentBlue }
                )
            })
        }
    }
    
    private struct OnlyGrabberPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VBottomSheet(
                    uiModel: {
                        var uiModel: VBottomSheetUIModel = .onlyGrabber
                        uiModel.misc.contentIsDraggable = true
                        uiModel.animations.appear = nil
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    content: { ColorBook.accentBlue }
                )
            })
        }
    }
}
