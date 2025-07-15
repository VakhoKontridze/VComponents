//
//  Preview_ModalPresenterRootAndLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 30.05.25.
//

#if DEBUG

import Foundation
import VCore

// MARK: - Modal Presenter Root and Link
enum Preview_ModalPresenterRootAndLink {
    // MARK: Cases
    case overlay
    case window
    
    // MARK: Mapping
    var root: ModalPresenterRoot {
        switch self {
        case .overlay:
            return .overlay()
            
        case .window:
#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))
            return .window()
#else
            fatalError() // Not supported
#endif
        }
    }
    
    func link(
        linkID: String
    ) -> ModalPresenterLink {
        switch self {
        case .overlay:
            return .overlay(linkID: linkID)
        
        case .window:
#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))
            return .window(linkID: linkID)
#else
            fatalError() // Not supported
#endif
        }
    }
}

#endif
