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
/// Model and total value can be passed as parameters.
///
///     @State var progress: Double = 0.5
///
///     var body: some View {
///         VProgressBar(value: progress)
///             .padding()
///     }
///
public struct VProgressBar: View {
    // MARK: Properties
    private let model: VProgressBarModel
    
    private let range: ClosedRange<Double>
    private let value: Double
    
    // MARK: Initializers
    /// Initializes component with value.
    public init<V>(
        model: VProgressBarModel = .init(),
        total: V = 1,
        value: V
    )
        where
            V: BinaryFloatingPoint
    {
        self.model = model
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
            model: model.sliderSubModel,
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
