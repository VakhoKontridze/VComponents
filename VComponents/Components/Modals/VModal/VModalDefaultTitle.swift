//
//  VModalDefaultTitle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Modal Default Title
public struct VModalDefaultTitle: View {
    // MARK: Proeprties
    private let title: String
    
    // MARK: Initializers
    public init(title: String) {
        self.title = title
    }
}

// MARK:- Body
extension VModalDefaultTitle {
    public var body: some View {
        VBaseTitle(
            title: title,
            color: VModalModel.Colors.defaultHeader,
            font: VModalModel.defaultHeaderFont,
            type: .oneLine
        )
    }
}

// MARK:- Preview
struct VModalDefaultTitle_Previews: PreviewProvider {
    static var previews: some View {
        VModal_Previews.previews
    }
}
