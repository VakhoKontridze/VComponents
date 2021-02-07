//
//  VDialogModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Dialog Model
/// Model that describes UI
public struct VDialogModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()

    public init() {}
}

// MARK:- Layout
extension VDialogModel {
    public struct Layout {
        public var width: CGFloat = UIScreen.main.bounds.width * 0.75
        public var cornerRadius: CGFloat = 20
        
        public var margin: CGFloat = 15
        public var titlesAndContentSpacing: CGFloat = 5
        public var titlesAndContentMarginHor: CGFloat = 0
        public var titlesAndContentMarginVer: CGFloat = 5
        public var contentMarginVer: CGFloat = 15
        
        public var twoButtonSpacing: CGFloat = 10
        public var manyButtonSpacing: CGFloat = 10
        
        public var descriptionLineLimit: Int = 5

        public init() {}
    }
}

// MARK:- Colors
extension VDialogModel {
    public struct Colors {
        public var background: Color = modalReference.colors.background
        public var blinding: Color = modalReference.colors.blinding
        
        public var title: Color = ColorBook.primary
        public var description: Color = ColorBook.primary

        public init() {}
    }
}

// MARK:- Fonts
extension VDialogModel {
    public struct Fonts {
        public var title: Font = .system(size: 16, weight: .bold)
        public var description: Font = .system(size: 14)
        
        public init() {}
    }
}

// MARK:- Animations
extension VDialogModel {
    public typealias Animations = VModalModel.Animations
}

// MARK:- Misc
extension VDialogModel {
    public struct Misc {
        public var ignoredKeybordSafeAreaEdges: Edge.Set = []
        
        public init() {}
    }
}

// MARK:- References
extension VDialogModel {
    public static let modalReference: VModalModel = .init()
}
