//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - Image Book
struct ImageBook {
    private init() {}
}

// MARK: - Images
extension ImageBook {
    static let checkBoxOn: Image = .init(componentAsset: "CheckBox.On")
    static let checkBoxInterm: Image = .init(componentAsset: "CheckBox.Interm")
    
    static let chevronUp: Image = .init(componentAsset: "Chevron.Up")
    
    static let minus: Image = .init(componentAsset: "Minus")
    static let plus: Image = .init(componentAsset: "Plus")
    
    static let search: Image = .init(componentAsset: "Search")
    
    static let visibilityOff: Image = .init(componentAsset: "Visibility.off")
    static let visibilityOn: Image = .init(componentAsset: "Visibility.on")
    
    static let xMark: Image = .init(componentAsset: "XMark")
}

// MARK: - Helper
extension Image {
    /// Initializes color from framework's local assets folder using a name
    init(componentAsset name: String) {
        guard
            let bundle = Bundle(identifier: "com.vakhtang-kontridze.VComponents")
        else {
            fatalError()
        }
        
        self = Image(name, bundle: bundle)
            .renderingMode(.template)
    }
}
