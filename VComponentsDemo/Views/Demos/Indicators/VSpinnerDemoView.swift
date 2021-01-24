//
//  VSpinnerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Spinner Demo View
struct VSpinnerDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Spinner"
    
    @State private var spinnerModel: VSpinnerModelHelper = VSpinnerModel.default.helperModel
}

// MARK:- Body
extension VSpinnerDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch spinnerModel {
        case .continous: VSpinner(model: .continous())
        case .dashed: VSpinner(model: .dashed())
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $spinnerModel, header: "Type")
    }
}

// MARK:- Helpers
private enum VSpinnerModelHelper: Int, VPickableTitledItem {
    case continous
    case dashed
    
    var pickerTitle: String {
        switch self {
        case .continous: return "Continous"
        case .dashed: return "Dashed"
        }
    }
}

private extension VSpinnerModel {
    var helperModel: VSpinnerModelHelper {
        switch self {
        case .continous: return .continous
        case .dashed: return .dashed
        }
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
