//
//  ToggleSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- Toggle Setting View
struct ToggleSettingView: View {
    // MARK: Properties
    @Binding var state: VToggleState
    private let title: String
    
    // MARK: Initializers
    init(state: Binding<VToggleState>, title: String) {
        self._state = state
        self.title = title
    }
}

// MARK:- Body
extension ToggleSettingView {
    var body: some View {
        VStack(content: {
            VToggle(state: $state)
            
            Text(title)
                .font(.footnote)
        })
    }
}

// MARK:- Preview
struct ToggleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSettingView(state: .constant(.on), title: "Title")
    }
}
