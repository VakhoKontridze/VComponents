//
//  VContinuousSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

public import SwiftUI
import VCore

/// Indicator component that represents indefinite activity.
///
///     var body: some View {
///         VContinuousSpinner()
///     }
///
public struct VContinuousSpinner: View {
    // MARK: Properties - Appearance
    private let appearance: VContinuousSpinnerAppearance
    
    // MARK: Properties - State
    @State private var isAnimating: Bool = false
    
    // MARK: Initializers
    /// Initializes `VContinuousSpinner`.
    public init(
        appearance: VContinuousSpinnerAppearance = .init()
    ) {
        self.appearance = appearance
    }
    
    // MARK: Body
    public var body: some View {
        Circle()
            .trim(from: 0, to: appearance.length)
            .stroke(
                appearance.color,
                style: StrokeStyle(lineWidth: appearance.thickness, lineCap: .round)
            )
            .frame(dimension: appearance.dimension)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(appearance.animation.repeatForever(autoreverses: false)) {
                    isAnimating.toggle()
                }
            }
            .environment(\.layoutDirection, .leftToRight) // Like native `ProgressView`, forces LTR
    }
}

#if DEBUG

#Preview {
    PreviewContainer {
        VContinuousSpinner()
    }
}

#endif
