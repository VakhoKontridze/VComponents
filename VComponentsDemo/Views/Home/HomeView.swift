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

    private let sections: [DemoSection<HomeRow>] = [
        .init(id: 0, title: "Buttons", rows: [.primaryButton, .secondaryButton, .squareButton, .chevronButton, .plainButton]),
        .init(id: 1, title: "State Pickers", rows: [.toggle]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.slider]),
        //.init(id: 4, title: "Custom Pickers", rows: []),
        //.init(id: 5, title: "Inputs", rows: []),
        .init(id: 4, title: "Containers", rows: [.sheet, .section, .table, .accordion]),
        .init(id: 5, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 6, title: "Modals", rows: [.sideBar]),
        .init(id: 7, title: "Messages", rows: [.alert]),
        .init(id: 8, title: "Indicators", rows: [.spinner]),
        //.init(id: 9, title: "Misc", rows: []),
        .init(id: 10, title: "Core", rows: [.interactiveView, .baseView, .lazyList])
    ]
    
    private enum HomeRow: Int, DemoableRow {
        case primaryButton, secondaryButton, squareButton, chevronButton, plainButton
        case toggle /*, checkBox*/ /*, radioButton*/
        case segmentedPicker /*, wheelPicker*/ /*, dropDown*/ /*, tabHeader*/
        case /*stepper,*/ slider /*, rangeSlider*/
        /*case*/ /*datePicker*/ /*, colorPicker*/
        /*case*/ /*textField*/ /*, searchBar*/ /*, textView*/
        case sheet, section, table, accordion
        case tabNavigationView, navigationView /*, topTabNavigationView*/
        case /*bottomSheet*/ /*, actionSheet*/ /*, contextMenu*/ sideBar
        case alert /*, banner*/ /*, toast*/
        case spinner /*, progressBar*/ /*, pagingIndicator*/
        /*case*/ /*shimmer*/
        case interactiveView, baseView, lazyList
        
        var title: String {
            switch self {
            case .primaryButton: return VPrimaryButtonDemoView.navigationBarTitle
            case .secondaryButton: return VSecondaryButtonDemoView.navigationBarTitle
            case .squareButton: return VSquareButtonDemoView.navigationBarTitle
            case .chevronButton: return "     \(VChevronButtonDemoView.navigationBarTitle)"
            case .plainButton: return VPlainButtonDemoView.navigationBarTitle
                
            case .toggle: return VToggleDemoView.navigationBarTitle
                
            case .segmentedPicker: return VSegmentedPickerDemoView.navigationBarTitle
                
            case .slider: return VSliderDemoView.navigationBarTitle
                
            case .sheet: return VSheetDemoView.navigationBarTitle
            case .section: return VSectionDemoView.navigationBarTitle
            case .table: return VTableDemoView.navigationBarTitle
            case .accordion: return VAccordionDemoView.navigationBarTitle
                
            case .tabNavigationView: return VTabNavigationViewDemoView.navigationBarTitle
            case .navigationView: return VNavigationViewDemoView.navigationBarTitle
                
            case .sideBar: return VSideBarDemoView.navigationBarTitle
                
            case .alert: return VAlertDemoView.navigationBarTitle
                
            case .spinner: return VSpinnerDemoView.navigationBarTitle
                
//            case .baseText: return VBaseTextDemoView.navigationBarTitle
            case .interactiveView: return VInteractiveViewDemoView.navigationBarTitle
            case .baseView: return VBaseViewDemoView.navigationBarTitle
            case .lazyList: return VLazyListDemoView.navigationBarTitle
            }
        }
        
        @ViewBuilder var body: some View {
            switch self {
            case .primaryButton: VPrimaryButtonDemoView()
            case .secondaryButton: VSecondaryButtonDemoView()
            case .squareButton: VSquareButtonDemoView()
            case .chevronButton: VChevronButtonDemoView()
            case .plainButton: VPlainButtonDemoView()
                
            case .toggle: VToggleDemoView()
                
            case .segmentedPicker: VSegmentedPickerDemoView()
                
            case .slider: VSliderDemoView()
                
            case .sheet: VSheetDemoView()
            case .table: VTableDemoView()
            case .section: VSectionDemoView()
            case .accordion: VAccordionDemoView()
                
            case .tabNavigationView: VTabNavigationViewDemoView()
            case .navigationView: VNavigationViewDemoView()
                
            case .sideBar: VSideBarDemoView()
                
            case .alert: VAlertDemoView()
                
            case .spinner: VSpinnerDemoView()
                
//            case .baseText: VBaseTextDemoView()
            case .interactiveView: VInteractiveViewDemoView()
            case .baseView: VBaseViewDemoView()
            case .lazyList: VLazyListDemoView()
            }
        }
    }
}

// MARK:- Body
extension HomeView {
    var body: some View {
        VNavigationView(content: {
            VBaseView(title: Self.navigationBarTitle, content: {
                DemoListView(sections: sections)
            })
        })
    }
}

// MARK:- Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
