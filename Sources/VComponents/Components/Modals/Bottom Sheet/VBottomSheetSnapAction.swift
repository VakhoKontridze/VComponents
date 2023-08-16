//
//  VBottomSheetSnapAction.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI

// MARK: - V Bottom Sheet Snap Action
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VBottomSheetSnapAction {
    // MARK: Cases
    case dismiss
    case snap(CGFloat)
    
    // MARK: Initializers
    // Velocity is always non-zero, and exceeds the threshold.
    static func dragEndedHighVelocitySnapAction(
        screenHeight: CGFloat,

        heights: VBottomSheetUIModel.Heights,

        offset: CGFloat,

        velocity: CGFloat
    ) -> VBottomSheetSnapAction {
        let region: VBottomSheetRegion = .init(screenHeight: screenHeight, heights: heights, offset: offset)
        let isGoingDown: Bool = velocity > 0
        
        switch (region, isGoingDown) {
        case (.idealToMax, false): return .snap(heights.maxOffset(in: screenHeight))
        case (.idealToMax, true): return .snap(heights.idealOffset(in: screenHeight))
        case (.minToIdeal, false): return .snap(heights.idealOffset(in: screenHeight))
        case (.minToIdeal, true): return .snap(heights.minOffset(in: screenHeight))
        case (.pullDownToMin, false): return .snap(heights.minOffset(in: screenHeight))
        case (.pullDownToMin, true): return .dismiss
        }
    }
    
    static func dragEndedSnapAction(
        screenHeight: CGFloat,

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
            guard newOffset - heights.minOffset(in: screenHeight) >= abs(pullDownDismissDistance) else { return false }
            
            return true
        }()
        
        switch shouldDismiss {
        case false:
            switch VBottomSheetRegion(screenHeight: screenHeight, heights: heights, offset: offset) {
            case .idealToMax:
                let idealDiff: CGFloat = abs(heights.idealOffset(in: screenHeight) - offset)
                let maxDiff: CGFloat = abs(heights.maxOffset(in: screenHeight) - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? heights.idealOffset(in: screenHeight) : heights.maxOffset(in: screenHeight)
                
                return .snap(newOffset)
                
            case .pullDownToMin, .minToIdeal:
                // If `pullDown` is disabled, code won't get here.
                // So, modal should snap to min heights.
                
                let minDiff: CGFloat = abs(heights.minOffset(in: screenHeight) - offset)
                let idealDiff: CGFloat = abs(heights.idealOffset(in: screenHeight) - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? heights.minOffset(in: screenHeight) : heights.idealOffset(in: screenHeight)
                
                return .snap(newOffset)
            }
            
        case true:
            return .dismiss
        }
    }
}

// MARK: - V Bottom Sheet Region
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private enum VBottomSheetRegion {
    // MARK: Cases
    case idealToMax
    case minToIdeal
    case pullDownToMin
    
    // MARK: Initializers
    init(
        screenHeight: CGFloat,
        heights: VBottomSheetUIModel.Heights,
        offset: CGFloat
    ) {
        if offset >= heights.maxOffset(in: screenHeight) && offset <= heights.idealOffset(in: screenHeight) {
            self = .idealToMax
        } else if offset > heights.idealOffset(in: screenHeight) && offset <= heights.minOffset(in: screenHeight) {
            self = .minToIdeal
        } else if offset > heights.minOffset(in: screenHeight) {
            self = .pullDownToMin
        } else {
            fatalError()
        }
    }
}
