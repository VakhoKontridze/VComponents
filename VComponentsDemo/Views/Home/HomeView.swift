//
//  HomeView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents



// ----------------



protocol DemoableRow: Identifiable, RawRepresentable, CaseIterable where RawValue == Int {
    var title: String { get }
    
    associatedtype Content: View
    var body: Content { get }
}

extension DemoableRow {
    var id: Int { rawValue }
}


// ----------------



struct DemoSection<Row>: Identifiable where Row: DemoableRow {
    let id: Int
    let title: String?
    let rows: [Row]
}



// ----------------



enum HomeRow: Int, DemoableRow {
    case primaryButton, secondaryButton, squareButton, chevronButton, plainButton
    case toggle, segmentedPicker, slider
    case spinner
    case sheet, table, section
    case tabNavigationView, navigationView
    case sideBar, alert
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
            
        case .spinner: return VSpinnerDemoView.navigationBarTitle
            
        case .sheet: return VSheetDemoView.navigationBarTitle
        case .table: return VTableDemoView.navigationBarTitle
        case .section: return VSectionDemoView.navigationBarTitle
            
        case .tabNavigationView: return VTabNavigationViewDemoView.navigationBarTitle
        case .navigationView: return VNavigationViewDemoView.navigationBarTitle
            
        case .sideBar: return VSideBarDemoView.navigationBarTitle
        case .alert: return VAlertDemoView.navigationBarTitle
            
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
            
        case .spinner: VSpinnerDemoView()
            
        case .sheet: VSheetDemoView()
        case .table: VTableDemoView()
        case .section: VSectionDemoView()
            
        case .tabNavigationView: VTabNavigationViewDemoView()
        case .navigationView: VNavigationViewDemoView()
            
        case .sideBar: VSideBarDemoView()
        case .alert: VAlertDemoView()
            
        case .interactiveView: VInteractiveViewDemoView()
        case .baseView: VBaseViewDemoView()
        case .lazyList: VLazyListDemoView()
        }
    }
}


// ----------------


















// MARK:- Home View
struct HomeView: View {
    // MARK: Properties
    private static let navigationBarTitle: String = "VComponents Demo"

    let sections: [DemoSection<HomeRow>] = [
        .init(id: 0, title: "Buttons", rows: [.primaryButton, .secondaryButton, .squareButton, .plainButton, .chevronButton]),
        .init(id: 1, title: "Pickers", rows: [.toggle, .segmentedPicker, .slider]),
        .init(id: 2, title: "Misc", rows: [.spinner]),
        .init(id: 3, title: "Containers", rows: [.sheet, .table, .section]),
        .init(id: 4, title: "Navigation", rows: [.tabNavigationView, .navigationView]),
        .init(id: 5, title: "Modals", rows: [.sideBar, .alert]),
        .init(id: 6, title: "Core", rows: [.interactiveView, .baseView, .lazyList])
    ]
}

// MARK:- Body
extension HomeView {
    var body: some View {
        VNavigationView(content: {
            DemoListView(title: Self.navigationBarTitle, sections: sections)
        })
    }
}

// MARK:- Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
