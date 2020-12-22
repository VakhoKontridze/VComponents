//
//  HomeView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- Home View
struct HomeView: View {
    // MARK: Properties
    private static let sceneTitle: String = "VComponents Demo"
}

// MARK:- Body
extension HomeView {
    var body: some View {
        NavigationView(content: {
            List(content: {
                NavigationLink(VPrimaryButtonDemoView.sceneTitle, destination: VPrimaryButtonDemoView())
                NavigationLink(VPlainButtonDemoView.sceneTitle, destination: VPlainButtonDemoView())
                NavigationLink(VCircularButtonDemoView.sceneTitle, destination: VCircularButtonDemoView())
                NavigationLink(VToggleDemoView.sceneTitle, destination: VToggleDemoView())
                NavigationLink(VSliderDemoView.sceneTitle, destination: VSliderDemoView())
                NavigationLink(VSpinnerDemoView.sceneTitle, destination: VSpinnerDemoView())
            })
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Self.sceneTitle)
//                .toolbar(content: {
//                    ToolbarItem(placement: .principal, content: { Text(Self.sceneTitle) })
//                })
        })
            .colorNavigationBar()
    }
}

extension View {
    func colorNavigationBar(
        backgroundColor: UIColor = .init(VComponents.ColorBook.layer),
        tintColor: UIColor = .init(VComponents.ColorBook.primary)
    ) -> some View {
        modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

struct NavigationBarColor: ViewModifier {
    init(backgroundColor: UIColor, tintColor: UIColor) {
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: tintColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        let appearance: UINavigationBarAppearance = {
            let appearance: UINavigationBarAppearance = .init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = textAttributes
            appearance.largeTitleTextAttributes = textAttributes
            return appearance
        }()

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().tintColor = tintColor
    }
    
    func body(content: Content) -> some View {
        content
    }
}

// MARK:- Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
