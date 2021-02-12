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
    private static let navBarTitle: String = "VComponents Demo"

    private let sections: [DemoSection<HomeRow>] = [
        .init(id: 0, title: "Buttons", rows: [
            .primaryButton, .secondaryButton, .squareButton, .plainButton,
            .chevronButton, .closeButton,
            .navigationLink, .link
        ]),
        .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker, .menuPicker, .wheelPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.stepper, .slider, .rangeSlider]),
        .init(id: 4, title: "Inputs", rows: [.textField]),
        .init(id: 5, title: "Containers", rows: [.sheet, .list, .table, .accordion]),
        .init(id: 6, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 7, title: "Modals", rows: [.modal, .halfModal, .sideBar, .dialog, .menu, .actionSheet]),
        .init(id: 8, title: "Messages", rows: [.toast]),
        .init(id: 9, title: "Indicators", rows: [.spinner, .progressBar, .pageIndicator]),
        .init(id: 10, title: "Core", rows: [.text, .baseButton, .baseTextField, .lazyScrollView, .baseList, .baseView])
    ]

    private enum HomeRow: Int, DemoableRow {
        case primaryButton, secondaryButton, squareButton, plainButton, chevronButton, closeButton, navigationLink, link
        case toggle, checkBox, radioButton
        case segmentedPicker, menuPicker, wheelPicker
        case stepper, slider,  rangeSlider
        case textField
        case sheet, list, table, accordion
        case tabNavigationView, navigationView
        case modal, halfModal, sideBar, dialog, menu, actionSheet
        case toast
        case spinner, progressBar, pageIndicator
        case text, baseButton, baseTextField, lazyScrollView, baseList, baseView

        var title: String {
            switch self {
            case .primaryButton: return VPrimaryButtonDemoView.navBarTitle
            case .secondaryButton: return VSecondaryButtonDemoView.navBarTitle
            case .squareButton: return VSquareButtonDemoView.navBarTitle
            case .plainButton: return VPlainButtonDemoView.navBarTitle
            case .chevronButton: return VChevronButtonDemoView.navBarTitle
            case .closeButton: return VCloseButtonDemoView.navBarTitle
            case .navigationLink: return VNavigationLinkDemoView.navBarTitle
            case .link: return VLinkDemoView.navBarTitle

            case .toggle: return VToggleDemoView.navBarTitle
            case .checkBox: return VCheckBoxDemoView.navBarTitle
            case .radioButton: return VRadioButtonDemoView.navBarTitle

            case .segmentedPicker: return VSegmentedPickerDemoView.navBarTitle
            case .menuPicker: return VMenuPickerDemoView.navBarTitle
            case .wheelPicker: return VWheelPickerDemoView.navBarTitle

            case .stepper: return VStepperDemoView.navBarTitle
            case .slider: return VSliderDemoView.navBarTitle
            case .rangeSlider: return VRangeSliderDemoView.navBarTitle

            case .textField: return VTextFieldDemoView.navBarTitle
                
            case .sheet: return VSheetDemoView.navBarTitle
            case .list: return VListDemoView.navBarTitle
            case .table: return VTableDemoView.navBarTitle
            case .accordion: return VAccordionDemoView.navBarTitle

            case .tabNavigationView: return VTabNavigationViewDemoView.navBarTitle
            case .navigationView: return VNavigationViewDemoView.navBarTitle

            case .modal: return VModalDemoView.navBarTitle
            case .halfModal: return VHalfModalDemoView.navBarTitle
            case .sideBar: return VSideBarDemoView.navBarTitle
            case .dialog: return VDialogDemoView.navBarTitle
            case .menu: return VMenuDemoView.navBarTitle
            case .actionSheet: return VActionSheetDemoView.navBarTitle
                
            case .toast: return VToastDemoView.navBarTitle

            case .spinner: return VSpinnerDemoView.navBarTitle
            case .progressBar: return VProgressBarDemoView.navBarTitle
            case .pageIndicator: return VPageIndicatorDemoView.navBarTitle

            case .text: return VTextDemoView.navBarTitle
            case .baseButton: return VBaseButtonDemoView.navBarTitle
            case .baseTextField: return VBaseTextFieldDemoView.navBarTitle
            case .lazyScrollView: return VLazyScrollViewDemoView.navBarTitle
            case .baseList: return VBaseListDemoView.navBarTitle
            case .baseView: return VBaseViewDemoView.navBarTitle
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
            case .link: VLinkDemoView()

            case .toggle: VToggleDemoView()
            case .checkBox: VCheckBoxDemoView()
            case .radioButton: VRadioButtonDemoView()

            case .segmentedPicker: VSegmentedPickerDemoView()
            case .menuPicker: VMenuPickerDemoView()
            case .wheelPicker: VWheelPickerDemoView()

            case .stepper: VStepperDemoView()
            case .slider: VSliderDemoView()
            case .rangeSlider: VRangeSliderDemoView()
                
            case .textField: VTextFieldDemoView()

            case .sheet: VSheetDemoView()
            case .table: VTableDemoView()
            case .list: VListDemoView()
            case .accordion: VAccordionDemoView()

            case .tabNavigationView: VTabNavigationViewDemoView()
            case .navigationView: VNavigationViewDemoView()

            case .modal: VModalDemoView()
            case .halfModal: VHalfModalDemoView()
            case .sideBar: VSideBarDemoView()
            case .dialog: VDialogDemoView()
            case .menu: VMenuDemoView()
            case .actionSheet: VActionSheetDemoView()
                
            case .toast: VToastDemoView()

            case .spinner: VSpinnerDemoView()
            case .progressBar: VProgressBarDemoView()
            case .pageIndicator: VPageIndicatorDemoView()

            case .text: VTextDemoView()
            case .baseButton: VBaseButtonDemoView()
            case .baseTextField: VBaseTextFieldDemoView()
            case .lazyScrollView: VLazyScrollViewDemoView()
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
            VBaseView(title: Self.navBarTitle, content: {
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
