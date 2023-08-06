//
//  HapticManager.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.04.23.
//

import SwiftUI

// MARK: - Haptic Manager
final class HapticManager {
    // MARK: Properties
    static let shared: HapticManager = .init()
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Haptics
#if os(iOS)
    func playImpact(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?) {
        guard let feedbackStyle else { return }
        
        let generator: UIImpactFeedbackGenerator = .init(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func playSelection() {
        let generator: UISelectionFeedbackGenerator = .init()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func playNotification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType?) {
        guard let feedbackType else { return }
        
        let generator: UINotificationFeedbackGenerator = .init()
        generator.prepare()
        generator.notificationOccurred(feedbackType)
    }
#endif
    
#if os(watchOS)
    func playImpact(_ hapticType: WKHapticType?) {
        guard let hapticType else { return }
        
        WKInterfaceDevice.current().play(hapticType)
    }
#endif
}
