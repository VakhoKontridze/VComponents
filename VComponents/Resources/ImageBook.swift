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
    static var checkBoxOn: Image { .init(componentAsset: "CheckBox.On").renderingMode(.template) }
    static var checkBoxInterm: Image { .init(componentAsset: "CheckBox.Interm").renderingMode(.template) }
    
    static var chevronUp: Image { .init(componentAsset: "Chevron.Up").renderingMode(.template) }
    
    static var minus: Image { .init(componentAsset: "Minus").renderingMode(.template) }
    static var plus: Image { .init(componentAsset: "Plus").renderingMode(.template) }
    
    static var search: Image { .init(componentAsset: "Search").renderingMode(.template) }
    
    static var visibilityOff: Image { .init(componentAsset: "Visibility.off").renderingMode(.template) }
    static var visibilityOn: Image { .init(componentAsset: "Visibility.on").renderingMode(.template) }
    
    static var xMark: Image { .init(componentAsset: "XMark").renderingMode(.template) }
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    /// Initializes color from library's local assets library from a name.
    fileprivate init(componentAsset name: String) {
        guard
            let bundle: Bundle = .init(identifier: "com.vakhtang-kontridze.vcomponents")
        else {
            fatalError()
        }
        
        self = Image(name, bundle: bundle)
    }
}
