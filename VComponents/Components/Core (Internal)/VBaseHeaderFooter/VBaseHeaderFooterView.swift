//
//  VBaseHeaderFooterView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/25/21.
//

import SwiftUI

// MARK:- V Base Header Footer
struct VBaseHeaderFooter: View {
    // MARK: Proeprties
    private let frameType: VBaseHeaderFooterFrameType
    private let textType: VTextType = .oneLine
    private let font: Font
    private let color: Color
    private let title: String
    
    // MARK: Initializers
    init(
        frameType: VBaseHeaderFooterFrameType,
        font: Font,
        color: Color,
        title: String
    ) {
        self.frameType = frameType
        self.font = font
        self.color = color
        self.title = title
    }
}

// MARK:- Body
extension VBaseHeaderFooter {
    @ViewBuilder var body: some View {
        switch frameType {
        case .auto: contentView
        case .flex(let alignment): contentView.frame(maxWidth: .infinity, alignment: alignment.asAlignment)
        }
    }
    
    private var contentView: some View {
        VText(
            type: textType,
            font: font,
            color: color,
            title: title
        )
    }
}

// MARK:- Preview
struct VBaseHeaderFooter_Previews: PreviewProvider {
    static var previews: some View {
        VTable_Previews.previews
    }
}
