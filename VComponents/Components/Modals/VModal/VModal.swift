//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Modal
/// Modal component that draws a background and hosts content, and is present when condition is true
public struct VModal<Content, TitleContent>
    where
        Content: View,
        TitleContent: View
{
    // MARK: Properties
    public var model: VModalModel
    
    public var titleContent: (() -> TitleContent)?
    public var content: () -> Content
    
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    /// Initializes component with title and content
    /// 
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - titleContent: View that describes container
    ///   - content: Modal content
    ///   - appearAction: Callback for when component appears
    ///   - disappearAction: Callback for when component dissapears
    public init(
        model: VModalModel = .init(),
        @ViewBuilder title titleContent: @escaping () -> TitleContent,
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.titleContent = titleContent
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
    
    /// Initializes component with content
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - content: Modal content
    ///   - appearAction: Callback for when component appears
    ///   - disappearAction: Callback for when component dissapears
    public init(
        model: VModalModel = .init(),
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    )
        where TitleContent == Never
    {
        self.model = model
        self.titleContent = nil
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
public extension View {
    /// Presents modal
    /// - Parameters:
    ///   - isPresented: Binding to whether the modal is presented
    ///   - modal: Closure returning the modal to presenter
    /// - Returns: Presenter
    func vModal<Content, TitleContent>(
        isPresented: Binding<Bool>,
        modal: @escaping () -> VModal<Content, TitleContent>
    ) -> some View
        where
            Content: View,
            TitleContent: View
    {
        ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                VModalVCRepresentable(
                    isPresented: isPresented,
                    content: _VModal(isPresented: isPresented, modal: modal()),
                    blinding: modal().model.colors.blinding.edgesIgnoringSafeArea(.all),
                    onBackTap: {
                        if modal().model.layout.closeButtonPosition == .backTap {
                            withAnimation { isPresented.wrappedValue = false }
                        }
                    }
                )
            }
        })
    }
}
