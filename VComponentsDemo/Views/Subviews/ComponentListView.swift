//
//  ComponentListView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Component List View
struct ComponentListView<Content>: View where Content: View {
    // MARK: Properties
    private let content: () -> Content
    
    // MARK: Initalizers
    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
}

// MARK:- Body
extension ComponentListView {
    var body: some View {
        VLazyList(content: content)
            .background(VComponents.ColorBook.canvas)
            .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
    }
}

// MARK:- Preview
struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentListView(content: {
            Text("A")
            Text("B")
        })
    }
}
