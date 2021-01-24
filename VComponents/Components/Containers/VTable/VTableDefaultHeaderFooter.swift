//
//  VTableDefaultHeaderFooter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Default Header Footer
/// View that can be used for table header and footer
public struct VTableDefaultHeaderFooter: View {
    // MARK: Proeprties
    private let title: String
    
    // MARK: Initializers
    public init(title: String) {
        self.title = title
    }
}

// MARK:- Body
extension VTableDefaultHeaderFooter {
    public var body: some View {
        VText(
            type: .oneLine,
            font: VTableModel.Fonts.headerFooter,
            color: VTableModel.Colors.defaultHeaderFooter,
            title: title
        )
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Preview
struct VTableDefaultHeaderFooter_Previews: PreviewProvider {
    static var previews: some View {
        VTable_Previews.previews
    }
}
