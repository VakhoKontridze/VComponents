//
//  ToggleSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VComponents

// MARK:- Toggle Setting View
struct ToggleSettingView: View {
    // MARK: Properties
    @Binding private var isOn: Bool
    private let title: String
    
    // MARK: Initailizers
    init(isOn: Binding<Bool>, title: String) {
        self._isOn = isOn
        self.title = title
    }
}

// MARK:- Body
extension ToggleSettingView {
    var body: some View {
        HStack(spacing: 0, content: {
            VBaseTitle(title: title, color: ColorBook.primary, font: .callout, type: .oneLine)
            Spacer()
            VToggle(isOn: $isOn)
        })
    }
}

// MARK:- Preview
struct ToggleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSettingView(isOn: .constant(true), title: "Lorem ipsum dolor sit amet")
    }
}
