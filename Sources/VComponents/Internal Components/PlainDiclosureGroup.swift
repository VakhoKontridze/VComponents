//
//  File.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.05.22.
//

import SwiftUI

// MARK: - Plain Disclosure Group
struct PlainDiclosureGroup<Label, Content>: View
    where
        Label: View,
        Content: View
{
    // MARK: Properties
    private let backgroundColor: Color
    
    @Binding private var isExpanded: Bool
    
    private let label: () -> Label
    private let content: () -> Content
    
    @State private var labelHeight: CGFloat = 0
    
    // MARK: Initializers
    init(
        backgroundColor: Color,
        isExpanded: Binding<Bool>,
        label: @escaping () -> Label,
        content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self._isExpanded = isExpanded
        self.label = label
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        ZStack(alignment: .top, content: {
            labelView
            
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: content,
                label: { Color.clear.frame(height: max(0, labelHeight - 8)) } // Default padding in `DisclosureGroup`
            )
                .buttonStyle(.plain).accentColor(.clear) // Hides chevron button
        })
    }
    
    private var labelView: some View {
        label()
            .frame(maxWidth: .infinity)
            .readSize(onChange: { labelHeight = $0.height })
            .background(
                backgroundColor
                    .contentShape(Rectangle())
                    .onTapGesture(perform: { isExpanded.toggle() })
            )
    }
}
