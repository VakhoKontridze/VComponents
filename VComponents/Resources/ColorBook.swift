//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Color Book
public struct ColorBook {
    public static let canvas: Color = .init(componentAsset: "Canvas")
    public static let layer: Color = .init(componentAsset: "Layer")
    
    public static let primary: Color = .init(componentAsset: "Primary")
    public static let primaryInverted: Color = .init(componentAsset: "PrimaryInverted")
    
    public static let secondary: Color = .init(componentAsset: "Secondary")
    
    public static let accent: Color = .init(componentAsset: "Accent")
    
    private init() {}
}

// MARK:- Helper
public extension Color {
    init(componentAsset name: String) {
        guard
            let bundle = Bundle(identifier: "com.vakhtang-kontridze.VComponents"),
            let uiColor = UIColor(named: name, in: bundle, compatibleWith: nil)
        else {
            preconditionFailure()
        }
        
        self.init(uiColor)
    }
}






// MARK:- Sheet
extension ColorBook {
    public struct Sheet {
        public static let background: Color = ColorBook.layer
        
        private init() {}
    }
    
    public struct SheetCustom {
        public static let background: Color = Sheet.background
        
        private init() {}
    }
}

// MARK:- Tab Navigation View
extension ColorBook {
    public struct TabNavigationViewStandard {
        public static let background: Color = ColorBook.canvas
        public static let item: Color = ColorBook.secondary
        public static let itemSelected: Color = ColorBook.accent
        
        private init() {}
    }
}

// MARK:- Navigation View
extension ColorBook {
    public struct NavigationView {
        public static let background: Color = ColorBook.canvas
        
        private init() {}
    }
}

// MARK:- Side Bar
extension ColorBook {
    public struct SideBarStandard {
        public static let background: Color = ColorBook.Sheet.background
        public static let blinding: Color = .init(componentAsset: "SideBarStandard.Blinding")
        
        private init() {}
    }
}
