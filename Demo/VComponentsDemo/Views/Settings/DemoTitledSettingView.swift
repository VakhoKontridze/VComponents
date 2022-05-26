//
//  DemoTitledSettingView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI
import VComponents

// MARK: - Demo Titled Setting View
struct DemoTitledSettingView<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.isEnabled) var isEnabled: Bool
    
    private let title: String
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
    
    init(
        value: Double,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = .init(format: "%.2f", value)
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 10, content: {
            content()
            sliderTextView
        })
    }
    
    private var sliderTextView: some View {
         VText(
            color: isEnabled ? ColorBook.primary : ColorBook.primaryPressedDisabled,
            font: .system(size: 14, weight: .regular, design: .monospaced),
            text: title
        )
    }
}
