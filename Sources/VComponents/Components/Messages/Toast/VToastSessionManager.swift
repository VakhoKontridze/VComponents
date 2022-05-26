//
//  VToastSessionManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import Foundation
import VCore

// MARK: - V Toast Session Manager
// Since `VToast` uses a timer to dismiss itself,
// `onAppear`/`onDissapear` methods can get called twice if nested in `NavigationView`.
// In that case, `View` state logic breaks down and must be stored elsewhere.
final class VToastSessionManager {
    static let shared: VToastSessionManager = .init()
    
    private let idGen: AtomicInteger = .init()
    private var appearedToasts: Set<Int> = []
    
    private init() {}
    
    func generateID() -> Int { idGen.value }
    
    func didAppear(_ id: Int) { appearedToasts.insert(id); print(appearedToasts) }
    func didDisappear(_ id: Int) { appearedToasts.remove(id); print(appearedToasts) }
    
    func isVisible(_ id: Int) -> Bool { appearedToasts.contains(id) }
}
