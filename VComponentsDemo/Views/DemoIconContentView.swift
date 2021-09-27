//
//  DemoIconContentView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VComponents

// MARK: - Demo Icon Content View
struct DemoIconContentView: View {
    // MARK: Properties
    private let dimension: CGFloat
    private let color: Color
    
    // MARK: Initializers
    init(dimension: CGFloat = 15, color: Color = ColorBook.accent) {
        self.dimension = dimension
        self.color = color
    }

    // MARK: Body
    var body: some View {
        Image(systemName: "swift")
            .resizable()
            .frame(dimension: dimension)
            .foregroundColor(color)
    }
}

// MARK: - Preview
struct DemoIconContentView_Previews: PreviewProvider {
    static var previews: some View {
        DemoIconContentView()
    }
}
