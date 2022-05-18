//
//  ImageBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK: - Image Book
struct ImageBook {
    // MARK: Properties
    static var checkBoxOn: Image { .init(templateComponentAsset: "CheckBox.On") }
    static var checkBoxInterm: Image { .init(templateComponentAsset: "CheckBox.Interm") }
    
    static var chevronUp: Image { .init(templateComponentAsset: "Chevron.Up") }
    
    static var minus: Image { .init(templateComponentAsset: "Minus") }
    static var plus: Image { .init(templateComponentAsset: "Plus") }
    
    static var search: Image { .init(templateComponentAsset: "Search") }
    
    static var visibilityOff: Image { .init(templateComponentAsset: "Visibility.off") }
    static var visibilityOn: Image { .init(templateComponentAsset: "Visibility.on") }
    
    static var xMark: Image { .init(templateComponentAsset: "XMark") }
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    fileprivate init(componentAsset name: String) {
        self = Image(name, bundle: .module)
    }
    
    fileprivate init(templateComponentAsset name: String) {
        self = .init(componentAsset: name).renderingMode(.template)
    }
}
