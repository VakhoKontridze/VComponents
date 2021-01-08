//
//  GenericButtonContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- Generic Button Content View
struct GenericButtonContentView<Content>: View where Content: View {
    // MARK: Properties
    private let foregroundColor: Color
    private let foregroundOpacity: Double
    private let font: Font
    
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        foregroundColor: Color,
        foregroundOpacity: Double,
        font: Font,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.foregroundColor = foregroundColor
        self.foregroundOpacity = foregroundOpacity
        self.font = font
        self.content = content
    }
}

// MARK:- Body
extension GenericButtonContentView {
    @ViewBuilder var body: some View {
        content()
            // Text
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .foregroundColor(foregroundColor)
            .font(font)
        
            // Text + Image
            .opacity(foregroundOpacity)
    }
}

//// MARK:- Preview
//struct GenericButtonContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericButtonContentView(
//            foregroundColor: VPrimaryButtonModel.Colors().foreground.enabled,
//            foregroundOpacity: VPrimaryButtonModel.Colors().foreground.pressedOpacity,
//            font: VPrimaryButtonModel().font,
//            content: { Text("Press") }
//        )
//    }
//}
