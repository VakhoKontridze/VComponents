//
//  VAccordionDefaultHeader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion Default Header
/// View that can be used for accordion header
public struct VAccordionDefaultHeader: View {
    // MARK: Proeprties
    private let title: String
    
    // MARK: Initializers
    public init(title: String) {
        self.title = title
    }
}

// MARK:- Body
extension VAccordionDefaultHeader {
    public var body: some View {
        VBaseText(
            title: title,
            color: VAccordionModel.Colors.defaultHeader,
            font: VAccordionModel.defaultHeaderFont,
            type: .oneLine
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
