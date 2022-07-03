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
    func get(
        key presentingView: some View
    ) -> Any? {
        get(key: SwiftUIViewTypeDescriber.describe(presentingView))
    }
        
    func get(
        key presentingViewType: String
    ) -> Any? {
        storage[presentingViewType]
    }
    
    // MARK: Set
    func set(
        key presentingView: some View,
        value: Any
    ) {
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
