//
//  VToastSessionManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import Foundation
import VCore

// MARK: - V Toast Session Manager
final class VToastSessionManager {
    // MARK: Properties
    static let shared: VToastSessionManager = .init()
    
    private var appearedToasts: Set<Int> = []
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Methods
    func didAppear(_ id: Int) { appearedToasts.insert(id) }
    func didDisappear(_ id: Int) { appearedToasts.remove(id) }
    
    func isVisible(_ id: Int) -> Bool { appearedToasts.contains(id) }
    
    func forceDismissAll() { appearedToasts = [] }
}
