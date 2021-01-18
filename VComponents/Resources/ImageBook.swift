//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- Image Book
struct ImageBook {
    private init() {}
}

// MARK:- Images
extension ImageBook {
    static let chevronUp: Image = .init(componentAsset: "Chevron.Up")
    static let xMark: Image = .init(componentAsset: "XMark")
    static let checkBoxOn: Image = .init(componentAsset: "CheckBox.On")
    static let checkBoxInterm: Image = .init(componentAsset: "CheckBox.Interm")
}

// MARK:- Helper
extension Image {
    /// Initializes color from framework's local assets folder using a name
    init(componentAsset name: String) {
        guard
            let bundle = Bundle(identifier: "com.vakhtang-kontridze.VComponents")
        else {
            preconditionFailure()
        }
        
        self = Image(name, bundle: bundle)
            .renderingMode(.template)
    }
}
