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
}

// MARK:- Body
extension VSpinnerDemoView {
    var body: some View {
        BaseDemoView(title: Self.navigationBarTitle, content: {
            DemoRowView(type: .titled("Continous"), content: {
                VSpinner(type: .continous())
            })
            
            DemoRowView(type: .titled("Dashed"), content: {
                VSpinner(type: .dashed())
            })
        })
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
