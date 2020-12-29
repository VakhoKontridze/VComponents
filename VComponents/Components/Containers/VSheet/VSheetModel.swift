//
//  VSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Type Aliases
public typealias VSheetModelRoundAll = VSheetModel
public typealias VSheetModelRoundTop = VSheetModel
public typealias VSheetModelRoundBottom = VSheetModel

// MARK:- V Sheet Model
public struct VSheetModel {
    public let layout: Layout
    public let color: Color
    
    public init(
        layout: Layout = .init(),
        color: Color = ColorBook.layer
    ) {
        self.layout = layout
        self.color = color
    }
}

// MARK:- Layout
extension VSheetModel {
    public struct Layout {
        public let roundedCorners: RoundedCorners
        public let cornerRadius: CGFloat
        
        public let contentPadding: CGFloat
        
        public init(
            roundedCorners: RoundedCorners = .all,
            cornerRadius: CGFloat = 15,
            contentPadding: CGFloat = 16
        ) {
            self.roundedCorners = roundedCorners
            self.cornerRadius = cornerRadius
            self.contentPadding = contentPadding
        }
    }
}

extension VSheetModel.Layout {
    public enum RoundedCorners {
        case all
        case top
        case bottom
        case custom(_ corners: UIRectCorner)
        case none
        
        var uiRectCorner: UIRectCorner {
            switch self {
            case .all: return .allCorners
            case .top: return [.topLeft, .topRight]
            case .bottom: return [.bottomLeft, .bottomRight]
            case .custom(let customCorners): return customCorners
            case .none: return []
            }
        }
    }
}
