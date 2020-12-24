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
        VBaseNavigationView(content: {
            VBaseView(title: Self.navigationBarTitle, content: {
                ScrollView(content: {
                    Group(content: {
                        HomeSectionView(title: "Buttons", content: {
                            HomeRowView(title: VPrimaryButtonDemoView.navigationBarTitle, destination: VPrimaryButtonDemoView())
                            HomeRowView(title: VSecondaryButtonDemoView.navigationBarTitle, destination: VSecondaryButtonDemoView())
                            HomeRowView(title: VSquareButtonDemoView.navigationBarTitle, destination: VSquareButtonDemoView())
                            HomeRowView(title: VPlainButtonDemoView.navigationBarTitle, destination: VPlainButtonDemoView())
                            HomeRowView(title: VChevronButtonDemoView.navigationBarTitle, destination: VChevronButtonDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Toggler", content: {
                            HomeRowView(title: VToggleDemoView.navigationBarTitle, destination: VToggleDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Range", content: {
                            HomeRowView(title: VSliderDemoView.navigationBarTitle, destination: VSliderDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Misc", content: {
                            HomeRowView(title: VSpinnerDemoView.navigationBarTitle, destination: VSpinnerDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Containers", content: {
                            HomeRowView(title: VSheetDemoView.navigationBarTitle, destination: VSheetDemoView())
                            HomeRowView(title: VSideBarDemoView.navigationBarTitle, destination: VSideBarDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Pseudo-Containers", content: {
                            HomeRowView(title: VLazyListDemoView.navigationBarTitle, destination: VLazyListDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Base", content: {
                            HomeRowView(title: VBaseNavigationViewDemoView.navigationBarTitle, destination: VBaseNavigationViewDemoView())
                            HomeRowView(title: VBaseViewDemoView.navigationBarTitle, destination: VBaseViewDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Core", content: {
                            HomeRowView(title: VInteractiveViewDemoView.navigationBarTitle, destination: VInteractiveViewDemoView(), showSeparator: false)
                        })
                    })
                        .padding(.horizontal, 10)
                })
            })
                .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
        })
    }
}

// MARK:- Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
