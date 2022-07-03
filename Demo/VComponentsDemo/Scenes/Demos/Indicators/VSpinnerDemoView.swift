//
//  VSpinnerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Spinner Demo View
struct VSpinnerDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Spinner" }
    
    @State private var spinnerType: VSpinnerTypeHelper = .continous

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    @ViewBuilder private func component() -> some View {
        switch spinnerType {
        case .continous: VSpinner(type: .continous())
        case .dashed: VSpinner(type: .dashed())
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $spinnerType, headerTitle: "Type")
    }
}

// MARK: - Helpers
private enum VSpinnerTypeHelper: Int, StringRepresentableHashableEnumeration {
    case continous
    case dashed
    
    var stringRepresentation: String {
        switch self {
        case .continous: return "Continous"
        case .dashed: return "Dashed"
        }
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
