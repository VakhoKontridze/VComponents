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
    
    // MARK: Get and Set
    func get(key: String) -> Any? {
        storage[key]
    }
    
    func set(key: String, value: Any) {
        storage[key] = value
    }
    
    func remove(key: String) {
        storage[key] = nil
    }
}
