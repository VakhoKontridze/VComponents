//
//  DragGesture.Value.Velocity.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/19/22.
//

import SwiftUI

// MARK: - Drag Gesture Value Velocity
extension DragGesture.Value {
    /// Calculates velocity of `DrageGesture` in relation to last drag value.
    ///
    /// Usage Example:
    ///
    ///     @State private var lastDragValue: DragGesture.Value?
    ///
    ///     var body: some View {
    ///         ColorBook.accent
    ///             .frame(dimension: 100)
    ///             .gesture(
    ///                 DragGesture(minimumDistance: 0)
    ///                     .onChanged(dragChanged)
    ///                     .onEnded(dragEnded)
    ///             )
    ///     }
    ///
    ///     private func dragChanged(dragValue: DragGesture.Value) {
    ///         if lastDragValue == nil { lastDragValue = dragValue }
    ///
    ///         let velocity: CGSize = dragValue.velocity(inRelationTo: lastDragValue)
    ///
    ///         // ...
    ///     }
    ///
    ///     private func dragEnded(dragValue: DragGesture.Value) {
    ///         defer { lastDragValue = nil }
    ///
    ///         // ...
    ///     }
    ///
    public func velocity(inRelationTo oldValue: DragGesture.Value?) -> CGSize {
        guard let oldValue = oldValue else { return .zero }
        
        let duration: CGFloat = time.timeIntervalSince(oldValue.time)
        
        return .init(
            width: (translation.width - oldValue.translation.width) / duration,
            height: (translation.height - oldValue.translation.height) / duration
        )
    }
}
