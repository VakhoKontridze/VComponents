//
//  StepperSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/5/21.
//

import SwiftUI
import VComponents

// MARK: Stepepr Setting View
struct StepperSettingView: View {
    // MARK: Properties
    private let range: ClosedRange<Int>
    @Binding private var value: Int
    
    private let title: String
    private let description: String?
    
    // MARK: Initailizers
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
                        color: ColorBook.primary,
                        font: .callout,
                        title: title
                    )
                }
                
                if let description = description, !description.isEmpty {
                    VText(
                        type: .multiLine(alignment: .leading, limit: nil),
                        color: ColorBook.secondary,
                        font: .footnote,
                        title: description
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
