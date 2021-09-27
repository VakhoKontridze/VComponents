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
    static var checkBoxOn: Image { .init(componentAsset: "CheckBox.On") }
    static var checkBoxInterm: Image { .init(componentAsset: "CheckBox.Interm") }
    
    static var chevronUp: Image { .init(componentAsset: "Chevron.Up") }
    
    static var minus: Image { .init(componentAsset: "Minus") }
    static var plus: Image { .init(componentAsset: "Plus") }
    
    static var search: Image { .init(componentAsset: "Search") }
    
    static var visibilityOff: Image { .init(componentAsset: "Visibility.off") }
    static var visibilityOn: Image { .init(componentAsset: "Visibility.on") }
    
    static var xMark: Image { .init(componentAsset: "XMark") }
    
    // MARK: Initializers
    private init() {}
}

// MARK: - Helpers
extension Image {
    /// Initializes color from framework's local assets library from a name
    init(componentAsset name: String) {
        guard
            let bundle: Bundle = .init(identifier: "com.vakhtang-kontridze.VComponents")
        else {
            fatalError()
        }
        
        self = Image(name, bundle: bundle)
            .renderingMode(.template)
    }
}
