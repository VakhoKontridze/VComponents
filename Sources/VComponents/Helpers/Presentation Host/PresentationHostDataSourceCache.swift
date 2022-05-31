//
//  PresentationHostDataSourceCache.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - Presentation Host Data Source Cache
final class PresentationHostDataSourceCache {
    // MARK: Properties
    static let shared: PresentationHostDataSourceCache = .init()
    
    private var storage: [String: Any] = [:]
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Get
    func get<PresentingView>(
        key presentingView: PresentingView
    ) -> Any?
        where PresentingView: View
    {
        get(key: SwiftUIViewTypeDescriber.describe(presentingView))
    }
        
    func get(
        key presentingViewType: String
    ) -> Any? {
        storage[presentingViewType]
    }
    
    // MARK: Set
    func set<PresentingView>(
        key presentingView: PresentingView,
        value: Any
    )
        where PresentingView: View
    {
        set(
            key: SwiftUIViewTypeDescriber.describe(presentingView),
            value: value
        )
    }
    
    func set(
        key presentingViewType: String,
        value: Any
    ) {
        storage[presentingViewType] = value
    }
    
    // MARK: Remove
    func remove(key presentingViewType: String) {
        for key in storage.keys {
            if key.hasPrefix(presentingViewType) {
                storage[key] = nil
            }
        }
    }
}
