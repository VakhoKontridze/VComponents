//
//  VBottomSheetSnapAction.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI

// MARK: - V Bottom Sheet Snap Action
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VBottomSheetSnapAction {
    // MARK: Cases
    case dismiss
    case snap(CGFloat)
    
    // MARK: Initializers
    // Velocity is always non-zero, and exceeds the threshold.
    static func dragEndedHighVelocitySnapAction(
        containerHeight: CGFloat,

        heights: VBottomSheetUIModel.Heights,

        offset: CGFloat,

        velocity: CGFloat
    ) -> VBottomSheetSnapAction {
        let region: VBottomSheetRegion = .init(containerHeight: containerHeight, heights: heights, offset: offset)
        let isGoingDown: Bool = velocity > 0
        
        switch (region, isGoingDown) {
        case (.idealToMax, false): return .snap(heights.maxOffset(in: containerHeight))
        case (.idealToMax, true): return .snap(heights.idealOffset(in: containerHeight))
        case (.minToIdeal, false): return .snap(heights.idealOffset(in: containerHeight))
        case (.minToIdeal, true): return .snap(heights.minOffset(in: containerHeight))
        case (.pullDownToMin, false): return .snap(heights.minOffset(in: containerHeight))
        case (.pullDownToMin, true): return .dismiss
        }
    }
    
    static func dragEndedSnapAction(
        containerHeight: CGFloat,

        heights: VBottomSheetUIModel.Heights,
        canPullDownToDismiss: Bool,
        pullDownDismissDistance: CGFloat,
        
        offset: CGFloat,
        offsetBeforeDrag: CGFloat,
        translation: CGFloat
    ) -> VBottomSheetSnapAction {
        let shouldDismiss: Bool = {
            guard canPullDownToDismiss else { return false }
            
            let isDraggedDown: Bool = translation > 0
            guard isDraggedDown else { return false }
            
            let newOffset: CGFloat = offsetBeforeDrag + translation
            guard newOffset - heights.minOffset(in: containerHeight) >= abs(pullDownDismissDistance) else { return false }
            
            return true
        }()
        
        switch shouldDismiss {
        case false:
            switch VBottomSheetRegion(containerHeight: containerHeight, heights: heights, offset: offset) {
            case .idealToMax:
                let idealDiff: CGFloat = abs(heights.idealOffset(in: containerHeight) - offset)
                let maxDiff: CGFloat = abs(heights.maxOffset(in: containerHeight) - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? heights.idealOffset(in: containerHeight) : heights.maxOffset(in: containerHeight)
                
                return .snap(newOffset)
                
            case .pullDownToMin, .minToIdeal:
                // If `pullDown` is disabled, code won't get here.
                // So, modal should snap to min heights.
                
                let minDiff: CGFloat = abs(heights.minOffset(in: containerHeight) - offset)
                let idealDiff: CGFloat = abs(heights.idealOffset(in: containerHeight) - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? heights.minOffset(in: containerHeight) : heights.idealOffset(in: containerHeight)
                
                return .snap(newOffset)
            }
            
        case true:
            return .dismiss
        }
    }
}

// MARK: - V Bottom Sheet Region
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
private enum VBottomSheetRegion {
    // MARK: Cases
    case idealToMax
    case minToIdeal
    case pullDownToMin
    
    // MARK: Initializers
    init(
        containerHeight: CGFloat,
        heights: VBottomSheetUIModel.Heights,
        offset: CGFloat
    ) {
        if offset >= heights.maxOffset(in: containerHeight) && offset <= heights.idealOffset(in: containerHeight) {
            self = .idealToMax
        } else if offset > heights.idealOffset(in: containerHeight) && offset <= heights.minOffset(in: containerHeight) {
            self = .minToIdeal
        } else if offset > heights.minOffset(in: containerHeight) {
            self = .pullDownToMin
        } else {
            fatalError()
        }
    }
}
