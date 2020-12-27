//
//  VPrimaryButtonLoaderView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Loader View
struct VPrimaryButtonLoaderView: View {
    // MARK: Properties
    private let spinnerModel: VSpinnerModelContinous
    private let width: CGFloat
    private let isVisible: Bool
    
    // MARK: Initializers
    init(loaderColor: Color, width: CGFloat, isVisible: Bool) {
        self.spinnerModel = .init(
            colors: .init(
                spinner: loaderColor
            )
        )
        self.width = width
        self.isVisible = isVisible
    }
}

// MARK:- Body
extension VPrimaryButtonLoaderView {
    @ViewBuilder var body: some View {
        if isVisible {
            VSpinner(type: .continous(spinnerModel)).frame(width: width, alignment: .trailing)
        }
    }
}

// MARK:- Preview
struct VPrimaryButtonLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonLoaderView(
            loaderColor: ColorBook.PrimaryButtonFilled.Foreground.enabled,
            width: VPrimaryButtonModelFilled.Layout().loaderWidth,
            isVisible: true
        )
    }
}
