//
//  VModalDefaultHeader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Modal Default Header
/// View that can be used for modal header
///
/// View is aligned to the leading edge
public struct VModalDefaultHeader: View {
    // MARK: Proeprties
    private let title: String
    
    // MARK: Initializers
    public init(title: String) {
        self.title = title
    }
}

// MARK:- Body
extension VModalDefaultHeader {
    public var body: some View {
        VText(
            title: title,
            color: VModalModel.Colors.defaultHeader,
            font: VModalModel.defaultHeaderFont,
            type: .oneLine
        )
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Preview
struct VModalDefaultHeader_Previews: PreviewProvider {
    static var previews: some View {
        VModal_Previews.previews
    }
}
