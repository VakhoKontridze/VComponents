//
//  _VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - _ V Bottom Sheet
struct _VBottomSheet<HeaderLabel, Content>: View
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let model: VBottomSheetModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let headerLabel: VBottomSheetHeaderLabel<HeaderLabel>
    private let content: () -> Content
    
    private var hasHeader: Bool { headerLabel.hasLabel || model.misc.dismissType.hasButton }
    private var hasGrabber: Bool { model.misc.dismissType.contains(.pullDown) || model.layout.sizes.current.size.heights.isResizable }
    private var hasHeaderDivider: Bool { hasHeader && model.layout.headerDividerHeight > 0 }
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var grabberHeaderDividerHeight: CGFloat = 0
    @State private var offset: CGFloat
    @State private var offsetBeforeDrag: CGFloat? // Used for adding to translation
    @State private var currentDragValue: DragGesture.Value? // Used for storing "last" value for writing in `previousDragValue`. Equals to `dragValue` in methods.
    @State private var previousDragValue: DragGesture.Value? // Used for calculating velocity

    // MARK: Initializers
    init(
        model: VBottomSheetModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        headerLabel: VBottomSheetHeaderLabel<HeaderLabel>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.headerLabel = headerLabel
        self.content = content
        
        _offset = .init(initialValue: model.layout.sizes.current.size.heights.max - model.layout.sizes.current.size.heights.ideal)
    }

    // MARK: Body
    var body: some View {
        ZStack(alignment: .bottom, content: {
            blinding
            bottomSheet
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: model.layout.ignoredKeybordSafeAreaEdges)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 { animateOutFromExternalDismiss() } }
            )
            .onChange(of: interfaceOrientationChangeObserver.orientation, perform: { _ in resetHeightFromOrientationChange() })
    }
    
    private var blinding: some View {
        model.colors.blinding
            .onTapGesture(perform: {
                if model.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }
    
    @ViewBuilder private var bottomSheet: some View {
        if model.layout.sizes.current.size.heights.isLayoutValid {
            ZStack(content: {
                VSheet(model: model.sheetModel)
                    .shadow(
                        color: model.colors.shadow,
                        radius: model.colors.shadowRadius,
                        x: model.colors.shadowOffset.width,
                        y: model.colors.shadowOffset.height
                    )
                    .if(!model.misc.isContentDraggable, transform: { // NOTE: Frame must come before DragGesture
                        $0
                            .frame(height: model.layout.sizes.current.size.heights.max)
                            .offset(y: isInternallyPresented ? offset : model.layout.sizes.current.size.heights.max)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged(dragChanged)
                                    .onEnded(dragEnded)
                            )
                    })

                VStack(spacing: 0, content: {
                    VStack(spacing: 0, content: {
                        grabber
                        header
                        divider
                    })
                        .readSize(onChange: { grabberHeaderDividerHeight = $0.height })
                    
                    contentView
                })
                    .frame(maxHeight: .infinity, alignment: .top)
                    .if(!model.misc.isContentDraggable, transform: { // NOTE: Frame must come before DragGesture
                        $0
                            .frame(height: model.layout.sizes.current.size.heights.max)
                            .offset(y: isInternallyPresented ? offset : model.layout.sizes.current.size.heights.max)
                    })
            })
                .frame(width: model.layout.sizes.current.size.width)
                .if(model.misc.isContentDraggable, transform: {  // NOTE: Frame must come before DragGesture
                    $0
                        .frame(height: model.layout.sizes.current.size.heights.max)
                        .offset(y: isInternallyPresented ? offset : model.layout.sizes.current.size.heights.max)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged(dragChanged)
                                .onEnded(dragEnded)
                        )
                })
        }
    }

    @ViewBuilder private var grabber: some View {
        if hasGrabber {
            RoundedRectangle(cornerRadius: model.layout.grabberCornerRadius)
                .frame(size: model.layout.grabberSize)
                .padding(model.layout.grabberMargins)
                .foregroundColor(model.colors.grabber)
        }
    }

    @ViewBuilder private var header: some View {
        if hasHeader {
            HStack(alignment: model.layout.headerAlignment, spacing: model.layout.labelCloseButtonSpacing, content: {
                Group(content: {
                    if model.misc.dismissType.contains(.leadingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.trailingButton) {
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
                            color: model.colors.headerTitle,
                            font: model.fonts.header,
                            title: title
                        )
                        
                    case .custom(let label):
                        label()
                    }
                })
                    .layoutPriority(1)

                Group(content: {
                    if model.misc.dismissType.contains(.trailingButton) {
                        closeButton
                    } else if model.misc.dismissType.contains(.leadingButton) {
                        closeButtonCompensator
                    }
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
                .padding(model.layout.headerMargins)
        }
    }

    @ViewBuilder private var divider: some View {
        if hasHeaderDivider {
            Rectangle()
                .frame(height: model.layout.headerDividerHeight)
                .padding(model.layout.headerDividerMargins)
                .foregroundColor(model.colors.headerDivider)
        }
    }

    private var contentView: some View {
        ZStack(content: {
            if !model.misc.isContentDraggable {
                Color.clear
                    .contentShape(Rectangle())
            }
            
            content()
                .padding(model.layout.contentMargins)
        })
            .safeAreaMarginInsets(edges: model.layout.contentSafeAreaEdges)
            .frame(maxWidth: .infinity)
            .if(
                model.layout.autoresizesContent,
                ifTransform: { $0.frame(height: model.layout.sizes.current.size.heights.max - offset - grabberHeaderDividerHeight) },
                elseTransform: { $0.frame(maxHeight: .infinity) }
            )
    }

    private var closeButton: some View {
        VSquareButton.close(
            model: model.closeButtonSubModel,
            action: animateOut
        )
    }
    
    private var closeButtonCompensator: some View {
        Spacer()
            .frame(width: model.layout.closeButtonDimension)
    }

    // MARK: Animation
    private func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isInternallyPresented = true })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.appear?.duration ?? 0),
            execute: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isInternallyPresented = false })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.disappear?.duration ?? 0),
            execute: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromDrag() {
        withAnimation(model.animations.pullDownDisappear?.asSwiftUIAnimation, { isInternallyPresented = false })
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.pullDownDisappear?.duration ?? 0),
            execute: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isInternallyPresented = false })

        DispatchQueue.main.asyncAfter(
            deadline: .now() + (model.animations.disappear?.duration ?? 0),
            execute: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        guard let offsetBeforeDrag = offsetBeforeDrag else { fatalError() }
        
        previousDragValue = currentDragValue
        currentDragValue = dragValue
        
        let newOffset: CGFloat = offsetBeforeDrag + dragValue.translation.height
        let maxAllowedOffset: CGFloat = model.layout.sizes.current.size.heights.max - model.layout.sizes.current.size.heights.min
        let minAllowedOffset: CGFloat = model.layout.sizes.current.size.heights.max - model.layout.sizes.current.size.heights.max
        
        withAnimation(.linear(duration: 0.1), { // Gets rid of stuttering
            offset = {
                switch newOffset {
                case ...minAllowedOffset:
                    return minAllowedOffset
                    
                case maxAllowedOffset...:
                    switch model.misc.dismissType.contains(.pullDown) {
                    case false: return maxAllowedOffset
                    case true: return newOffset
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
            abs(model.layout.velocityToSnapToNextHeight)
        
        switch velocityExceedsNextAreaSnapThreshold {
        case false:
            guard let offsetBeforeDrag = offsetBeforeDrag else { return }
            
            animateOffsetOrPullDismissFromSnapAction(.dragEndedSnapAction(
                heights: model.layout.sizes.current.size.heights,
                canPullDownToDismiss: model.misc.dismissType.contains(.pullDown),
                pullDownDismissDistance: model.layout.pullDownDismissDistance,
                offset: offset,
                offsetBeforeDrag: offsetBeforeDrag,
                translation: dragValue.translation.height
            ))
            
        case true:
            animateOffsetOrPullDismissFromSnapAction(.dragEndedHighVelocitySnapAction(
                heights: model.layout.sizes.current.size.heights,
                offset: offset,
                velocity: dragValue.velocity(inRelationTo: previousDragValue).height
            ))
        }
    }
    
    private func animateOffsetOrPullDismissFromSnapAction(_ snapAction: VBottomSheetSnapAction) {
        switch snapAction {
        case .dismiss: animateOutFromDrag()
        case .snap(let newOffset): withAnimation(model.animations.heightSnap, { offset = newOffset })
        }
    }
    
    // MARK: Orientation
    private func resetHeightFromOrientationChange() {
        offset = model.layout.sizes.current.size.heights.max - model.layout.sizes.current.size.heights.ideal
    }
}

// MARK: - Preview
struct VBottomSheet_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vBottomSheet(isPresented: $isPresented, bottomSheet: {
                VBottomSheet(
                    model: {
                        var model: VBottomSheetModel = .init()
                        model.layout.autoresizesContent = true
                        model.layout.contentSafeAreaEdges.insert(.bottom)
                        return model
                    }(),
                    headerTitle: "Lorem ipsum dolor sit amet",
                    content: {
                        VList(data: 0..<20, rowContent: { num in
                            Text(String(num))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    }
                )
            })
    }
}
