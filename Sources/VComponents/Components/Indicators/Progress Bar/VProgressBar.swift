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

    public var body: some View {
        VSlider(
            uiModel: uiModel.sliderSubUIModel,
            range: range,
            step: nil,
            value: .constant(value),
            onChange: nil
        )
    }
}

// MARK: - Preview
struct VProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VProgressBar(value: 0.5)
            .padding()
    }
}
