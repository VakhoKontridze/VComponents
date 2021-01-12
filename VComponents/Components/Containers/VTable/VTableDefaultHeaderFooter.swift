//
//  VTableDefaultHeaderFooter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Default Header Footer
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
        VBaseText(
            title: title,
            color: VTableModel.Colors.defaultHeaderFooter,
            font: VTableModel.defaultHeaderFooterFont,
            alignment: .leading
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
