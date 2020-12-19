//
//  VSpinnerDemoView.swift
//  Demo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Spinner Demo View
struct VSpinnerDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Spinner"
}

// MARK:- Body
extension VSpinnerDemoView {
    var body: some View {
        ScrollView(content: {
            LazyVStack(content: {
                ForEach(VSpinnerType.allCases, id: \.self, content: { type in
                    RowView(title: type.description, titleColor: .white, content: {
                        VSpinner(type: type, viewModel: .init())
                    })
                })
            })
        })
            .navigationTitle(Self.sceneTitle)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK:- Descriptions
private extension VSpinnerType {
    var description: String {
        switch self {
        case .dashed: return "Dashed"
        case .continous: return "Continous"
        }
    }
}

// MARK: Preview
struct VSpinnerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSpinnerDemoView()
    }
}
