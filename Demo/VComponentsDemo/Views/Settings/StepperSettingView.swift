//
//  StepperSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI
import VComponents

// MARK: - Stepper Setting View
struct StepperSettingView: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let range: ClosedRange<Int>
    @Binding private var value: Int
    
    private let title: String
    private let description: String?
    
    // MARK: Initializers
    init(
        range: ClosedRange<Int>,
        value: Binding<Int>,
        title: String,
        description: String? = nil
    ) {
        self.range = range
        self._value = value
        self.title = title
        self.description = description
    }

    // MARK: Body
    var body: some View {
        HStack(spacing: 0, content: {
            VStack(alignment: .leading, spacing: 3, content: {
                if !title.isEmpty {
                    VText(
                        color: isEnabled ? ColorBook.primary : ColorBook.primaryPressedDisabled,
                        font: .callout,
                        text: title
                    )
                }
                
                if let description = description, !description.isEmpty {
                    VText(
                        type: .multiLine(alignment: .leading, lineLimit: nil),
                        color: isEnabled ? ColorBook.secondary : ColorBook.secondaryPressedDisabled,
                        font: .footnote,
                        text: description
                    )
                }
            })
            
            Spacer()
            
            VStepper(range: range, value: $value)
        })
    }
}

// MARK: - Preview
struct StepperSettingView_Previews: PreviewProvider {
    static var previews: some View {
        StepperSettingView(range: 1...10, value: .constant(5), title: "Lorem ipsum dolor sit amet")
    }
}
