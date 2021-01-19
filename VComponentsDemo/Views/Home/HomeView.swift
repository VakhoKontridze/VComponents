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
        .init(id: 0, title: "Buttons", rows: [.primaryButton, .secondaryButton, .squareButton, .plainButton, .chevronButton, .closeButton, .navigationLink]),
        .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.slider, .rangeSlider]),
        //.init(id: 4, title: "Custom Pickers", rows: []),
        //.init(id: 5, title: "Inputs", rows: []),
        .init(id: 4, title: "Containers", rows: [.sheet, .section, .table, .accordion]),
        .init(id: 5, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 6, title: "Modals", rows: [.modal, .sideBar]),
        .init(id: 7, title: "Messages", rows: [.alert]),
        .init(id: 8, title: "Indicators", rows: [.spinner, .progressBar]),
        .init(id: 9, title: "Core", rows: [.baseTitle, .baseButton, .lazyList, .baseList, .baseView])
    ]
    
    private enum HomeRow: Int, DemoableRow {
        case primaryButton, secondaryButton, squareButton, plainButton, chevronButton, closeButton, navigationLink
        case toggle, checkBox, radioButton
        case segmentedPicker /*, wheelPicker*/ /*, dropDown*/ /*, actionSheet*/ /*, contextMenu*/ /* tabHeader*/
        case /*stepper,*/ slider,  rangeSlider
        /*case*/ /*datePicker*/ /*, colorPicker*/
        /*case*/ /*textField*/ /*, searchBar*/ /*, textView*/
        case sheet, section, table, accordion
        case tabNavigationView, navigationView /*, topTabNavigationView*/
        case modal, sideBar /*,bottomSheet*/
        case alert /*, banner*/ /*, toast*/
        case spinner, progressBar /*, pagingIndicator*/
        case baseTitle, baseButton, lazyList, baseList, baseView
        
        var title: String {
            switch self {
            case .primaryButton: return VPrimaryButtonDemoView.navigationBarTitle
            case .secondaryButton: return VSecondaryButtonDemoView.navigationBarTitle
            case .squareButton: return VSquareButtonDemoView.navigationBarTitle
            case .plainButton: return VPlainButtonDemoView.navigationBarTitle
            case .chevronButton: return VChevronButtonDemoView.navigationBarTitle
            case .closeButton: return VCloseButtonDemoView.navigationBarTitle
            case .navigationLink: return VNavigationLinkDemoView.navigationBarTitle
                
            case .toggle: return VToggleDemoView.navigationBarTitle
            case .checkBox: return VCheckBoxDemoView.navigationBarTitle
            case .radioButton: return VRadioButtonDemoView.navigationBarTitle
                
            case .segmentedPicker: return VSegmentedPickerDemoView.navigationBarTitle
                
            case .slider: return VSliderDemoView.navigationBarTitle
            case .rangeSlider: return VRangeSliderDemoView.navigationBarTitle
                
            case .sheet: return VSheetDemoView.navigationBarTitle
            case .section: return VSectionDemoView.navigationBarTitle
            case .table: return VTableDemoView.navigationBarTitle
            case .accordion: return VAccordionDemoView.navigationBarTitle
                
            case .tabNavigationView: return VTabNavigationViewDemoView.navigationBarTitle
            case .navigationView: return VNavigationViewDemoView.navigationBarTitle
                
            case .modal: return VModalDemoView.navigationBarTitle
            case .sideBar: return VSideBarDemoView.navigationBarTitle
                
            case .alert: return VAlertDemoView.navigationBarTitle
                
            case .spinner: return VSpinnerDemoView.navigationBarTitle
            case .progressBar: return VProgressBarDemoView.navigationBarTitle
                
            case .baseTitle: return VBaseTitleDemoView.navigationBarTitle
            case .baseButton: return VBaseButtonDemoView.navigationBarTitle
            case .lazyList: return VLazyListDemoView.navigationBarTitle
            case .baseList: return VBaseListDemoView.navigationBarTitle
            case .baseView: return VBaseViewDemoView.navigationBarTitle
            }
        }
        
        @ViewBuilder var body: some View {
            switch self {
            case .primaryButton: VPrimaryButtonDemoView()
            case .secondaryButton: VSecondaryButtonDemoView()
            case .squareButton: VSquareButtonDemoView()
            case .plainButton: VPlainButtonDemoView()
            case .chevronButton: VChevronButtonDemoView()
            case .closeButton: VCloseButtonDemoView()
            case .navigationLink: VNavigationLinkDemoView()
                
            case .toggle: VToggleDemoView()
            case .checkBox: VCheckBoxDemoView()
            case .radioButton: VRadioButtonDemoView()
                
            case .segmentedPicker: VSegmentedPickerDemoView()
                
            case .slider: VSliderDemoView()
            case .rangeSlider: VRangeSliderDemoView()
                
            case .sheet: VSheetDemoView()
            case .table: VTableDemoView()
            case .section: VSectionDemoView()
            case .accordion: VAccordionDemoView()
                
            case .tabNavigationView: VTabNavigationViewDemoView()
            case .navigationView: VNavigationViewDemoView()
                
            case .modal: VModalDemoView()
            case .sideBar: VSideBarDemoView()
                
            case .alert: VAlertDemoView()
                
            case .spinner: VSpinnerDemoView()
            case .progressBar: VProgressBarDemoView()
                
            case .baseTitle: VBaseTitleDemoView()
            case .baseButton: VBaseButtonDemoView()
            case .lazyList: VLazyListDemoView()
            case .baseList: VBaseListDemoView()
            case .baseView: VBaseViewDemoView()
            }
        }
    }
}

// MARK:- Body
extension HomeView {
    var body: some View {
        VNavigationView(content: {
            VBaseView(title: Self.navigationBarTitle, content: {
                DemoListView(type: .accordion, sections: sections)
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
