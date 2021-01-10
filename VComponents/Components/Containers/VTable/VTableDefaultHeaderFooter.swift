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
public extension VTableDefaultHeaderFooter {
    var body: some View {
        VGenericTextContent(
            title: title,
            color: ColorBook.secondary,
            font: .system(size: 13),
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
