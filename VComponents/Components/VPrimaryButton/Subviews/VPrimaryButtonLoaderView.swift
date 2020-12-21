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
    private let isVisible: Bool
    private let width: CGFloat
    
    // MARK: Initializers
    init(isVisible: Bool, width: CGFloat) {
        self.isVisible = isVisible
        self.width = width
    }
}

// MARK:- Body
extension VPrimaryButtonLoaderView {
    @ViewBuilder var body: some View {
        if isVisible {
            VSpinner(type: .continous).frame(width: width, alignment: .trailing)
        }
    }
}

// MARK:- Preview
struct VPrimaryButtonLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonLoaderView(isVisible: true, width: VPrimaryButtonCompactViewModel.Layout().loaderWidth)
    }
}
