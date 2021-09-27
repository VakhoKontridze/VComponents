//
//  VSpinnerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Spinner Demo View
struct VSpinnerDemoView: View {
    // MARK: Properties
    static let navBarTitle: String { "Spinner" }
    
    @State private var spinnerType: VSpinnerTypeHelper = VSpinnerType.default.helpeType

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
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
private enum VSpinnerTypeHelper: Int, VPickableTitledItem {
    case continous
    case dashed
    
    var pickerTitle: String {
        switch self {
        case .continous: return "Continous"
        case .dashed: return "Dashed"
        }
    }
}

extension VSpinnerType {
    fileprivate var helpeType: VSpinnerTypeHelper {
        switch self {
        case .continous: return .continous
        case .dashed: return .dashed
        @unknown default: fatalError()
        }
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
