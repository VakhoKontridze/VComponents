//
//  BasicAnimation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/22/21.
//

import SwiftUI

// MARK: - Basic Animation
/// Wrapper on `SwiftUI`'s animation used throughout the library.
///
/// Purpose of this object was to limit some animations to curve and duration.
///
/// Object contains proeprty `swiftUIAnimation`, which can be used to create object that `SwiftUI` can interpret.
public struct BasicAnimation {
    /// Animation curve.
    public var curve: AnimationCurve
    
    /// Animation duration.
    public var duration: TimeInterval
    
    /// Converts `BasicAnimation` to `SwiftUI.Animation`.
    public var toSwiftUIAnimation: Animation {
        switch curve {
        case .linear: return .linear(duration: duration)
        case .easeIn: return .easeIn(duration: duration)
        case .easeOut: return .easeOut(duration: duration)
        case .easeInOut: return .easeInOut(duration: duration)
        }
    }

    // MARK: Animation Curve
    /// Enum that represents animation curve, suh as `linear`, `easeIn`, `easeOut`, or `easeInOut`.
    public enum AnimationCurve: Hashable, Equatable {
        // MARK: Cases
        /// Linear.
        case linear
        
        /// Ease in.
        case easeIn
        
        /// Ease out.
        case easeOut
        
        /// Ease in and out.
        case easeInOut
    }
}

// MARK: - Extension
/// Returns the result of recomputing the view's body with the provided `BasicAnimation`,
/// and optionally calls a completion handler.
///
/// Comletion handler is called using `asyncAfter`,
/// scheduling with a deadline of `.now()` `+` animation duration.
public func withBasicAnimation<Result>(
    _ animation: BasicAnimation?,
    body: () throws -> Result,
    completion: (() -> Void)?
) rethrows -> Result {
    let result: Result = try withAnimation(animation?.toSwiftUIAnimation, body)
    
    DispatchQueue.main.asyncAfter(
        deadline: .now() + (animation?.duration ?? 0),
        execute: { completion?() }
    )
    
    return result
}
