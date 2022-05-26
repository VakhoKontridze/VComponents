//
//  HorizontallyLabeledDemoTitledSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI
import VComponents

// MARK: - Horizontally Labeled Demo Titled Setting View
struct HorizontallyLabeledDemoTitledSettingView<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.isEnabled) var isEnabled: Bool
    
    private let value: Double
    private let min: Double
    private let max: Double
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        value: Double,
        min: Double,
        max: Double,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.value = value
        self.min = min
        self.max = max
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        DemoTitledSettingView(
            value: value,
            content: {
            HStack(spacing: 10, content: {
                sliderTextView(.init(format: "%.2f", min))
                content()
                sliderTextView(.init(format: "%.2f", max))
            })
        })
    }
    
    private func sliderTextView(_ title: String) -> some View {
         VText(
            color: isEnabled ? ColorBook.primary : ColorBook.primaryPressedDisabled,
            font: .system(size: 14, weight: .regular, design: .monospaced),
            text: title
        )
    }
}
