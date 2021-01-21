//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- V Bottom Sheet
public struct VBottomSheet<Content> where Content: View {
    // MARK: Properties
    public var model: VBottomSheetModel
    
    public var content: () -> Content
    
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    public init(
        model: VBottomSheetModel = .init(),
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
extension View {
    /// Presents bottom sheet
    public func vBottomSheet<Content>(
        isPresented: Binding<Bool>,
        bottomSheet: @escaping () -> VBottomSheet<Content>
    ) -> some View
        where Content: View
    {
        ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                VBottomSheetVCRepresentable(
                    isPresented: isPresented,
                    content: _VBottomSheet(isPresented: isPresented, BottomSheet: bottomSheet()),
                    blinding: bottomSheet().model.colors.blinding.edgesIgnoringSafeArea(.all),
                    contentHeight: bottomSheet().model.layout.heightType.height,
                    animationCurve: bottomSheet().model.animations.curve,
                    animationDuration: bottomSheet().model.animations.duration,
                    onBackTap: {
//                        if bottomSheet().model.layout.closeButton.contains(.backTap) {
                            withAnimation { isPresented.wrappedValue = false }
//                        }
                    }
                )
            }
        })
    }
}
