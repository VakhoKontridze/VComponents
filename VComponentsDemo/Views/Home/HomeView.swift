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
        .init(id: 0, title: "Buttons", rows: [.primaryButton, .secondaryButton, .squareButton, .plainButton, .chevronButton, .closeButton]),
        .init(id: 1, title: "State Pickers", rows: [.toggle]),
        .init(id: 2, title: "Item Pickers", rows: [.segmentedPicker]),
        .init(id: 3, title: "Value Pickers", rows: [.slider, .rangeSlider]),
        //.init(id: 4, title: "Custom Pickers", rows: []),
        //.init(id: 5, title: "Inputs", rows: []),
        .init(id: 4, title: "Containers", rows: [.sheet, .section, .table, .accordion]),
        .init(id: 5, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 6, title: "Modals", rows: [.modal, .sideBar]),
        .init(id: 7, title: "Messages", rows: [.alert]),
        .init(id: 8, title: "Indicators", rows: [.spinner, .progressBar]),
        //.init(id: 9, title: "Misc", rows: []),
        .init(id: 10, title: "Core", rows: [.baseTitle, .baseButton, .lazyList, .baseList, .baseView])
    ]
    
    private enum HomeRow: Int, DemoableRow {
        case primaryButton, secondaryButton, squareButton, plainButton, chevronButton, closeButton
        case toggle /*, checkBox*/ /*, radioButton*/
        case segmentedPicker /*, wheelPicker*/ /*, dropDown*/ /*, tabHeader*/
        case /*stepper,*/ slider,  rangeSlider
        /*case*/ /*datePicker*/ /*, colorPicker*/
        /*case*/ /*textField*/ /*, searchBar*/ /*, textView*/
        case sheet, section, table, accordion
        case tabNavigationView, navigationView /*, topTabNavigationView*/
        case modal, /*bottomSheet*/ /*, actionSheet*/ /*, contextMenu*/ sideBar
        case alert /*, banner*/ /*, toast*/
        case spinner, progressBar /*, pagingIndicator*/
        /*case*/ /*shimmer*/
        case baseTitle, baseButton, lazyList, baseList, baseView
        
        var title: String {
            switch self {
            case .primaryButton: return VPrimaryButtonDemoView.navigationBarTitle
            case .secondaryButton: return VSecondaryButtonDemoView.navigationBarTitle
            case .squareButton: return VSquareButtonDemoView.navigationBarTitle
            case .plainButton: return VPlainButtonDemoView.navigationBarTitle
            case .chevronButton: return VChevronButtonDemoView.navigationBarTitle
            case .closeButton: return VCloseButtonDemoView.navigationBarTitle
                
            case .toggle: return VToggleDemoView.navigationBarTitle
                
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
                
            case .toggle: VToggleDemoView()
                
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

/*
struct TEST: View {
//    var body: some View {
//        VPrimaryButton(action: { print("Pressed") }, title: "Press")
//            .padding()
//    }
    
//    var body: some View {
//        VSecondaryButton(action: { print("Pressed") }, title: "Press")
//    }
    
//    var body: some View {
//        VPlainButton(action: { print("Pressed") }, title: "Press")
//    }

//    var body: some View {
//        VSquareButton(action: { print("Pressed") }, content: {
//            Image(systemName: "swift")
//                .resizable()
//                .frame(width: 20, height: 20)
//                .foregroundColor(.white)
//        })
//    }
    
//    @State var direction: VChevronButtonDirection = .left
//
//    var body: some View {
//        VChevronButton(direction: direction, action: { print("Pressed") })
//    }
    
//    var body: some View {
//        VCloseButton(action: { print("Pressed") })
//    }
    
//    enum PickerRow: Int, CaseIterable, VPickerEnumerableItem {
//        case red, green, blue
//
//        var color: Color {
//            switch self {
//            case .red: return .red
//            case .green: return .green
//            case .blue: return .blue
//            }
//        }
//    }
//
//    @State var selection: PickerRow = .red
//    @State var state: VSegmentedPickerState = .enabled
//    @State var disabledItems: Set<PickerRow> = []
//
//    var body: some View {
//        VSegmentedPicker(
//            selection: $selection,
//            state: state,
//            title: "Lorem ipsum dolor sit amet",
//            subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
//            rowContent: { item in
//                Image(systemName: "swift")
//                    .resizable()
//                    .frame(width: 15, height: 15)
//                    .foregroundColor(item.color)
//            }
//        )
//            .padding()
//    }
    
//    @State var value: Double = 0.5
//
//    var body: some View {
//        VSlider(value: $value)
//            .padding()
//    }
    
//    @State var valueLow: Double = 0.3
//    @State var valueHigh: Double = 0.8
//
//    var body: some View {
//        VRangeSlider(
//            difference: 0.1,
//            valueLow: $valueLow,
//            valueHigh: $valueHigh
//        )
//            .padding()
//    }
    
//    let model: VSheetModel = .init()
//
//    var body: some View {
//        ZStack(alignment: .top, content: {
//            ColorBook.canvas
//
//            VSheet(model: model, content: {
//                Image(systemName: "swift")
//                    .resizable()
//                    .frame(width: 200, height: 200)
//                    .foregroundColor(.accentColor)
//            })
//                .padding()
//        })
//    }
    
//    struct SectionRow: Identifiable {
//        let id: UUID = .init()
//        let title: String
//    }
//
//    let model: VSectionModel = .init()
//    @State var data: [SectionRow] = [
//        .init(title: "Red"),
//        .init(title: "Green"),
//        .init(title: "Blue")
//    ]
//
//    var body: some View {
//        ZStack(alignment: .top, content: {
//            ColorBook.canvas
//
//            VSection(
//                model: model,
//                layout: .fixed,
//                title: "Lorem ipsum dolor sit amet",
//                data: data,
//                content: { row in
//                    Text(row.title)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            )
//                .padding()
//        })
//    }
    
//    struct TableSection: Identifiable, VTableSection {
//        let id: UUID = .init()
//        let title: String
//        let rows: [TableRow]
//    }
//
//    struct TableRow: VTableRow {
//        let id: UUID = .init()
//        let title: String
//    }
//
//    @State var sections: [TableSection] = [
//        .init(title: "First", rows: [
//            .init(title: "Red"),
//            .init(title: "Green"),
//            .init(title: "Blue")
//        ]),
//        .init(title: "Second", rows: [
//            .init(title: "Red"),
//            .init(title: "Green"),
//            .init(title: "Blue")
//        ])
//    ]
//
//    var body: some View {
//        ZStack(alignment: .top, content: {
//            ColorBook.canvas
//
//            VTable(
//                layout: .fixed,
//                sections: sections,
//                headerContent: { section in
//                    VTableDefaultHeaderFooter(title: section.title)
//                },
//                footerContent: { section in
//                    VTableDefaultHeaderFooter(title: section.title)
//                },
//                rowContent: { row in
//                    Text(row.title)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            )
//                .padding()
//        })
//    }
    
//    struct AccordionRow: Identifiable {
//        let id: UUID = .init()
//        let title: String
//    }
//
//    let model: VAccordionModel = .init()
//    @State var state: VAccordionState = .expanded
//    @State var data: [AccordionRow] = [
//        .init(title: "Red"),
//        .init(title: "Green"),
//        .init(title: "Blue")
//    ]
//
//    var body: some View {
//        ZStack(alignment: .top, content: {
//            ColorBook.canvas
//
//            VAccordion(
//                model: model,
//                layout: .fixed,
//                state: $state,
//                headerContent: {
//                    VAccordionDefaultHeader(title: "Lorem ipsum dolor sit amet")
//                },
//                data: data,
//                rowContent: { row in
//                    Text(row.title)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            )
//                .padding()
//        })
//    }
    
//    @State var selection: Int = 0
//
//    func item(_ title: String) -> some View {
//        VStack(spacing: 5, content: {
//            Image(systemName: "swift")
//                .resizable()
//                .frame(width: 20, height: 20)
//
//            Text(title)
//        })
//    }
//
//    var body: some View {
//        VTabNavigationView(
//            selection: $selection,
//            pageOne: VTabNavigationViewPage(
//                item: item("Red"),
//                content: Color.red
//            ),
//            pageTwo: VTabNavigationViewPage(
//                item: item("Green"),
//                content: Color.green
//            ),
//            pageThree: VTabNavigationViewPage(
//                item: item("Blue"),
//                content: Color.blue
//            ),
//            pageFour: VTabNavigationViewPage(
//                item: item("Pink"),
//                content: Color.pink
//            ),
//            pageFive: VTabNavigationViewPage(
//                item: item("Orange"),
//                content: Color.orange
//            )
//        )
//    }
}
*/
