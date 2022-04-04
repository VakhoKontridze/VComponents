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
    private static var navBarTitle: String { "VComponents Demo" }

    private let sections: [DemoSection<HomeRow>] = [
        .init(id: 0, title: "Buttons", rows: [
            .baseButton,
            .primaryButton, .secondaryButton, .squareButton, .plainButton,
            .navigationLink, .link
        ]),
        .init(id: 1, title: "State Pickers", rows: [.toggle, .checkBox, .radioButton]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker, .menuPicker, .wheelPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.stepper, .slider, .rangeSlider]),
        .init(id: 4, title: "Inputs", rows: [.textField]),
        .init(id: 5, title: "Lists", rows: [.baseList, .accordion]),
        .init(id: 6, title: "Modals", rows: [.modal, .halfModal, .sideBar, .dialog, .menu, .actionSheet]),
        .init(id: 7, title: "Messages", rows: [.toast]),
        .init(id: 8, title: "Indicators", rows: [.spinner, .progressBar, .pageIndicator]),
        .init(id: 9, title: "Misc", rows: [.text, .sheet, .lazyScrollView])
    ]

    private enum HomeRow: Int, DemoableRow {
        case baseButton, primaryButton, secondaryButton, squareButton, plainButton, navigationLink, link
        case toggle, checkBox, radioButton
        case segmentedPicker, menuPicker, wheelPicker
        case stepper, slider,  rangeSlider
        case textField
        case baseList, accordion
        case modal, halfModal, sideBar, dialog, menu, actionSheet
        case toast
        case spinner, progressBar, pageIndicator
        case text, sheet, lazyScrollView

        var title: String {
            switch self {
            case .baseButton: return VBaseButtonDemoView.navBarTitle
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
                
            case .baseList: return VBaseListDemoView.navBarTitle
            case .accordion: return VAccordionDemoView.navBarTitle

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
            }
        }

        @ViewBuilder var body: some View {
            switch self {
            case .baseButton: VBaseButtonDemoView()
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

            case .baseList: VBaseListDemoView()
            case .accordion: VAccordionDemoView()

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
            }
        }
    }

    // MARK: Body
    var body: some View {
        NavigationView(content: {
            DemoListView(type: .accordion, sections: sections)
                .standardNavigationTitle(Self.navBarTitle)
        })
            .navigationViewStyle(.stack)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
