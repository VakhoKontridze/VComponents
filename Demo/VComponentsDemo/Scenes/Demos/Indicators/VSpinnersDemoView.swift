//
//  VSpinnersDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Spinners Demo View
struct VSpinnersDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Spinners (Continuous, Dashed)" }
    
    @State private var spinnerStyle: VSpinnerStyleHelper = .continuous

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    @ViewBuilder private func component() -> some View {
        switch spinnerStyle {
        case .continuous: VContinuousSpinner()
        case .dashed: VDashedSpinner()
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $spinnerStyle, headerTitle: "Style")
    }
}

// MARK: - Helpers
private enum VSpinnerStyleHelper: Int, StringRepresentableHashableEnumeration {
    case continuous
    case dashed
    
    var stringRepresentation: String {
        switch self {
        case .continuous: return "Continuous"
        case .dashed: return "Dashed"
        }
    }
}

// MARK: - Preview
struct VSpinnersDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnersDemoView()
    }
}
