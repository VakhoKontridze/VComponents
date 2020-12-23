//
//  VBaseViewSwipeGesture.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func addNavigationBarSwipeGesture() -> some View {
        modifier(VBaseViewSwipeGesture())
    }
}

// MARK:- V Base View Swipe Gesture
struct VBaseViewSwipeGesture: ViewModifier {
    // MARK: Properties
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @GestureState private var dragOffset: CGSize = .zero
    
    private let edgeOffset: CGFloat = 20
    private let distanceToSwipe: CGFloat = 100
}

// MARK:- Body
extension VBaseViewSwipeGesture {
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture()
                .updating($dragOffset, body: { (value, state, transaction) in
                    guard
                        value.startLocation.x <= edgeOffset,
                        value.translation.width >= distanceToSwipe
                    else {
                        return
                        
                    }
                    
                    withAnimation { presentationMode.wrappedValue.dismiss() }
                })
            )
    }
}
