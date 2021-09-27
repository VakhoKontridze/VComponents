//
//  VBaseView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Base View
/// Core component that is used throughout the framework as `SwiftUI`'s equivalent of `UIViewController`
///
/// Model, and leading and trailing items can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// var trailingItem: some View {
///     VPlainButton(
///         action: { print("Pressed") },
///         title: "Lorem"
///     )
/// }
///
/// var body: some View {
///     VNavigationView(content: {
///         VBaseView(
///             title: "Lorem ipsum dolor sit amet",
///             trailingItem: trailingItem,
///             content: {
///                 ZStack(alignment: .top, content: {
///                     ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                     VSheet()
///                 })
///             }
///         )
///     })
/// }
///
/// ```
///
public struct VBaseView<NavBarLeadingItemContent, NavBarTitleContent, NavBarTrailingItemContent, Content>: View
    where
        NavBarLeadingItemContent: View,
        NavBarTitleContent: View,
        NavBarTrailingItemContent: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.vNavigationViewBackButtonHidden) private var vNavigationViewBackButtonHidden: Bool
    
    private let model: VBaseViewModel
    
    private let navBarLeadingItemContent: (() -> NavBarLeadingItemContent)?
    private let navBarTitleContent: () -> NavBarTitleContent
    private let navBarTrailingItemContent: (() -> NavBarTrailingItemContent)?
    
    private let content: () -> Content
    
    // MARK: Initializers - Leading and Trailing
    /// Initializes component with title content, leading and trailing items, and content
    public init(
        model: VBaseViewModel = .init(),
        @ViewBuilder titleContent navBarTitleContent: @escaping () -> NavBarTitleContent,
        @ViewBuilder leadingItem navBarLeadingItemContent: @escaping () -> NavBarLeadingItemContent,
        @ViewBuilder trailingItem navBarTrailingItemContent: @escaping () -> NavBarTrailingItemContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navBarTitleContent = navBarTitleContent
        self.navBarLeadingItemContent = navBarLeadingItemContent
        self.navBarTrailingItemContent = navBarTrailingItemContent
        self.content = content
    }
    
    /// Initializes component with title, leading and trailing items, and content
    public init(
        model: VBaseViewModel = .init(),
        title navBarTitleContent: String,
        @ViewBuilder leadingItem navBarLeadingItemContent: @escaping () -> NavBarLeadingItemContent,
        @ViewBuilder trailingItem navBarTrailingItemContent: @escaping () -> NavBarTrailingItemContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where NavBarTitleContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            titleContent: {
                VBaseHeaderFooter(
                    frameType: .fixed,
                    font: model.fonts.title,
                    color: model.colors.titleText,
                    title: navBarTitleContent
                )
            },
            leadingItem: navBarLeadingItemContent,
            trailingItem: navBarTrailingItemContent,
            content: content
        )
    }

    // MARK: Initializers - Leading
    /// Initializes component with title content, leading item, and content
    public init(
        model: VBaseViewModel = .init(),
        @ViewBuilder titleContent navBarTitleContent: @escaping () -> NavBarTitleContent,
        @ViewBuilder leadingItem navBarLeadingItemContent: @escaping () -> NavBarLeadingItemContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where NavBarTrailingItemContent == Never
    {
        self.model = model
        self.navBarTitleContent = navBarTitleContent
        self.navBarLeadingItemContent = navBarLeadingItemContent
        self.navBarTrailingItemContent = nil
        self.content = content
    }
    
    /// Initializes component with title, leading item, and content
    public init(
        model: VBaseViewModel = .init(),
        title navBarTitleContent: String,
        @ViewBuilder leadingItem navBarLeadingItemContent: @escaping () -> NavBarLeadingItemContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            NavBarTitleContent == VBaseHeaderFooter,
            NavBarTrailingItemContent == Never
    {
        self.init(
            model: model,
            titleContent: {
                VBaseHeaderFooter(
                    frameType: .fixed,
                    font: model.fonts.title,
                    color: model.colors.titleText,
                    title: navBarTitleContent
                )
            },
            leadingItem: navBarLeadingItemContent,
            content: content
        )
    }
    // MARK: Initializers - Trailing
    /// Initializes component with title content, trailing item, and content
    public init(
        model: VBaseViewModel = .init(),
        @ViewBuilder titleContent navBarTitleContent: @escaping () -> NavBarTitleContent,
        @ViewBuilder trailingItem navBarTrailingItemContent: @escaping () -> NavBarTrailingItemContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where NavBarLeadingItemContent == Never
    {
        self.model = model
        self.navBarTitleContent = navBarTitleContent
        self.navBarLeadingItemContent = nil
        self.navBarTrailingItemContent = navBarTrailingItemContent
        self.content = content
    }
    
    /// Initializes component with title, trailing item, and content
    public init(
        model: VBaseViewModel = .init(),
        title navBarTitleContent: String,
        @ViewBuilder trailingItem navBarTrailingItemContent: @escaping () -> NavBarTrailingItemContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            NavBarLeadingItemContent == Never,
            NavBarTitleContent == VBaseHeaderFooter
    {
        self.init(
            model: model,
            titleContent: {
                VBaseHeaderFooter(
                    frameType: .fixed,
                    font: model.fonts.title,
                    color: model.colors.titleText,
                    title: navBarTitleContent
                )
            },
            trailingItem: navBarTrailingItemContent,
            content: content
        )
    }

    // MARK: Initializers - _
    /// Initializes component with title content and content
    public init(
        model: VBaseViewModel = .init(),
        @ViewBuilder titleContent navBarTitleContent: @escaping () -> NavBarTitleContent,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            NavBarLeadingItemContent == Never,
            NavBarTrailingItemContent == Never
    {
        self.model = model
        self.navBarTitleContent = navBarTitleContent
        self.navBarLeadingItemContent = nil
        self.navBarTrailingItemContent = nil
        self.content = content
    }
    
    /// Initializes component with title and content
    public init(
        model: VBaseViewModel = .init(),
        title navBarTitleContent: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            NavBarLeadingItemContent == Never,
            NavBarTitleContent == VBaseHeaderFooter,
            NavBarTrailingItemContent == Never
    {
        self.init(
            model: model,
            titleContent: {
                VBaseHeaderFooter(
                    frameType: .fixed,
                    font: model.fonts.title,
                    color: model.colors.titleText,
                    title: navBarTitleContent
                )
            },
            content: content
        )
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch model.layout.titlePosition {
        case .center:
            baseViewFrame
                .setUpBaseViewNavigationBarCenter(
                    model: model,
                    titleContent: navBarTitleContent,
                    leadingItemContent: navBarLeadingItemContent,
                    trailingItemContent: navBarTrailingItemContent,
                    showBackButton: !vNavigationViewBackButtonHidden,
                    onBack: back
                )
            
        case .leading:
            baseViewFrame
                .setUpBaseViewNavigationBarLeading(
                    model: model,
                    titleContent: navBarTitleContent,
                    leadingItemContent: navBarLeadingItemContent,
                    trailingItemContent: navBarTrailingItemContent,
                    showBackButton: !vNavigationViewBackButtonHidden,
                    onBack: back
                )
        }
    }
    
    private var baseViewFrame: some View {
        content()
            .navigationBarBackButtonHidden(true)
            .environment(\.vNavigationViewBackButtonHidden, true)
            .addNavigationBarSwipeGesture(completion: back)
    }

    // MARK: Back
    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct VBaseView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationView(content: {
            VBaseView(
                title: "Home",
                trailingItem: { Button("Search", action: {}) },
                content: {
                    ZStack(content: {
                        Color.pink.edgesIgnoringSafeArea(.bottom)
                        
                        VNavigationLink(destination: Destination(), content: { Text("Go to Details") })
                    }
                )
            })
        })
    }
    
    private struct Destination: View {
        var body: some View {
            VBaseView(title: "Details", content: {
                Color.blue.edgesIgnoringSafeArea(.bottom)
            })
        }
    }
}
