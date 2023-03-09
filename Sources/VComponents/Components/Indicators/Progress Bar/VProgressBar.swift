//
//  VProgressBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore

// MARK: - V Progress Bar
/// Indicator component that indicates progress towards completion of a task.
///
/// UI Model and total value can be passed as parameters.
///
///     @State private var progress: Double = 0.5
///
///     var body: some View {
///         VProgressBar(value: progress)
///             .padding()
///     }
///
public struct VProgressBar: View {
    // MARK: Properties
    private let uiModel: VProgressBarUIModel
    
    private let range: ClosedRange<Double>
    private let value: Double
    
    @State private var progressBarWidth: CGFloat = 0
    
    // MARK: Initializers
    /// Initializes `VProgressBar` with value.
    public init<V>(
        uiModel: VProgressBarUIModel = .init(),
        total: V = 1,
        value: V
    )
        where
            V: BinaryFloatingPoint
    {
        self.uiModel = uiModel
        self.range = 0...Double(total)
        self.value = {
            let value: Double = .init(value)
            let min: Double = 0
            let max: Double = .init(total)
            
            return value.clamped(min: min, max: max)
        }()
    }

    // MARK: Body
    public var body: some View {
        ZStack(alignment: .leading, content: {
            track
            progress
        })
            .mask(RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius))
            .frame(height: uiModel.layout.height)
            .readSize(onChange: { progressBarWidth = $0.width })
            .animation(uiModel.animations.progress, value: value)
    }

    private var track: some View {
        Rectangle()
            .foregroundColor(uiModel.colors.track)
    }

    private var progress: some View {
        Rectangle()
            .frame(width: progressWidth)
            .cornerRadius(uiModel.layout.cornerRadius, corners: uiModel.layout.progressViewRoundedCorners)
            .foregroundColor(uiModel.colors.progress)
    }
    
    // MARK: Progress Width
    private var progressWidth: CGFloat {
        let width: CGFloat = progressBarWidth

        return value * width
    }
}

// MARK: - Preview
struct VProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
    }
    
    private struct Preview: View {
        @State private var value: Double = 0
        
        var body: some View {
            PreviewContainer(content: {
                VProgressBar(value: value)
                    .padding()
            })
                .onReceiveOfTimerIncrement($value, to: 1, by: 0.1)
        }
    }
}
