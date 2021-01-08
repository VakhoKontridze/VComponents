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
        VNavigationView(content: {
            VBaseView(title: Self.navigationBarTitle, content: {
                ScrollView(content: {
                    Group(content: {
                        HomeSectionView(title: "Buttons", content: {
                            HomeRowView(title: VPrimaryButtonDemoView.navigationBarTitle, destination: VPrimaryButtonDemoView())
                            HomeRowView(title: VSecondaryButtonDemoView.navigationBarTitle, destination: VSecondaryButtonDemoView())
                            HomeRowView(title: VSquareButtonDemoView.navigationBarTitle, destination: VSquareButtonDemoView())
                            HomeRowView(title: VPlainButtonDemoView.navigationBarTitle, destination: VPlainButtonDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Derived Buttons", content: {
                            HomeRowView(title: VChevronButtonDemoView.navigationBarTitle, destination: VChevronButtonDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Pickers", content: {
                            HomeRowView(title: VToggleDemoView.navigationBarTitle, destination: VToggleDemoView())
                            HomeRowView(title: VSegmentedPickerDemoView.navigationBarTitle, destination: VSegmentedPickerDemoView())
                            HomeRowView(title: VSliderDemoView.navigationBarTitle, destination: VSliderDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Misc", content: {
                            HomeRowView(title: VSpinnerDemoView.navigationBarTitle, destination: VSpinnerDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Containers", content: {
                            HomeRowView(title: VSheetDemoView.navigationBarTitle, destination: VSheetDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Pseudo-Containers", content: {
                            HomeRowView(title: VLazyListDemoView.navigationBarTitle, destination: VLazyListDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Navigation", content: {
                            HomeRowView(title: VTabNavigationViewDemoView.navigationBarTitle, destination: VTabNavigationViewDemoView())
                            HomeRowView(title: VNavigationViewDemoView.navigationBarTitle, destination: VNavigationViewDemoView(), showSeparator: false)
                        })
                        
                        HomeSectionView(title: "Modals", content: {
                            HomeRowView(title: VSideBarDemoView.navigationBarTitle, destination: VSideBarDemoView())
                            HomeRowView(title: VAlertDemoView.navigationBarTitle, destination: VAlertDemoView(), showSeparator: false)
                        })

                        HomeSectionView(title: "Core", content: {
                            HomeRowView(title: VInteractiveViewDemoView.navigationBarTitle, destination: VInteractiveViewDemoView())
                            HomeRowView(title: VBaseViewDemoView.navigationBarTitle, destination: VBaseViewDemoView(), showSeparator: false)
                        })
                    })
                        .padding(10)
                })
                    .padding(.vertical, 1)  // ScrollView is bugged in SwiftUI 2.0
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
