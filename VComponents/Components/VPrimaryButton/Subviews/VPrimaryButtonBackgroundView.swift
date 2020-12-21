//
//  VPrimaryButtonBackgroundView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Background View
struct VPrimaryButtonBackgroundView: View {
    // MARK: Properties
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let fillColor: Color
    private let borderColor: Color
    
    // MARK: Properties
    init(cornerRadius: CGFloat, borderWidth: CGFloat, fillColor: Color, borderColor: Color) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.fillColor = fillColor
        self.borderColor = borderColor
    }
}

// MARK:- Body
extension VPrimaryButtonBackgroundView {
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(borderColor, lineWidth: borderWidth)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(fillColor)
            )
    }
}

// MARK:- Preview
struct VPrimaryButtonBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonBackgroundView(
            cornerRadius: VPrimaryButtonCompactModel.Layout().cornerRadius,
            borderWidth: VPrimaryButtonCompactModel.Layout().borderWidth,
            fillColor: VPrimaryButtonCompactModel.Colors.FillColors().enabled,
            borderColor: VPrimaryButtonCompactModel.Colors.BorderColors().enabled
        )
    }
}
