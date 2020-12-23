//
//  VBaseView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base View
public struct VBaseView<Content, NavigationBarLeadingItem, NavigationBarTrailingItem>: View
    where
        Content: View,
        NavigationBarLeadingItem: View,
        NavigationBarTrailingItem: View
{
    // MARK: Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    private let model: VBaseViewModel
    
    private let navigationBarTitle: String
    private let navigationBarLeadingItem: NavigationBarLeadingItem?
    private let navigationBarTrailingItem: NavigationBarTrailingItem?
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        leadingItem navigationBarLeadingItem: NavigationBarLeadingItem,
        trailingItem navigationBarTrailingItem: NavigationBarTrailingItem,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = navigationBarLeadingItem
        self.navigationBarTrailingItem = navigationBarTrailingItem
        self.content = content
    }
}

public extension VBaseView where NavigationBarLeadingItem == Never {
    init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        trailingItem navigationBarTrailingItem: NavigationBarTrailingItem,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = nil
        self.navigationBarTrailingItem = navigationBarTrailingItem
        self.content = content
    }
}

public extension VBaseView where NavigationBarTrailingItem == Never {
    init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        leadingItem navigationBarLeadingItem: NavigationBarLeadingItem,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = navigationBarLeadingItem
        self.navigationBarTrailingItem = nil
        self.content = content
    }
}

public extension VBaseView
    where
        NavigationBarLeadingItem == Never,
        NavigationBarTrailingItem == Never
{
    init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeadingItem = nil
        self.navigationBarTrailingItem = nil
        self.content = content
    }
}

// MARK:- Body
public extension VBaseView {
    var body: some View {
        content()
            .setUpBaseViewNavigationBar(
                model: model,
                title: navigationBarTitle,
                leadingItem: navigationBarLeadingItem,
                trailingItem: navigationBarTrailingItem
            )
            .addNavigationBarSwipeGesture(completion: {
                withAnimation { presentationMode.wrappedValue.dismiss() }
            })
    }
}

// MARK:- Preview
struct VBaseView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseNavigationView(content: {
            VBaseView(title: "Home", trailingItem: Button("Search", action: {}), content: {
                ZStack(content: {
                    Color.pink.edgesIgnoringSafeArea(.bottom)
                    
                    NavigationLink("Go to Details", destination: {
                        VBaseView(title: "Details", content: {
                            Color.blue.edgesIgnoringSafeArea(.bottom)
                        })
                    }())
                })
            })
        })
    }
}
