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
    init(state: Binding<Bool>, title: String) {
        self._state = .init(bool: state)
        self.title = title
    }
}

// MARK:- Body
extension ToggleSettingView {
    var body: some View {
        VStack(content: {
            VToggle(state: $state)
            
            VBaseTitle(
                title: title,
                color: ColorBook.primary,
                font: .footnote,
                type: .oneLine
            )
        })
    }
}

// MARK:- Preview
struct ToggleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSettingView(state: .constant(true), title: "Title")
    }
}
