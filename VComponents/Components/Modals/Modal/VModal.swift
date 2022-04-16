//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Modal
/// Modal component that draws a background, hosts content, and is present when condition is true.
///
/// Model and header can be passed as parameters.
///
/// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vModal(isPresented: $isPresented, modal: {
///                 VModal(
///                     headerTitle: "Lorem ipsum dolor sit amet",
///                     content: { ColorBook.accent }
///                 )
///             })
///     }
///
public struct VModal<Content, HeaderContent>
    where
        Content: View,
        HeaderContent: View
{
    // MARK: Properties
    fileprivate let model: VModalModel
    
    fileprivate let headerContent: (() -> HeaderContent)?
    fileprivate let content: () -> Content
    
    // MARK: Initializers - Header
    /// Initializes component with header and content.
    public init(
        model: VModalModel = .init(),
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.headerContent = headerContent
        self.content = content
    }
    
    /// Initializes component with header title and content.
    public init(
        model: VModalModel = .init(),
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            headerContent: {
                VBaseHeaderFooter(
                    frameType: .flexible(.leading),
                    font: model.fonts.header,
                    color: model.colors.headerTitle,
                    title: headerTitle
                )
            },
            content: content
        )
    }
    
    // MARK: Initializers - _
    /// Initializes component content.
    public init(
        model: VModalModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderContent == Never
    {
        self.model = model
        self.headerContent = nil
        self.content = content
    }
}

// MARK: - Extension
extension View {
    /// Presents `VModal`.
    public func vModal<Content, headerContent>(
        isPresented: Binding<Bool>,
        modal: @escaping () -> VModal<Content, headerContent>
    ) -> some View
        where
            Content: View,
            headerContent: View
    {
        let modal = modal()
        
        return self
            .overlay(Group(content: {
                if isPresented.wrappedValue {
                    WindowOverlayView(
                        isPresented: isPresented,
                        content:
                            _VModal(
                                model: modal.model,
                                isPresented: isPresented,
                                headerContent: modal.headerContent,
                                content: modal.content
                            )
                    )
                }
            }))
    }
}
