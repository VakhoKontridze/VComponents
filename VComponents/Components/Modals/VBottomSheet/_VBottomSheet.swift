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
    
    @Binding private var isPresented: Bool
    
    private let content: () -> Content
    
    private let appearAction: (() -> Void)?
    private let disappearAction: (() -> Void)?

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        BottomSheet: VBottomSheet<Content>
    ) {
        self.init(
            model: BottomSheet.model,
            isPresented: isPresented,
            content: BottomSheet.content,
            onAppear: BottomSheet.appearAction,
            onDisappear: BottomSheet.disappearAction
        )
    }
    
    private init(
        model: VBottomSheetModel,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)?,
        onDisappear disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isPresented = isPresented
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Body
extension _VBottomSheet {
    var body: some View {
        ZStack(content: {
            VSheet(model: model.sheetModel)
                .edgesIgnoringSafeArea(.vertical)

            content()
                .padding(.leading, model.layout.contentMargin.leading)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.bottom, model.layout.contentMargin.bottom)
                .padding(.bottom, model.layout.hasSafeAreaMargin ? UIKitPresenterCommon.safeAreaHeight : 0)
        })
            .frame(height: model.layout.heightType.height + UIKitPresenterCommon.safeAreaHeight + 1)   // Breaks without this
            .onAppear(perform: appearAction)
            .onDisappear(perform: disappearAction)
    }
}

// MARK:- Actions
private extension _VBottomSheet {
    func dismiss() {
        withAnimation { isPresented = false }
    }
}

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
