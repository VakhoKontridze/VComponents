//
//  VAlertModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert Model
/// Model that describes UI
public struct VAlertModel {
    public static let modalModel: VModalModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()

    public init() {}
}

// MARK:- Layout
extension VAlertModel {
    public struct Layout {
        public var width: CGFloat = UIScreen.main.bounds.width * 0.67
        public var cornerRadius: CGFloat = 20
        
        public var margin: CGFloat = 15
        
        public var spacing: CGFloat = 20
        
        public var contentSpacing: CGFloat = 5
        public var contentMarginHor: CGFloat = 0
        public var contentMarginTop: CGFloat = 5
        
        public var twoButtonSpacing: CGFloat = 10
        public var manyButtonSpacing: CGFloat = 10

        public init() {}
    }
}

// MARK:- Colors
extension VAlertModel {
    public struct Colors {
        public var background: Color = VAlertModel.modalModel.colors.background
        public var blinding: Color = VAlertModel.modalModel.colors.blinding
        
        public var title: Color = ColorBook.primary
        public var description: Color = ColorBook.primary

        public init() {}
    }
}

// MARK:- Fonts
extension VAlertModel {
    public struct Fonts {
        public var title: Font = .system(size: 16, weight: .bold, design: .default)
        public var description: Font = .system(size: 14, weight: .regular, design: .default)
        
        public init() {}
    }
}
