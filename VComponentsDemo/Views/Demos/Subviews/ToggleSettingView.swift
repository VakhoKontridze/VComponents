//
//  ToggleSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI
import VComponents

// MARK:- Toggle Setting View
struct ToggleSettingView<Content>: View where Content: View {
    // MARK: Properties
    @Binding private var isOn: Bool
    private let content: () -> Content
    
    // MARK: Initailizers
    init(
        isOn: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOn = isOn
        self.content = content
    }
    
    init(
        isOn: Binding<Bool>,
        title: String
    )
        where Content == VText
    {
        self._isOn = isOn
        self.content = { VText(title: title, color: ColorBook.primary, font: .callout, type: .oneLine) }
    }
    
    init(
        isOn: Binding<Bool>,
        title: String,
        description: String
    )
        where Content == VStack<TupleView<(VText, VText)>>
    {
        self._isOn = isOn
        self.content = {
            VStack(alignment: .leading, spacing: 3, content: {
                VText(
                    title: title,
                    color: ColorBook.primary,
                    font: .callout,
                    type: .oneLine
                )
                
                VText(
                    title: description,
                    color: ColorBook.secondary,
                    font: .footnote,
                    type: .multiLine(limit: nil, alignment: .leading)
                )
            })
        }
    }
}

// MARK:- Body
extension ToggleSettingView {
    var body: some View {
        HStack(spacing: 0, content: {
            content()
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
