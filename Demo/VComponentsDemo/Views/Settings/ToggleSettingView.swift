//
//  ToggleSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VComponents

// MARK: - Toggle Setting View
struct ToggleSettingView: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var isOn: Bool
    
    private let title: String
    private let description: String?
    
    // MARK: Initailizers
    init(
        isOn: Binding<Bool>,
        title: String,
        description: String? = nil
    ) {
        self._isOn = isOn
        self.title = title
        self.description = description
    }

    // MARK: Body
    var body: some View {
        HStack(spacing: 0, content: {
            VStack(alignment: .leading, spacing: 3, content: {
                if !title.isEmpty {
                    VText(
                        color: isEnabled ? ColorBook.primary : .init(componentAsset: "Primary.presseddisabled"), // Not exposing API
                        font: .callout,
                        title: title
                    )
                }
                
                if let description = description, !description.isEmpty {
                    VText(
                        type: .multiLine(alignment: .leading, lineLimit: nil),
                        color: isEnabled ? ColorBook.secondary : .init(componentAsset: "Secondary.presseddisabled"), // Not exposing API
                        font: .footnote,
                        title: description
                    )
                }
            })
            
            Spacer()
            
            VToggle(isOn: $isOn)
        })
    }
}

// MARK: - Preview
struct ToggleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSettingView(isOn: .constant(true), title: "Lorem ipsum dolor sit amet")
    }
}
