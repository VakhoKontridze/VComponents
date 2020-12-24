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
    private let navigationType: VBaseNavigationViewType
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        _ navigationType: VBaseNavigationViewType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigationType = navigationType
        self.content = content
    }
}

// MARK:- Body
public extension VBaseNavigationView {
    @ViewBuilder var body: some View {
        switch navigationType {
        case .filled(let model): navigationViewFrame.setUpBaseNavigationBarFilledAppearance(model: model)
        case .transparent(let model): navigationViewFrame.setUpBaseNavigationBarTransparentAppearance(model: model)
        }
    }
    
    private var navigationViewFrame: some View {
        NavigationView(content: {
            content()
                .setUpBaseNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK:- Preview
struct VBaseNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
