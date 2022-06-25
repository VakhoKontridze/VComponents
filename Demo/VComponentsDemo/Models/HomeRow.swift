//
//  HomeRow.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 27.05.22.
//

import SwiftUI

// MARK: - Home Row
enum HomeRow: Int, DemoableRow {
    // MARK: Cases
    case primaryButton, secondaryButton, squareButton, plainButton, navigationLink, link
    case toggle, checkBox, radioButton
    case segmentedPicker, menuPicker, wheelPicker
    case stepper, slider,  rangeSlider
    case textField
    case sheet, disclosureGroup
    case lazyScrollView, list, staticList
    case modal, bottomSheet, sideBar, alert, confirmationDialog, menu, contextMenu
    case toast
    case spinner, progressBar, pageIndicator
    case text

    // MARK: Properties
    static var sections: [DemoSection<HomeRow>] {
        [
            .init(id: 0, title: "Buttons", rows: [
                .primaryButton, .secondaryButton, .squareButton, .plainButton,
                .navigationLink, .link
            ]),
            .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
            .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker, .menuPicker, .wheelPicker]),
            .init(id: 3, title: "Value Pickers", rows: [.stepper, .slider, .rangeSlider]),
            .init(id: 4, title: "Inputs", rows: [.textField]),
            .init(id: 5, title: "Containers", rows: [.sheet, .disclosureGroup]),
            .init(id: 6, title: "Lists", rows: [.lazyScrollView, .list, .staticList]),
            .init(id: 7, title: "Modals", rows: [.modal, .bottomSheet, .sideBar, .alert, .confirmationDialog, .menu, .contextMenu]),
            .init(id: 8, title: "Messages", rows: [.toast]),
            .init(id: 9, title: "Indicators", rows: [.spinner, .progressBar, .pageIndicator]),
            .init(id: 10, title: "Misc", rows: [.text])
        ]
    }
    
    var title: String {
        switch self {
        case .primaryButton: return VPrimaryButtonDemoView.navBarTitle
        case .secondaryButton: return VSecondaryButtonDemoView.navBarTitle
        case .squareButton: return VSquareButtonDemoView.navBarTitle
        case .plainButton: return VPlainButtonDemoView.navBarTitle
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
        case .disclosureGroup: return VDisclosureGroupDemoView.navBarTitle
            
        case .lazyScrollView: return VLazyScrollViewDemoView.navBarTitle
        case .list: return VListDemoView.navBarTitle
        case .staticList: return VStaticListDemoView.navBarTitle

        case .modal: return VModalDemoView.navBarTitle
        case .bottomSheet: return VBottomSheetDemoView.navBarTitle
        case .sideBar: return VSideBarDemoView.navBarTitle
        case .alert: return VAlertDemoView.navBarTitle
        case .confirmationDialog: return VConfirmationDialogDemoView.navBarTitle
        case .menu: return VMenuDemoView.navBarTitle
        case .contextMenu: return VContextMenuDemoView.navBarTitle
            
        case .toast: return VToastDemoView.navBarTitle

        case .spinner: return VSpinnerDemoView.navBarTitle
        case .progressBar: return VProgressBarDemoView.navBarTitle
        case .pageIndicator: return VPageIndicatorDemoView.navBarTitle

        case .text: return VTextDemoView.navBarTitle
        }
    }

    @ViewBuilder var body: some View {
        switch self {
        case .primaryButton: VPrimaryButtonDemoView()
        case .secondaryButton: VSecondaryButtonDemoView()
        case .squareButton: VSquareButtonDemoView()
        case .plainButton: VPlainButtonDemoView()
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
        case .disclosureGroup: VDisclosureGroupDemoView()
            
        case .lazyScrollView: VLazyScrollViewDemoView()
        case .list: VListDemoView()
        case .staticList: VStaticListDemoView()

        case .modal: VModalDemoView()
        case .bottomSheet: VBottomSheetDemoView()
        case .sideBar: VSideBarDemoView()
        case .alert: VAlertDemoView()
        case .confirmationDialog: VConfirmationDialogDemoView()
        case .menu: VMenuDemoView()
        case .contextMenu: VContextMenuDemoView()
            
        case .toast: VToastDemoView()

        case .spinner: VSpinnerDemoView()
        case .progressBar: VProgressBarDemoView()
        case .pageIndicator: VPageIndicatorDemoView()

        case .text: VTextDemoView()
        }
    }
}
