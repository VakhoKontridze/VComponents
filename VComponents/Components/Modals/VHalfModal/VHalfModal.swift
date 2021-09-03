//
//  VHalfModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- V Half Modal
/// Modal component that draws a background, hosts pull-up content on the bottom of the screen, and is present when condition is true
///
/// Model and header can be passed as parameters
///
/// If invalid height parameter are passed during init, layout would invalidate itself, and refuse to draw
///
/// `vHalfModal` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen
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
///         .vHalfModal(isPresented: $isPresented, halfModal: {
///             VHalfModal(
///                 headerTitle: "Lorem ipsum dolor sit amet",
///                 content: { ColorBook.accent }
///             )
///         })
/// }
/// ```
///
/// VNavigationView can also be passes as contant, to create a modal stack of navigatable views.
///
/// Here, it's important that header content is not passed. Header content should be created view VBaseView title.
///
/// Also, leading and trailing buttons shouldn't be used as dismiss types, as it's better to pass `navigationViewCloseButton` to model.
///
/// If you decide to change spacings in the model, consider checking out static properties—`navBarCloseButtonMarginTop`, `navBarCloseButtonMarginTrailing`, and `navBarTrailingItemMarginTrailing`—in `VHalfModalModel.Layout`.
///
/// ```
/// var model: VHalfModalModel {
///     var model: VHalfModalModel = .init()
///
///     model.layout.contentMargins.leading = VBaseViewModel.Layout().navBarMarginHorizontal
///     model.layout.contentMargins.trailing = VBaseViewModel.Layout().navBarMarginHorizontal
///
///     model.misc.dismissType.remove(.leadingButton)
///     model.misc.dismissType.remove(.trailingButton)
///     model.misc.dismissType.insert(.navigationViewCloseButton)
///
///     return model
/// }
///
/// var navigationViewModel: VNavigationViewModel {
///     var model: VNavigationViewModel = .init()
///     model.colors.background = ColorBook.layer
///     return model
/// }
///
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///         .vHalfModal(isPresented: $isPresented, halfModal: {
///             VHalfModal(model: model, content: { root })
///         })
/// }
///
/// var root: some View {
///     VNavigationView(model: navigationViewModel, content: {
///         VBaseView(title: "Home", content: {
///             VNavigationLink(
///                 preset: .secondary(),
///                 destination: destination,
///                 title: "Navigate to Details"
///             )
///                 .padding(.bottom, 200)
///         })
///             .animation(nil) // Disables root animation
///     })
/// }
///
/// var destination: some View {
///     VBaseView(title: "Details", content: {
///         ColorBook.accent
///     })
/// }
/// ```
///
public struct VHalfModal<Content, HeaderContent>
    where
        Content: View,
        HeaderContent: View
{
    // MARK: Properties
    fileprivate let model: VHalfModalModel
    
    fileprivate let headerContent: (() -> HeaderContent)?
    fileprivate let content: () -> Content
    
    // MARK: Initializers: Header
    /// Initializes component with header and content
    public init(
        model: VHalfModalModel = .init(),
        @ViewBuilder headerContent: @escaping () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.headerContent = headerContent
        self.content = content
    }
    
    /// Initializes component with header title and content
    public init(
        model: VHalfModalModel = .init(),
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
                    color: model.colors.headerText,
                    title: headerTitle
                )
            },
            content: content
        )
    }
    
    // MARK: Initializers: _
    /// Initializes component with content
    public init(
        model: VHalfModalModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderContent == Never
    {
        self.model = model
        self.headerContent = nil
        self.content = content
    }
}

// MARK:- Extension
extension View {
    /// Presents `VHalfModal`
    public func vHalfModal<Content, HeaderContent>(
        isPresented: Binding<Bool>,
        halfModal: @escaping () -> VHalfModal<Content, HeaderContent>
    ) -> some View
        where
            Content: View,
            HeaderContent: View
    {
        let halfModal = halfModal()
        
        return self
            .overlay(Group(content: {
                if isPresented.wrappedValue {
                    WindowOverlayView(
                        isPresented: isPresented,
                        content:
                            _VHalfModal(
                                model: halfModal.model,
                                isPresented: isPresented,
                                headerContent: halfModal.headerContent,
                                content: halfModal.content
                            )
                                .environment(\.vHalfModalNavigationViewCloseButton, halfModal.model.misc.dismissType.contains(.navigationViewCloseButton))
                    )
                }
            }))
    }
}
