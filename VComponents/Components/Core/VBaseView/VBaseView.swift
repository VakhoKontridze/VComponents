//
//  VBaseView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base View
/// Core component that is used throughout the framework as SwiftUI's equivalent of UIViewController
///
/// Model, and leading and trailing items can be passed as parameters
///
/// # Usage Example #
/// ```
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
/// var trailingItem: some View {
///     VPlainButton(
///         action: { print("Pressed") },
///         title: "Lorem"
///     )
/// }
/// ```
///
public struct VBaseView<Content, NavigationBarLeadingItem, NavigationBarTrailingItem>: View
    where
        Content: View,
        NavigationBarLeadingItem: View,
        NavigationBarTrailingItem: View
{
    // MARK: Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.vNavigationViewBackButtonHidden) private var vNavigationViewBackButtonHidden: Bool
    
    private let model: VBaseViewModel
    
    private let navigationBarTitle: String
    private let navigationBarLeadingItem: (() -> NavigationBarLeadingItem)?
    private let navigationBarTrailingItem: (() -> NavigationBarTrailingItem)?
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder leadingItem navigationBarLeadingItem: @escaping () -> NavigationBarLeadingItem,
        @ViewBuilder trailingItem navigationBarTrailingItem: @escaping () -> NavigationBarTrailingItem,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = navigationBarLeadingItem
        self.navigationBarTrailingItem = navigationBarTrailingItem
        self.content = content
    }

    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder leadingItem navigationBarLeadingItem: @escaping () -> NavigationBarLeadingItem,
        @ViewBuilder content: @escaping () -> Content
    )
        where NavigationBarTrailingItem == Never
    {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = navigationBarLeadingItem
        self.navigationBarTrailingItem = nil
        self.content = content
    }

    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder trailingItem navigationBarTrailingItem: @escaping () -> NavigationBarTrailingItem,
        @ViewBuilder content: @escaping () -> Content
    )
        where NavigationBarLeadingItem == Never
    {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = nil
        self.navigationBarTrailingItem = navigationBarTrailingItem
        self.content = content
    }

    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where
            NavigationBarLeadingItem == Never,
            NavigationBarTrailingItem == Never
    {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = nil
        self.navigationBarTrailingItem = nil
        self.content = content
    }
}

// MARK:- Body
extension VBaseView {
    @ViewBuilder public var body: some View {
        switch model.layout.titlePosition {
        case .center:
            baseViewFrame
                .setUpBaseViewNavigationBarCenter(
                    model: model,
                    title: navigationBarTitle,
                    leadingItemContent: navigationBarLeadingItem,
                    trailingItemContent: navigationBarTrailingItem,
                    showBackButton: !vNavigationViewBackButtonHidden,
                    onBack: back
                )
            
        case .leading:
            baseViewFrame
                .setUpBaseViewNavigationBarLeading(
                    model: model,
                    title: navigationBarTitle,
                    leadingItemContent: navigationBarLeadingItem,
                    trailingItemContent: navigationBarTrailingItem,
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
}

// MARK:- Back
private extension VBaseView {
    func back() {
        withAnimation { presentationMode.wrappedValue.dismiss() }
    }
}

// MARK:- Preview
struct VBaseView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationView(content: {
            VBaseView(
                title: "Home",
                trailingItem: { Button("Search", action: {}) },
                content: {
                    ZStack(content: {
                        Color.pink.edgesIgnoringSafeArea(.bottom)
                        
                        VNavigationLink(destination: Destination(), label: { Text("Go to Details") })
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
