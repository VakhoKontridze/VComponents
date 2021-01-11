//
//  VAccordionDefaultHeader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion Default Header
public struct VAccordionDefaultHeader: View {
    // MARK: Proeprties
    private let title: String
    
    // MARK: Initializers
    public init(title: String) {
        self.title = title
    }
}

// MARK:- Body
public extension VAccordionDefaultHeader {
    var body: some View {
        VGenericTextContent(
            title: title,
            color: VAccordionModel.Colors.defaultHeader,
            font: VAccordionModel.defaultHeaderFont,
            alignment: .leading
        )
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Preview
struct VAccordionDefaultHeader_Previews: PreviewProvider {
    static var previews: some View {
        VAccordion_Previews.previews
    }
}
