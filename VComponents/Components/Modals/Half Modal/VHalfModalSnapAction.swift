//
//  VHalfModalSnapAction.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI

// MARK: - V Half Modal Snap Action
enum VHalfModalSnapAction {
    // MARK: Cases
    case dismiss
    case snap(CGFloat)
    
    // MARK: Initializers
    init?(
        min: CGFloat,
        ideal: CGFloat,
        max: CGFloat,
        
        canPullDownToDismiss: Bool,
        translationBelowMinHeightToDismiss: CGFloat,
        
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
            guard newOffset - maxAllowedOffset >= abs(translationBelowMinHeightToDismiss) else { return false }

            return true
        }()
    
        switch shouldDismiss {
        case false:
            let minOffset: CGFloat = max - min
            let idealOffset: CGFloat = max - ideal
            let maxOffset: CGFloat = max - max

            switch VHalfModalRegion(
                offset: offset,
                minOffset: minOffset,
                idealOffset: idealOffset,
                maxOffset: maxOffset
            ) {
            case .idealMax:
                let idealDiff: CGFloat = abs(idealOffset - offset)
                let maxDiff: CGFloat = abs(maxOffset - offset)
                let newOffset: CGFloat = idealDiff < maxDiff ? idealOffset : maxOffset
                
                self = .snap(newOffset)

            case .ideal:
                return nil

            case .minIdeal:
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

// MARK: - V Half Modal Region
private enum VHalfModalRegion {
    // MARK: Cases
    case idealMax
    case ideal
    case minIdeal

    // MARK: Initializrs
    init(
        offset: CGFloat,
        minOffset: CGFloat,
        idealOffset: CGFloat,
        maxOffset: CGFloat
    ) {
        switch offset {
        case idealOffset: self = .ideal
        case (maxOffset..<idealOffset): self = .idealMax
        default: self = .minIdeal   // Min isn't used to allow registering area between dismiss point and min
        }
    }
}
