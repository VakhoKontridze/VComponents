//
//  VBaseView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base View
public struct VBaseView<Content, NavigationBarTrailingItemsContent>: View
    where
        Content: View,
        NavigationBarTrailingItemsContent: View
{
    // MARK: Properties
    private let model: VBaseViewModel
    
    private let navigationBarTitle: String
    private let navigationBarTrailingItemsContent: (() -> NavigationBarTrailingItemsContent)?
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder trailingItems navigationBarTrailingItemsContent: @escaping () -> NavigationBarTrailingItemsContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarTrailingItemsContent = navigationBarTrailingItemsContent
        self.content = content
    }
}

public extension VBaseView where NavigationBarTrailingItemsContent == Never {
    init(
        model: VBaseViewModel = .init(),
        title navigationBarTitle: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarTrailingItemsContent = nil
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
                trailingItemsContent: navigationBarTrailingItemsContent
            )
            .addNavigationBarSwipeGesture()
    }
}

// MARK:- Preview
struct VBaseView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseNavigationView(content: {
            VBaseView(title: "Home", trailingItems: { Button("Search", action: {}) }, content: {
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
