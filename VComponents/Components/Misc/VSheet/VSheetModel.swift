//
//  VSheetModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Sheet Model
/// Model that describes UI.
public struct VSheetModel {
    // MARK: Properties
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Rounded corners of VSheet. Defaults to to `default`.
        public var roundedCorners: RoundedCorners = .default
        
        /// Corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Content margin. Defaults to `10`.
        public var contentMargin: CGFloat = 10
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Rounded Corners
        /// Enum that describes rounded corners, such as all, `top`, `bottom`, `custom`, or `none`.
        public enum RoundedCorners {
            // MARK: Cases
            /// All.
            case all
            
            /// Top.
            case top
            
            /// Bottom.
            case bottom
            
            /// Custom.
            case custom(_ corners: UIRectCorner)
            
            /// None.
            case none
            
            /// Default value. Set to `all`.
            public static var `default`: Self { .all }
            
            // MARK: Properties
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

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
}
