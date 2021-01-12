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
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, content: {
                DemoRowView(type: .titled("Continous"), content: {
                    VSpinner(model: .continous())
                })
                
                DemoRowView(type: .titled("Dashed"), content: {
                    VSpinner(model: .dashed())
                })
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
