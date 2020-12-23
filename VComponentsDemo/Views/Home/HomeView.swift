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
    private static let navigationBarTitle: String = "VComponents Demo"
}

// MARK:- Body
extension HomeView {
    var body: some View {
        VBaseNavigationView(model: .init(), content: {
            VBaseView(title: Self.navigationBarTitle, content: {
                ScrollView(showsIndicators: false, content: {
                    section(title: "Buttons", content: {
                        HomeRowView(title: VPrimaryButtonDemoView.navigationBarTitle, destination: VPrimaryButtonDemoView())
                        HomeRowView(title: VPlainButtonDemoView.navigationBarTitle, destination: VPlainButtonDemoView())
                        HomeRowView(title: VCircularButtonDemoView.navigationBarTitle, destination: VCircularButtonDemoView())
                        HomeRowView(title: VChevronButtonDemoView.navigationBarTitle, destination: VChevronButtonDemoView(), showSeparator: false)
                    })

                    section(title: "Toggler", content: {
                        HomeRowView(title: VToggleDemoView.navigationBarTitle, destination: VToggleDemoView(), showSeparator: false)
                    })

                    section(title: "Range", content: {
                        HomeRowView(title: VSliderDemoView.navigationBarTitle, destination: VSliderDemoView(), showSeparator: false)
                    })

                    section(title: "Misc", content: {
                        HomeRowView(title: VSpinnerDemoView.navigationBarTitle, destination: VSpinnerDemoView(), showSeparator: false)
                    })
                    
                    section(title: "Containers", content: {
                        HomeRowView(title: VSheetDemoView.navigationBarTitle, destination: VSheetDemoView(), showSeparator: false)
                    })
                    
                    section(title: "Base", content: {
                        HomeRowView(title: VInteractiveViewDemoView.navigationBarTitle, destination: VInteractiveViewDemoView())
                        HomeRowView(title: VBaseNavigationViewDemoView.navigationBarTitle, destination: VBaseNavigationViewDemoView())
                        HomeRowView(title: VBaseViewDemoView.navigationBarTitle, destination: VBaseViewDemoView(), showSeparator: false)
                    })
                    
                    section(title: "Pseudo-Components", content: {
                        HomeRowView(title: VLazyListDemoView.navigationBarTitle, destination: VLazyListDemoView(), showSeparator: false)
                    })
                })
                    .padding(10)
            })
                .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
        })
    }

    private func section<Content>(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundColor(VComponents.ColorBook.primary)
            
            VSheet(.roundAll(.init(layout: .init(contentPadding: 10))), content: {
                VStack(content: content)
            })
        })
            .padding(.bottom, 25)
    }
}

// MARK:- Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
