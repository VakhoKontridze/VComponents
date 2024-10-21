//
//  VContinuousSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VCore

// MARK: - V Continuous Spinner
/// Indicator component that represents indefinite activity.
///
///     var body: some View {
///         VContinuousSpinner()
///     }
///
public struct VContinuousSpinner: View, Sendable {
    // MARK: Properties - UI Model
    private let uiModel: VContinuousSpinnerUIModel
    
    // MARK: Properties - Flags
    @State private var isAnimating: Bool = false
    
    // MARK: Initializers
    /// Initializes `VContinuousSpinner`.
    public init(
        uiModel: VContinuousSpinnerUIModel = .init()
    ) {
        self.uiModel = uiModel
    }
    
    // MARK: Body
    public var body: some View {
        Circle()
            .trim(from: 0, to: uiModel.length)
            .stroke(
                uiModel.color,
                style: StrokeStyle(lineWidth: uiModel.thickness, lineCap: .round)
            )
            .frame(width: uiModel.dimension, height: uiModel.dimension)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .task({
                withAnimation(
                    uiModel.animation.repeatForever(autoreverses: false),
                    { isAnimating.toggle() }
                )
            })
            .environment(\.layoutDirection, .leftToRight) // Like native `ProgressView`, forces LTR
    }
}

// MARK: - Preview
#if DEBUG

#Preview(body: {
    PreviewContainer(content: {
        VContinuousSpinner()
    })
})

#endif
