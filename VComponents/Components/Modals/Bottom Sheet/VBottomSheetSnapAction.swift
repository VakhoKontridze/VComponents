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
    init(
        min: CGFloat,
        ideal: CGFloat,
        max: CGFloat,
        
        canPullDownToDismiss: Bool,
        pullDownDismissDistance: CGFloat,
        
        offset: CGFloat,
        offsetBeforeDrag: CGFloat,
        translation: CGFloat
    ) {
        let shouldDismiss: Bool = {
            guard canPullDownToDismiss else { return false }

            let isDraggedDown: Bool = translation > 0
            guard isDraggedDown else { return false }

            let newOffset: CGFloat = offsetBeforeDrag + translation
            let maxAllowedOffset: CGFloat = max - min
            guard newOffset - maxAllowedOffset >= abs(pullDownDismissDistance) else { return false }

            return true
        }()
    
        switch shouldDismiss {
        case false:
            let minOffset: CGFloat = max - min
            let idealOffset: CGFloat = max - ideal
            let maxOffset: CGFloat = max - max

            switch VBottomSheetRegion(
                offset: offset,
                minOffset: minOffset,
                idealOffset: idealOffset,
                maxOffset: maxOffset
            ) {
            case .idealToMax:
                let idealDiff: CGFloat = abs(idealOffset - offset)
                let maxDiff: CGFloat = abs(maxOffset - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? idealOffset : maxOffset
                
                self = .snap(newOffset)

            case .pullDownToMin, .minToIdeal:
                // If `pullDown` is disabled, code won't get here.
                // So, modal should snap to min height.
                
                let minDiff: CGFloat = abs(minOffset - offset)
                let idealDiff: CGFloat = abs(idealOffset - offset)
                let newOffset: CGFloat = minDiff < idealDiff ? minOffset : idealOffset
                
                self = .snap(newOffset)
            }
            
        case true:
            self = .dismiss
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
        offset: CGFloat,
        minOffset: CGFloat,
        idealOffset: CGFloat,
        maxOffset: CGFloat
    ) {
        if offset >= maxOffset && offset < idealOffset {
            self = .idealToMax
        } else if offset >= idealOffset && offset < minOffset {
            self = .minToIdeal
        } else if offset >= minOffset {
            self = .pullDownToMin
        } else {
            fatalError()
        }
    }
}
