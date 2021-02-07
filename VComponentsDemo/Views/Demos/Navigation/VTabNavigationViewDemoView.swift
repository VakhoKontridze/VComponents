//
//  VTabNavigationViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VComponents

// MARK:- V Tab Navigation View Demo View
struct VTabNavigationViewDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Tab Navigation View"
}

// MARK:- Body
extension VTabNavigationViewDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component)
        })
    }
    
    private func component() -> some View {
        VStack(spacing: 20, content: {
            VText(
                type: .multiLine(limit: nil, alignment: .center),
                font: .body,
                color: ColorBook.primary,
                title: "Tab Navigation View should only ever be used on a root view. Continue?"
            )
            
            VSecondaryButton(
                action: { SceneDelegate.setRootView(to: VTabNavigationViewDemoViewWalkthroughView()) },
                title: "Start Demo"
            )
        })
    }
}

// MARK:- Walkthrough
private struct VTabNavigationViewDemoViewWalkthroughView: View {
    static let navBarTitle: String = ""
    @State private var selection: Int = 0
}

private extension VTabNavigationViewDemoViewWalkthroughView {
    var body: some View {
        VTabNavigationView(
            selection: $selection,
            pageOne: VTabNavigationViewPage(item: .titledAssetIcon(title: "Artists", name: "Artists"), content: pageOne),
            pageTwo: VTabNavigationViewPage(item: .titledAssetIcon(title: "Albums", name: "Albums"), content: pageTwo),
            pageThree: VTabNavigationViewPage(item: .titledAssetIcon(title: "Songs", name: "Songs"), content: pageThree),
            pageFour: VTabNavigationViewPage(item: .titledAssetIcon(title: "Favorites", name: "Favorites"), content: pageFour)
        )
    }

    private var pageOne: some View {
        VNavigationView(content: {
            VBaseView(title: "Red Page", content: {
                ZStack(content: {
                    Color.red
                    
                    VNavigationLink(
                        preset: .secondary(),
                        destination: VBaseView(title: "Details", content: { Color.orange }),
                        title: "Go to Details"
                    )
                    
                    goBackButton
                })
            })
        })
    }

    private var pageTwo: some View {
        VBaseView(title: "Green Page", content: {
            ZStack(content: {
                Color.green
                goBackButton
            })
        })
    }

    private var pageThree: some View {
        VBaseView(title: "Blue Page", content: {
            ZStack(content: {
                Color.blue
                goBackButton
            })
        })
    }

    private var pageFour: some View {
        VBaseView(title: "Yellow Page", content: {
            ZStack(content: {
                Color.yellow
                goBackButton
            })
        })
    }
    
    private var goBackButton: some View {
        VSecondaryButton(
            action: { SceneDelegate.setRootView(to: HomeView())  },
            title: "Go Back"
        )
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 25)
    }
}

// MARK:- Preview
struct VTabNavigationViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTabNavigationViewDemoView()
    }
}
