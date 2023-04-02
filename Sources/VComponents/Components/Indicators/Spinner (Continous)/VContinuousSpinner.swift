//
//  VContinuousSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK: - V Continuous Spinner
/// Indicator component that indicates activity.
///
/// UI model can be passed as parameter.
///
///     var body: some View {
///         VContinuousSpinner()
///     }
///
public struct VContinuousSpinner: View {
    // MARK: Properties
    private let uiModel: VContinuousSpinnerUIModel
    
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
            .trim(from: 0, to: uiModel.layout.length)
            .stroke(
                uiModel.colors.spinner,
                style: StrokeStyle(lineWidth: uiModel.layout.thickness, lineCap: .round)
            )
            .frame(width: uiModel.layout.dimension, height: uiModel.layout.dimension)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear(perform: {
                DispatchQueue.main.async(execute: {
                    withAnimation(uiModel.animations.spinning.repeatForever(autoreverses: false), {
                        isAnimating.toggle()
                    })
                })
            })
            .environment(\.layoutDirection, .leftToRight) // Like native `ProgressView`, forces LTR
    }
}

// MARK: - Preview
struct VContinuousSpinner_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VContinuousSpinner()
            })
        }
    }
}
