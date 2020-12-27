//
//  VNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View
public struct VNavigationView<Content>: View where Content: View {
    // MARK: Properties
    private let navigationType: VNavigationViewType
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        _ navigationType: VNavigationViewType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigationType = navigationType
        self.content = content
    }
}

// MARK:- Body
public extension VNavigationView {
    @ViewBuilder var body: some View {
        switch navigationType {
        case .filled(let model): navigationViewFrame.setUpNavigationBarAppearanceFilled(model: model)
        case .transparent(let model): navigationViewFrame.setUpNavigationBarTransparentAppearance(model: model)
        }
    }
    
    private var navigationViewFrame: some View {
        NavigationView(content: {
            content()
                .setUpNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK:- Preview
struct VNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
