//
//  BasicAnimation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/22/21.
//

import SwiftUI

// MARK: - Basic Animation
/// Wrapper on `SwiftUI`'s animation used throughout the framework
///
/// Purpose of this object was to limit some animations to curve and duration
///
/// Object contains proeprty `swiftUIAnimation`, which can be used to create object that `SwiftUI` can interpret
public struct BasicAnimation {
    /// Animation curve
    public var curve: AnimationCurve
    
    /// Animation duration
    public var duration: TimeInterval
    
    /// Creates `SwiftUI` `Animation`
    public var asSwiftUIAnimation: Animation {
        switch curve {
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        }
    }

    // MARK: Animation Curve
    /// Enum that represents animation curve, suh as `linear`, `easeIn`, `easeOut`, or `easeInOut`
    public enum AnimationCurve {
        /// Linear
        case linear
        
        /// Ease in
        case easeIn
        
        /// Ease out
        case easeOut
        
        /// Ease in and out
        case easeInOut
    }
}
