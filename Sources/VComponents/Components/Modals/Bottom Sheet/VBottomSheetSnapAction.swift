//
//  VBottomSheetSnapAction.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI

// MARK: - V Bottom Sheet Snap Action
enum VBottomSheetSnapAction {
    // MARK: Cases
    case dismiss
    case snap(CGFloat)
    
    // MARK: Initializers
    // Velocity is always non-zero, and exceeds the threshold.
    static func dragEndedHighVelocitySnapAction(
        heights: VBottomSheetUIModel.Layout.BottomSheetHeights,
        offset: CGFloat,
        velocity: CGFloat
    ) -> VBottomSheetSnapAction {
        let region: VBottomSheetRegion = .init(heights: heights, offset: offset)
        let isGoingDown: Bool = velocity > 0
        
        switch (region, isGoingDown) {
        case (.idealToMax, false): return .snap(heights.maxOffset)
        case (.idealToMax, true): return .snap(heights.idealOffset)
        case (.minToIdeal, false): return .snap(heights.idealOffset)
        case (.minToIdeal, true): return .snap(heights.minOffset)
        case (.pullDownToMin, false): return .snap(heights.minOffset)
        case (.pullDownToMin, true): return .dismiss
        }
    }
    
    static func dragEndedSnapAction(
        heights: VBottomSheetUIModel.Layout.BottomSheetHeights,
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
            guard newOffset - heights.minOffset >= abs(pullDownDismissDistance) else { return false }

            return true
        }()
    
        switch shouldDismiss {
        case false:
            switch VBottomSheetRegion(heights: heights, offset: offset) {
            case .idealToMax:
                let idealDiff: CGFloat = abs(heights.idealOffset - offset)
                let maxDiff: CGFloat = abs(heights.maxOffset - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? heights.idealOffset : heights.maxOffset
                
                return .snap(newOffset)

            case .pullDownToMin, .minToIdeal:
                // If `pullDown` is disabled, code won't get here.
                // So, modal should snap to min heights.
                
                let minDiff: CGFloat = abs(heights.minOffset - offset)
                let idealDiff: CGFloat = abs(heights.idealOffset - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? heights.minOffset : heights.idealOffset
                
                return .snap(newOffset)
            }
            
        case true:
            return .dismiss
        }
    }
}

// MARK: - V Bottom Sheet Region
private enum VBottomSheetRegion {
    // MARK: Cases
    case idealToMax
    case minToIdeal
    case pullDownToMin

    // MARK: Initializrs
    init(
        heights: VBottomSheetUIModel.Layout.BottomSheetHeights,
        offset: CGFloat
    ) {
        if offset >= heights.maxOffset && offset <= heights.idealOffset {
            self = .idealToMax
        } else if offset > heights.idealOffset && offset <= heights.minOffset {
            self = .minToIdeal
        } else if offset > heights.minOffset {
            self = .pullDownToMin
        } else {
            fatalError()
        }
    }
}
