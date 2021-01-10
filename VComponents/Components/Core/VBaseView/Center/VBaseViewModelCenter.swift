//
//  VBaseViewModelCenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Base View Model Center
public struct VBaseViewModelCenter {
    public var layout: Layout = .init()
    public var titleColor: Color = ColorBook.primary
    public var font: Font = .system(size: 17, weight: .semibold, design: .default)
    
    public init() {}
}

// MARK:- Layout
extension VBaseViewModelCenter {
    public struct Layout {
        public var margin: CGFloat = 16
        public var spacing: CGFloat = 10
        var width: CGFloat { UIScreen.main.bounds.width - 2 * margin }

        public init() {}
    }
}
