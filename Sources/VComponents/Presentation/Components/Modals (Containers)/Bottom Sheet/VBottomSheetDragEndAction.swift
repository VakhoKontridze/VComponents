//
//  VBottomSheetDragEndAction.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI
import OSLog

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VBottomSheetDragEndAction {
    // MARK: Cases
    case dismiss
    case snap(CGFloat)
    
    // MARK: Initializers
    // Velocity is always non-zero, and exceeds the threshold.
    static func dragEndedHighVelocityDragEndAction(
        containerHeight: CGFloat,

        heights: VBottomSheetAppearance.Heights,

        offset: CGFloat,

        velocity: CGFloat
    ) -> Self? {
        guard let region: VBottomSheetRegion = .init(containerHeight: containerHeight, heights: heights, offset: offset) else { return nil }
        let isGoingDown: Bool = velocity > 0
        
        switch (region, isGoingDown) {
        case (.idealToMax, false): return .snap(heights.maxOffset(in: containerHeight))
        case (.idealToMax, true): return .snap(heights.idealOffset(in: containerHeight))
        case (.minToIdeal, false): return .snap(heights.idealOffset(in: containerHeight))
        case (.minToIdeal, true): return .snap(heights.minOffset(in: containerHeight))
        case (.swipeToMin, false): return .snap(heights.minOffset(in: containerHeight))
        case (.swipeToMin, true): return .dismiss
        }
    }
    
    static func dragEndedDragEndAction(
        containerHeight: CGFloat,

        heights: VBottomSheetAppearance.Heights,
        canSwipeToDismiss: Bool,
        swipeDismissDistance: CGFloat,
        
        offset: CGFloat,
        offsetBeforeDrag: CGFloat,
        translation: CGFloat
    ) -> Self? {
        let shouldDismiss: Bool = {
            guard canSwipeToDismiss else { return false }
            
            let isDraggedDown: Bool = translation > 0
            guard isDraggedDown else { return false }
            
            let newOffset: CGFloat = offsetBeforeDrag + translation
            guard newOffset - heights.minOffset(in: containerHeight) >= abs(swipeDismissDistance) else { return false }
            
            return true
        }()
        
        if shouldDismiss {
            return .dismiss
            
        } else {
            guard let region: VBottomSheetRegion = .init(containerHeight: containerHeight, heights: heights, offset: offset) else { return nil }
            
            switch region {
            case .idealToMax:
                let idealDiff: CGFloat = abs(heights.idealOffset(in: containerHeight) - offset)
                let maxDiff: CGFloat = abs(heights.maxOffset(in: containerHeight) - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? heights.idealOffset(in: containerHeight) : heights.maxOffset(in: containerHeight)
                
                return .snap(newOffset)
                
            case .swipeToMin, .minToIdeal:
                // If `swipe` is disabled, code won't get here.
                // So, modal should snap to min heights.
                
                let minDiff: CGFloat = abs(heights.minOffset(in: containerHeight) - offset)
                let idealDiff: CGFloat = abs(heights.idealOffset(in: containerHeight) - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? heights.minOffset(in: containerHeight) : heights.idealOffset(in: containerHeight)
                
                return .snap(newOffset)
            }
        }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
private enum VBottomSheetRegion {
    // MARK: Cases
    case idealToMax
    case minToIdeal
    case swipeToMin
    
    // MARK: Initializers
    init?(
        containerHeight: CGFloat,
        heights: VBottomSheetAppearance.Heights,
        offset: CGFloat
    ) {
        if offset >= heights.maxOffset(in: containerHeight), offset <= heights.idealOffset(in: containerHeight) {
            self = .idealToMax
        } else if offset > heights.idealOffset(in: containerHeight), offset <= heights.minOffset(in: containerHeight) {
            self = .minToIdeal
        } else if offset > heights.minOffset(in: containerHeight) {
            self = .swipeToMin
        } else {
            Logger.bottomSheet.error("Invalid height configuration in 'VBottomSheet'")
            return nil
        }
    }
}
