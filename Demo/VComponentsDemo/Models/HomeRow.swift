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
    case primaryButton, secondaryButton, roundedButton, roundedLabeledButton, plainButton
    case toggle, checkBox, radioButton
    case segmentedPicker, wheelPicker
    case stepper, slider,  rangeSlider
    case textField, textView
    case sheet, disclosureGroup
    case list
    case modal, bottomSheet, sideBar, alert, confirmationDialog, menu, contextMenu
    case toast
    case spinners, progressBar, pageIndicators
    case text, marquees

    // MARK: Properties
    static var sections: [DemoSection<Self>] {
        [
            .init(id: 0, title: "Buttons", rows: [.primaryButton, .secondaryButton, .roundedButton, .roundedLabeledButton, .plainButton]),
            .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
            .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker, .wheelPicker]),
            .init(id: 3, title: "Value Pickers", rows: [.stepper, .slider, .rangeSlider]),
            .init(id: 4, title: "Inputs", rows: [.textField, .textView]),
            .init(id: 5, title: "Containers", rows: [.sheet, .disclosureGroup]),
            .init(id: 6, title: "Lists", rows: [.list]),
            .init(id: 7, title: "Modals", rows: [.modal, .bottomSheet, .sideBar, .alert, .confirmationDialog, .menu, .contextMenu]),
            .init(id: 8, title: "Messages", rows: [.toast]),
            .init(id: 9, title: "Indicators", rows: [.spinners, .progressBar, .pageIndicators]),
            .init(id: 10, title: "Misc", rows: [.text, .marquees])
        ]
    }
    
    var title: String {
        switch self {
        case .primaryButton: return VPrimaryButtonDemoView.navBarTitle
        case .secondaryButton: return VSecondaryButtonDemoView.navBarTitle
        case .roundedButton: return VRoundedButtonDemoView.navBarTitle
        case .roundedLabeledButton: return VRoundedLabeledButtonDemoView.navBarTitle
        case .plainButton: return VPlainButtonDemoView.navBarTitle

        case .toggle: return VToggleDemoView.navBarTitle
        case .checkBox: return VCheckBoxDemoView.navBarTitle
        case .radioButton: return VRadioButtonDemoView.navBarTitle

        case .segmentedPicker: return VSegmentedPickerDemoView.navBarTitle
        case .wheelPicker: return VWheelPickerDemoView.navBarTitle

        case .stepper: return VStepperDemoView.navBarTitle
        case .slider: return VSliderDemoView.navBarTitle
        case .rangeSlider: return VRangeSliderDemoView.navBarTitle

        case .textField: return VTextFieldDemoView.navBarTitle
        case .textView: return VTextViewDemoView.navBarTitle
            
        case .sheet: return VSheetDemoView.navBarTitle
        case .disclosureGroup: return VDisclosureGroupDemoView.navBarTitle
            
        case .list: return VListDemoView.navBarTitle

        case .modal: return VModalDemoView.navBarTitle
        case .bottomSheet: return VBottomSheetDemoView.navBarTitle
        case .sideBar: return VSideBarDemoView.navBarTitle
        case .alert: return VAlertDemoView.navBarTitle
        case .confirmationDialog: return VConfirmationDialogDemoView.navBarTitle
        case .menu: return VMenuDemoView.navBarTitle
        case .contextMenu: return VContextMenuDemoView.navBarTitle
            
        case .toast: return VToastDemoView.navBarTitle

        case .spinners: return VSpinnersDemoView.navBarTitle
        case .progressBar: return VProgressBarDemoView.navBarTitle
        case .pageIndicators: return VPageIndicatorsDemoView.navBarTitle

        case .text: return VTextDemoView.navBarTitle
        case .marquees: return VMarqueesDemoView.navBarTitle
        }
    }

    @ViewBuilder var body: some View {
        switch self {
        case .primaryButton: VPrimaryButtonDemoView()
        case .secondaryButton: VSecondaryButtonDemoView()
        case .roundedButton: VRoundedButtonDemoView()
        case .roundedLabeledButton: VRoundedLabeledButtonDemoView()
        case .plainButton: VPlainButtonDemoView()

        case .toggle: VToggleDemoView()
        case .checkBox: VCheckBoxDemoView()
        case .radioButton: VRadioButtonDemoView()

        case .segmentedPicker: VSegmentedPickerDemoView()
        case .wheelPicker: VWheelPickerDemoView()

        case .stepper: VStepperDemoView()
        case .slider: VSliderDemoView()
        case .rangeSlider: VRangeSliderDemoView()
            
        case .textField: VTextFieldDemoView()
        case .textView: VTextViewDemoView()

        case .sheet: VSheetDemoView()
        case .disclosureGroup: VDisclosureGroupDemoView()
            
        case .list: VListDemoView()

        case .modal: VModalDemoView()
        case .bottomSheet: VBottomSheetDemoView()
        case .sideBar: VSideBarDemoView()
        case .alert: VAlertDemoView()
        case .confirmationDialog: VConfirmationDialogDemoView()
        case .menu: VMenuDemoView()
        case .contextMenu: VContextMenuDemoView()
            
        case .toast: VToastDemoView()

        case .spinners: VSpinnersDemoView()
        case .progressBar: VProgressBarDemoView()
        case .pageIndicators: VPageIndicatorsDemoView()

        case .text: VTextDemoView()
        case .marquees: VMarqueesDemoView()
        }
    }
}
