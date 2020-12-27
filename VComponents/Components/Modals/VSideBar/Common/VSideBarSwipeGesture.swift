//
//  VSideBarSwipeGesture.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Extension
extension View {
    func addSideBarSwipeGesture(completion: @escaping () -> Void) -> some View {
        modifier(VSideBarSwipeGesture(completion: completion))
    }
}

// MARK:- V Side Bar Swipe Gesture
struct VSideBarSwipeGesture: ViewModifier {
    // MARK: Properties
    private let completion: () -> Void
    
    private let distanceToSwipe: CGFloat = 100
    
    // MARK: Initializers
    init(
        completion: @escaping () -> Void
    ) {
        self.completion = completion
    }
}

// MARK:- Body
extension VSideBarSwipeGesture {
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture()
                .onEnded({ value in
                    guard
                        value.translation.width <= 0 &&
                        abs(value.translation.width) >= distanceToSwipe
                    else {
                        return
                    }
                    
                    completion()
                })
            )
    }
}
