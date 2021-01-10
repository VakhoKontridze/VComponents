//
//  VTableDefaultHeaderFooter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Default Header Footer
public struct VTableDefaultHeaderFooter<S>: View where S: StringProtocol {
    // MARK: Proeprties
    private let title: S
    
    // MARK: Initializers
    public init(title: S) {
        self.title = title
    }
}

// MARK:- Body
public extension VTableDefaultHeaderFooter {
    var body: some View {
        VGenericTitleContentView(
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
