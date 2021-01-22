//
//  _VHalfModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- _ V Half Modal
struct _VHalfModal<Content, HeaderContent>: View
    where
        Content: View,
        HeaderContent: View
{
    // MARK: Properties
    private let model: VHalfModalModel
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let headerContent: (() -> HeaderContent)?
    private let content: () -> Content
    
    private let appearAction: (() -> Void)?
    private let disappearAction: (() -> Void)?
    
    @State private var offset: CGFloat?
    @State private var offsetBeforeDrag: CGFloat?
    
    private var headerExists: Bool { headerContent != nil || model.dismissType.hasButton }
    
    private let validLayout: Bool

    // MARK: Initializers
    init(
        model: VHalfModalModel,
        isPresented: Binding<Bool>,
        headerContent: (() -> HeaderContent)?,
        content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)?,
        onDisappear disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isHCPresented = isPresented
        self.headerContent = headerContent
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
        
        self.validLayout =
            model.layout.height.min <= model.layout.height.ideal &&
            model.layout.height.ideal <= model.layout.height.max
    }
}

// MARK:- Body
extension _VHalfModal {
    var body: some View {
        performStateResets()
        
        return ZStack(alignment: .bottom, content: {
            blinding
            modalView
        })
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity)
            .onAppear(perform: animateIn)
    }
    
    private var blinding: some View {
        model.colors.blinding
            .onTapGesture(perform: animateOut)
    }
    
    @ViewBuilder private var modalView: some View {
        if validLayout {
            ZStack(content: {
                VSheet(model: model.sheetModel)
                contentView
                navigationBarCloseButton
            })
                .frame(height: model.layout.height.max)
                .offset(y: isViewPresented ? (offset ?? .zero) : model.layout.height.max)
                .onAppear(perform: appearAction)
                .onDisappear(perform: disappearAction)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged(dragChanged)
                        .onEnded(dragEnded)
                )
        }
    }

    private var contentView: some View {
        VStack(spacing: model.layout.spacing, content: {
            headerView
            dividerView
            content()
        })
            .padding(.leading, model.layout.contentMargin.leading)
            .padding(.trailing, model.layout.contentMargin.trailing)
            .padding(.top, model.layout.contentMargin.top)
            .padding(.bottom, model.layout.contentMargin.bottom)
            .padding(.bottom, model.layout.hasSafeAreaMargin ? UIView.bottomSafeAreaHeight : 0)
    }

    @ViewBuilder private var headerView: some View {
        if headerExists {
            HStack(spacing: model.layout.headerSpacing, content: {
                if model.dismissType.contains(.leading) {
                    closeButton
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let headerContent = headerContent {
                    headerContent()
                        .layoutPriority(1)  // Overrides close button's maxWidth: .infinity. Also, header content is by default maxWidth and leading justified.
                }

                if model.dismissType.contains(.trailing) {
                    closeButton
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            })
        }
    }

    @ViewBuilder private var dividerView: some View {
        if headerExists && model.layout.hasDivider {
            Rectangle()
                .frame(height: model.layout.dividerHeight)
                .foregroundColor(model.colors.divider)
        }
    }

    private var closeButton: some View {
        VCloseButton(model: model.closeButtonSubModel, action: animateOut)
    }
    
    @ViewBuilder private var navigationBarCloseButton: some View {
        if model.dismissType.contains(.navigationViewCloseButton) {
            VCloseButton(model: model.closeButtonSubModel, action: animateOut)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.top, VHalfModalModel.Layout.navigationViewCloseButtonMarginTop)
        }
    }
}

// MARK:- Animation
private extension _VHalfModal {
    func animateIn() {
        resetOffsetIsNil()
        withAnimation(model.animations.appear?.swiftUIAnimation, { isViewPresented = true })
    }
    
    func animateOut() {
        withAnimation(model.animations.disappear?.swiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }
    
    func animateOutFromDrag() {
        withAnimation(VHalfModalModel.Animations.dragDisappear.swiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + VHalfModalModel.Animations.dragDisappear.duration, execute: { isHCPresented = false })
    }
}

// MARK:- State Resets
private extension _VHalfModal {
    func performStateResets() {
        DispatchQueue.main.async(execute: {
            resetOffsetIsNil()
        })
    }
    
    func resetOffsetIsNil() {
        if offset == nil { offset = model.layout.height.max - model.layout.height.ideal }
    }
}

// MARK:- Gestures
private extension _VHalfModal {
    func dragChanged(drag: DragGesture.Value) {
        if offsetBeforeDrag == nil { offsetBeforeDrag = offset }
        
        let rawOffset: CGFloat = offsetBeforeDrag! + drag.translation.height
        let maxAllowedOffset: CGFloat = model.layout.height.max - model.layout.height.min
        let minAllowedOffset: CGFloat = model.layout.height.max - model.layout.height.max
        
        offset = {
            switch rawOffset {
            case ...minAllowedOffset: return minAllowedOffset
            case maxAllowedOffset...: return model.dismissType.contains(.pullDown) ? rawOffset : minAllowedOffset
            default: return rawOffset
            }
        }()
    }
    
    func dragEnded(drag: DragGesture.Value) {
        defer { offsetBeforeDrag = nil }
        guard let offsetBeforeDrag = offsetBeforeDrag else { return }   // Content may cause gesture to skip onChange
        
        let shouldDismiss: Bool = {
            let rawOffset: CGFloat = offsetBeforeDrag + drag.translation.height
            let maxAllowedOffset: CGFloat = model.layout.height.max - model.layout.height.min
            
            guard model.dismissType.contains(.pullDown) else { return false }

            let isDraggedDown: Bool = drag.translation.height > 0
            guard isDraggedDown else { return false }

            guard rawOffset - maxAllowedOffset >= abs(model.layout.translationBelowMinHeightToDismiss) else { return false }

            return true
        }()
        
        switch shouldDismiss {
        case false:
            let newOffsetOpt: CGFloat? = {
                guard let offset = offset else { return nil }
                
                let minOffset: CGFloat = model.layout.height.max - model.layout.height.min
                let idealOffset: CGFloat = model.layout.height.max - model.layout.height.ideal
                let maxOffset: CGFloat = model.layout.height.max - model.layout.height.max
                
                switch Region(offset: offset, min: minOffset, ideal: idealOffset, max: maxOffset) {
                case .idealMax:
                    let idealDiff: CGFloat = abs(idealOffset - offset)
                    let maxDiff: CGFloat = abs(maxOffset - offset)
                    let newOffset: CGFloat = idealDiff < maxDiff ? idealOffset : maxOffset
                    return newOffset
                
                case .ideal:
                    return nil
                
                case .minIdeal:
                    let minDiff: CGFloat = abs(minOffset - offset)
                    let idealDiff: CGFloat = abs(idealOffset - offset)
                    let newOffset: CGFloat = minDiff < idealDiff ? minOffset : idealOffset
                    return newOffset
                }
            }()
            
            guard let newOffset = newOffsetOpt else { return }
            
            withAnimation(model.animations.heightSnap, { offset = newOffset })
        
        case true:
            animateOutFromDrag()
        }
    }
    
    enum Region {
        case idealMax, ideal, minIdeal
        
        init(offset: CGFloat, min: CGFloat, ideal: CGFloat, max: CGFloat) {
            // max means offset of max, not maximum allowed offset. Otherwise, the logic would seem nverted
            switch offset {
            case ideal: self = .ideal
            case (max..<ideal): self = .idealMax
            default: self = .minIdeal   // Min isn't used to allow registering area between dismiss point and min
            }
        }
    }
}

// MARK:- Preview
struct VHalfModal_Previews: PreviewProvider {
    static var previews: some View {
        _VHalfModal(
            model: .init(),
            isPresented: .constant(true),
            headerContent: { VHalfModalDefaultHeader(title: "Lorem ipsum dolor sit amet") },
            content: { ColorBook.accent },
            onAppear: nil,
            onDisappear: nil
        )
    }
}
