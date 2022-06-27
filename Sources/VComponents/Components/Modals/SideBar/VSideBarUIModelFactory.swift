//
//  VSideBarUIModelFactory.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.06.22.
//

import SwiftUI

// MARK: - Factory
extension VSideBarUIModel.Layout.PresentationEdge {
    /// UI model for the presentation edge.
    public var uiModel: VSideBarUIModel {
        switch self {
        case .left: return .left
        case .right: return .right
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

extension VSideBarUIModel {
    /// Model that represents side bar from left.
    ///
    /// Default configuration.
    public static var left: VSideBarUIModel {
        .init()
    }
    
    /// Model that represents side bar from right.
    ///
    /// `roundedCorners` is set to `leftCorners`.
    ///
    /// Sets `roundedCorners` to `leftCorners`.
    public static var right: VSideBarUIModel {
        var uiModel: VSideBarUIModel = .init()
        
        uiModel.layout.presentationEdge = .right
        
        uiModel.layout.roundedCorners = .leftCorners
        
        return uiModel
    }
    
    /// Model that represents side bar from top.
    ///
    /// `presentationEdge` is set to `top`.
    ///
    /// `sizes` are set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
    /// And to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
    ///
    /// `roundedCorners` is set to `bottomCorners`.
    ///
    /// `contentMargins.bottom` is set to `25`.
    ///
    /// `contentSafeAreaEdges` is set to all but `bottom`.
    public static var top: VSideBarUIModel {
        var uiModel: VSideBarUIModel = .init()
        
        uiModel.layout.presentationEdge = .top
        
        uiModel.layout.sizes = .init(
            portrait: .fraction(.init(width: 1, height: 0.5)),
            landscape: .fraction(.init(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .bottomCorners
        
        uiModel.layout.contentMargins.bottom = 25
        uiModel.layout.contentSafeAreaEdges = .all.subtracting(.bottom)
        
        return uiModel
    }
    
    /// Model that represents side bar from bottom.
    ///
    /// `presentationEdge` is set to `bottom`.
    ///
    /// `sizes` are set to `0.75` ratio of screen width and `1` ratio of screen height in portrait.
    /// And to`0.5` ratio of screen width and `1` ratio of screen height in landscape.
    ///
    /// `roundedCorners` is set to `topCorners`.
    ///
    /// `contentMargins.top` is set to `25`.
    ///
    /// `contentSafeAreaEdges` is set to all but `top`.
    public static var bottom: VSideBarUIModel {
        var uiModel: VSideBarUIModel = .init()
        
        uiModel.layout.presentationEdge = .bottom
        
        uiModel.layout.sizes = .init(
            portrait: .fraction(.init(width: 1, height: 0.5)),
            landscape: .fraction(.init(width: 1, height: 0.75))
        )
        
        uiModel.layout.roundedCorners = .topCorners
        
        uiModel.layout.contentMargins.top = 25
        uiModel.layout.contentSafeAreaEdges = .all.subtracting(.top)
        
        return uiModel
    }
}
