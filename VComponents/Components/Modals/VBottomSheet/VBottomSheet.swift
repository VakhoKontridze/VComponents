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
    
    @ObservedObject fileprivate var state: ABC = .init()
    
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
        
        self.state.update(specified: model.layout.heightClass.height)
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
        let bottomSheet = bottomSheet()
        
        return ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                UIKitRepresentable(isPresented: isPresented, content:
                    _VBottomSheet(
                        model: bottomSheet.model,
                        state: bottomSheet.state,
                        isPresented: isPresented,
                        content: bottomSheet.content,
                        onAppear: bottomSheet.appearAction,
                        onDisappear: bottomSheet.disappearAction
                    )
                )
            }
        })
    }
}

final class ABC: ObservableObject {
    @Published var specified: CGFloat = .zero
    @Published var current: CGFloat = .zero
    
    func update(specified: CGFloat) {
        if self.specified == .zero { self.specified = specified }
        if self.current == .zero { self.current = specified }
        
        if self.specified != specified {
            self.specified = specified
            self.current = specified
        }
    }
}
