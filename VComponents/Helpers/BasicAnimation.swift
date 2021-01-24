//
//  BasicAnimation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/22/21.
//

import SwiftUI

// MARK:- Basic Animation
/// Wrapper on SwiftUI's animation used throughout the framework
///
/// Purpose of this object was to limit some animations to curve and duration
///
/// Object contains proeprty `swiftUIAnimation`, which can be used to create animation object that SwiftUI can interpret
public struct BasicAnimation {
    public var curve: VAnimationCurve
    public var duration: TimeInterval
    
    public var asSwiftUIAnimation: Animation {
        switch curve {
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        }
    }
}

// MARK:- Animation Curve
extension BasicAnimation {
    /// Enum that represents animation curve, suh as linear, easeIn, easeOut, or easeInOut
    public enum VAnimationCurve {
        case linear
        case easeIn
        case easeOut
        case easeInOut
    }
}
