//
//  VBaseNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Base Navigation View
public struct VBaseNavigationView<Content>: View where Content: View {
    // MARK: Properties
    private let model: VBaseNavigationViewModel
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VBaseNavigationViewModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

// MARK:- Body
public extension VBaseNavigationView {
    var body: some View {
        NavigationView(content: {
            content()
                .setUpBaseNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
            .setUpBaseNavigationBarAppearance(model: model)
    }
}

// MARK:- Preview
struct VBaseNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
