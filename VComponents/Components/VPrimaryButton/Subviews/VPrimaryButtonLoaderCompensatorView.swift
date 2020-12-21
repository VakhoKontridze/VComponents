//
//  VPrimaryButtonLoaderCompensatorView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Primary Button Loader Compensator View
struct VPrimaryButtonLoaderCompensatorView: View {
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
extension VPrimaryButtonLoaderCompensatorView {
    @ViewBuilder var body: some View {
        if isVisible {
            Spacer().frame(width: width, alignment: .leading)
        }
    }
}

// MARK:- Preview
struct VPrimaryButtonLoaderCompensatorView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonLoaderCompensatorView(isVisible: true, width: VPrimaryButtonCompactViewModel.Layout().loaderWidth)
    }
}
