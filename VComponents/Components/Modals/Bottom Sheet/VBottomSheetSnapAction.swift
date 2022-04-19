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
    static func dragEndedSnapAction(
        height: VBottomSheetModel.Layout.Height,
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
            let maxAllowedOffset: CGFloat = height.max - height.min
            guard newOffset - maxAllowedOffset >= abs(pullDownDismissDistance) else { return false }

            return true
        }()
    
        switch shouldDismiss {
        case false:
            switch VBottomSheetRegion(height: height, offset: offset) {
            case .idealToMax:
                let idealDiff: CGFloat = abs(height.idealOffset - offset)
                let maxDiff: CGFloat = abs(height.maxOffset - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? height.idealOffset : height.maxOffset
                
                return .snap(newOffset)

            case .pullDownToMin, .minToIdeal:
                // If `pullDown` is disabled, code won't get here.
                // So, modal should snap to min height.
                
                let minDiff: CGFloat = abs(height.minOffset - offset)
                let idealDiff: CGFloat = abs(height.idealOffset - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? height.minOffset : height.idealOffset
                
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
        height: VBottomSheetModel.Layout.Height,
        offset: CGFloat
    ) {
        if offset >= height.maxOffset && offset <= height.idealOffset {
            self = .idealToMax
        } else if offset > height.idealOffset && offset <= height.minOffset {
            self = .minToIdeal
        } else if offset > height.minOffset {
            self = .pullDownToMin
        } else {
            fatalError()
        }
    }
}
