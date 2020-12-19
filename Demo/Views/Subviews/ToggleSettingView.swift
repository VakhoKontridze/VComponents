//
//  ToggleSettingView.swift
//  Demo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Toggle Setting View
struct ToggleSettingView: View {
    // MARK: Properties
    @Binding var isOn: Bool
    private let title: String
    
    // MARK: Initializers
    init(isOn: Binding<Bool>, title: String) {
        self._isOn = isOn
        self.title = title
    }
}

// MARK:- Body
extension ToggleSettingView {
    var body: some View {
        VStack(content: {
            Toggle("",isOn: $isOn)
                .labelsHidden()
                
            Text(title)
                .font(.system(size: 12))
        })
    }
}

// MARK:- Preview
private struct ToggleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSettingView(isOn: .constant(true), title: "Title")
    }
}
