//
//  _VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- _ V Bottom Bar
struct _VBottomSheet<Content>: View where Content: View {
    // MARK: Properties
    private let model: VBottomSheetModel
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let content: () -> Content
    
    private let appearAction: (() -> Void)?
    private let disappearAction: (() -> Void)?
    
    @ObservedObject private var abc: ABC
    

    // MARK: Initializers
    init(
        model: VBottomSheetModel,
        state: ABC,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)?,
        onDisappear disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isHCPresented = isPresented
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
        
        self.abc = state
    }
}

// MARK:- Body
extension _VBottomSheet {
    var body: some View {
        ZStack(alignment: .bottom, content: {
            blinding
            contentView
        })
            .onAppear(perform: animateIn)
    }
    
    private var blinding: some View {
        model.colors.blinding
            .edgesIgnoringSafeArea(.all)
            .onTapGesture(perform: animateOut)
    }
    
    private var contentView: some View {
        ZStack(content: {
            VSheet(model: model.sheetModel)
                .edgesIgnoringSafeArea(.vertical)

            content()
                .padding(.leading, model.layout.contentMargin.leading)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.bottom, model.layout.contentMargin.bottom)
        })
            .edgesIgnoringSafeArea(model.layout.hasSafeAreaMargin ? [] : .bottom)
            .frame(height: abc.current)
            .offset(y: isViewPresented ? 0 : abc.current + UIView.bottomSafeAreaHeight)
            .onAppear(perform: appearAction)
            .onDisappear(perform: disappearAction)
    }
}

// MARK:- Animation
private extension _VBottomSheet {
    func animateIn() {
        withAnimation(model.animation.swiftUIAnimation, { isViewPresented = true })
    }
    
    func animateOut() {
        withAnimation(model.animation.swiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + model.animation.duration, execute: { isHCPresented = false })
    }
}







//                .gesture(
//                    DragGesture(minimumDistance: 0)
//                        .onChanged(dragChanged)
//                )
//            .onAppear(perform: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + model.animations.duration, execute: {
//                    isPresented = false
//                })
//            })
//private enum DragDirection {
//    case down
//    case up
//
//    init(translation: CGFloat) {
//        self = translation > 0 ? .down : .up
//    }
//}
//
//private let distanceToDismiss: CGFloat = 150
//
//// MARK:- Drag
//private extension _VBottomSheet {
//    func dragChanged(_ draggedValue: DragGesture.Value) {
//        let location: CGFloat = draggedValue.location.y
//        let translation: CGFloat = draggedValue.translation.height
//        let direction: DragDirection = .init(translation: translation)
//
////        height =
////        print(height, translation)
//        abc.current = model.layout.heightClass.height + UIKitPresenterCommon.safeAreaHeight - translation
//
//        if direction == .down, /*model.layout.closeButton.contains(.pullDown),FIXME*/ abs(translation) >= distanceToDismiss {
//            withAnimation(model.animations.curve.swiftUI(duration: model.animations.duration), {
//                isHCPresented = false
//            })
//        }
//     }
//}

// MARK:- Preview
struct VBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .vBottomSheet(isPresented: .constant(true), bottomSheet: {
                VBottomSheet(content: {
                    Color.red
                })
            })
    }
}



public struct VAnimation {
    public var curve: VAnimationCurve
    public var duration: TimeInterval
    
    var swiftUIAnimation: Animation {
        switch curve {
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        }
    }
}

extension VAnimation {
    public enum VAnimationCurve {
        case linear, easeIn, easeOut, easeInOut
    }
}
