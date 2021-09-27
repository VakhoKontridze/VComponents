//
//  HomeView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - Home View
struct HomeView: View {
    // MARK: Properties
    private static let navBarTitle: String = "VComponents Demo"

    private let sections: [DemoSection<HomeRow>] = [
        .init(id: 0, title: "Buttons", rows: [
            .baseButton,
            .primaryButton, .secondaryButton, .squareButton, .plainButton,
            .chevronButton, .closeButton,
            .navigationLink, .webLink
        ]),
        .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker, .menuPicker, .wheelPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.stepper, .slider, .rangeSlider]),
        .init(id: 4, title: "Inputs", rows: [.baseTextField, .textField]),
        .init(id: 5, title: "Lists", rows: [.baseList, .list, .sectionList, .accordion]),
        .init(id: 6, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 7, title: "Modals", rows: [.modal, .halfModal, .sideBar, .dialog, .menu, .actionSheet]),
        .init(id: 8, title: "Messages", rows: [.toast]),
        .init(id: 9, title: "Indicators", rows: [.spinner, .progressBar, .pageIndicator]),
        .init(id: 10, title: "Misc", rows: [.text, .sheet, .lazyScrollView, .baseView])
    ]

    private enum HomeRow: Int, DemoableRow {
        case baseButton, primaryButton, secondaryButton, squareButton, plainButton, chevronButton, closeButton, navigationLink, webLink
        case toggle, checkBox, radioButton
        case segmentedPicker, menuPicker, wheelPicker
        case stepper, slider,  rangeSlider
        case baseTextField, textField
        case baseList, list, sectionList, accordion
        case tabNavigationView, navigationView
        case modal, halfModal, sideBar, dialog, menu, actionSheet
        case toast
        case spinner, progressBar, pageIndicator
        case text, sheet, lazyScrollView, baseView

        var title: String {
            switch self {
            case .baseButton: return VBaseButtonDemoView.navBarTitle
            case .primaryButton: return VPrimaryButtonDemoView.navBarTitle
            case .secondaryButton: return VSecondaryButtonDemoView.navBarTitle
            case .squareButton: return VSquareButtonDemoView.navBarTitle
            case .plainButton: return VPlainButtonDemoView.navBarTitle
            case .chevronButton: return VChevronButtonDemoView.navBarTitle
            case .closeButton: return VCloseButtonDemoView.navBarTitle
            case .navigationLink: return VNavigationLinkDemoView.navBarTitle
            case .webLink: return VWebLinkDemoView.navBarTitle

            case .toggle: return VToggleDemoView.navBarTitle
            case .checkBox: return VCheckBoxDemoView.navBarTitle
            case .radioButton: return VRadioButtonDemoView.navBarTitle

            case .segmentedPicker: return VSegmentedPickerDemoView.navBarTitle
            case .menuPicker: return VMenuPickerDemoView.navBarTitle
            case .wheelPicker: return VWheelPickerDemoView.navBarTitle

            case .stepper: return VStepperDemoView.navBarTitle
            case .slider: return VSliderDemoView.navBarTitle
            case .rangeSlider: return VRangeSliderDemoView.navBarTitle

            case .baseTextField: return VBaseTextFieldDemoView.navBarTitle
            case .textField: return VTextFieldDemoView.navBarTitle
                
            case .baseList: return VBaseListDemoView.navBarTitle
            case .list: return VListDemoView.navBarTitle
            case .sectionList: return VSectionListDemoView.navBarTitle
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
            case .sheet: return VSheetDemoView.navBarTitle
            case .lazyScrollView: return VLazyScrollViewDemoView.navBarTitle
            case .baseView: return VBaseViewDemoView.navBarTitle
            }
        }

        @ViewBuilder var body: some View {
            switch self {
            case .baseButton: VBaseButtonDemoView()
            case .primaryButton: VPrimaryButtonDemoView()
            case .secondaryButton: VSecondaryButtonDemoView()
            case .squareButton: VSquareButtonDemoView()
            case .plainButton: VPlainButtonDemoView()
            case .chevronButton: VChevronButtonDemoView()
            case .closeButton: VCloseButtonDemoView()
            case .navigationLink: VNavigationLinkDemoView()
            case .webLink: VWebLinkDemoView()

            case .toggle: VToggleDemoView()
            case .checkBox: VCheckBoxDemoView()
            case .radioButton: VRadioButtonDemoView()

            case .segmentedPicker: VSegmentedPickerDemoView()
            case .menuPicker: VMenuPickerDemoView()
            case .wheelPicker: VWheelPickerDemoView()

            case .stepper: VStepperDemoView()
            case .slider: VSliderDemoView()
            case .rangeSlider: VRangeSliderDemoView()
                
            case .baseTextField: VBaseTextFieldDemoView()
            case .textField: VTextFieldDemoView()

            case .baseList: VBaseListDemoView()
            case .list: VListDemoView()
            case .sectionList: VSectionListDemoView()
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
            case .sheet: VSheetDemoView()
            case .lazyScrollView: VLazyScrollViewDemoView()
            case .baseView: VBaseViewDemoView()
            }
        }
    }

    // MARK: Body
    var body: some View {
        VNavigationView(content: {
            VBaseView(title: Self.navBarTitle, content: {
                DemoListView(type: .accordion, sections: sections)
            })
        })
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
