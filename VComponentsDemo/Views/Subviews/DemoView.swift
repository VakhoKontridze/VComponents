//
//  DemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Demo View
struct DemoView<Content, ControllerContent>: View
    where
        Content: View,
        ControllerContent: View
{
    // MARK: Properties
    private let navigationBarTitle: String
    
    private let controllerContent: (() -> ControllerContent)?
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        title navigationBarTitle: String,
        @ViewBuilder controller controllerContent: @escaping () -> ControllerContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigationBarTitle = navigationBarTitle
        self.controllerContent = controllerContent
        self.content = content
    }

    init(
        title navigationBarTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where ControllerContent == Never
    {
        self.navigationBarTitle = navigationBarTitle
        self.controllerContent = nil
        self.content = content
    }
}

// MARK:- Body
extension DemoView {
    var body: some View {
        VBaseView(title: navigationBarTitle, content: {
            VStack(content: {
                switch controllerContent {
                case nil: Spacer().frame(height: 10)
                case let controllerContent?: controllerContent()
                }
                
                DemoSectionView(title: nil, content: content)
            })
        })
            .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
    }
}

// MARK:- Preview
struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView(title: VPrimaryButtonDemoView.navigationBarTitle, content: {
            VPrimaryButtonDemoView()
        })
    }
}
