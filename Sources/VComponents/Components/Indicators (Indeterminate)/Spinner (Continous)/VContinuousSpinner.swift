//
//  VContinuousSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VCore

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
            .trim(from: 0, to: uiModel.length)
            .stroke(
                uiModel.color,
                style: StrokeStyle(lineWidth: uiModel.thickness, lineCap: .round)
            )
            .frame(width: uiModel.dimension, height: uiModel.dimension)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear(perform: {
                DispatchQueue.main.async(execute: {
                    withAnimation(uiModel.animation.repeatForever(autoreverses: false), {
                        isAnimating.toggle()
                    })
                })
            })
            .environment(\.layoutDirection, .leftToRight) // Like native `ProgressView`, forces LTR
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VContinuousSpinner_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
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
