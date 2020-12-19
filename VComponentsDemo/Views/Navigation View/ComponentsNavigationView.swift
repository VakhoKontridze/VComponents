//
//  ComponentsNavigationView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Components Navigation View
struct ComponentsNavigationView: View {
    // MARK: Properties
    private static let sceneTitle: String = "VComponents Demo"
}

// MARK:- Body
extension ComponentsNavigationView {
    var body: some View {
        NavigationView(content: {
            List(content: {
                NavigationLink(VButtonDemoView.sceneTitle, destination: VButtonDemoView())
                NavigationLink(VCircularButtonDemoView.sceneTitle, destination: VCircularButtonDemoView())
                NavigationLink(VSliderDemoView.sceneTitle, destination: VSliderDemoView())
                NavigationLink(VSpinnerDemoView.sceneTitle, destination: VSpinnerDemoView())
            })
                .navigationTitle(Self.sceneTitle)
                .navigationBarTitleDisplayMode(.inline)
        })
    }
}

// MARK:- Preview
struct ComponentsNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsNavigationView()
    }
}
