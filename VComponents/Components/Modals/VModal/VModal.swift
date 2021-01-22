//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Modal
/// Modal component that draws a background, hosts content, and is present when condition is true
///
/// Model, header, and onAppear and onDisappear callbacks can be passed as parameters
///
/// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///         .vModal(isPresented: $isPresented, modal: {
///             VModal(
///                 header: { VModalDefaultHeader(title: "Lorem ipsum dolor sit amet") },
///                 content: { ColorBook.accent }
///             )
///         })
/// }
/// ```
///
public struct VModal<Content, HeaderContent>
    where
        Content: View,
        HeaderContent: View
{
    // MARK: Properties
    public var model: VModalModel
    
    public var headerContent: (() -> HeaderContent)?
    public var content: () -> Content
    
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    public init(
        model: VModalModel = .init(),
        @ViewBuilder header headerContent: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.headerContent = headerContent
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
    
    public init(
        model: VModalModel = .init(),
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    )
        where HeaderContent == Never
    {
        self.model = model
        self.headerContent = nil
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
extension View {
    /// Presents modal
    public func vModal<Content, headerContent>(
        isPresented: Binding<Bool>,
        modal: @escaping () -> VModal<Content, headerContent>
    ) -> some View
        where
            Content: View,
            headerContent: View
    {
        let modal = modal()
        
        return ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                UIKitRepresentable(
                    isPresented: isPresented,
                    content:
                        _VModal(
                            model: modal.model,
                            isPresented: isPresented,
                            headerContent: modal.headerContent,
                            content: modal.content,
                            appearAction: modal.appearAction,
                            disappearAction: modal.disappearAction
                        )
                )
            }
        })
    }
}
