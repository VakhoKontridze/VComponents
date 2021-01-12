//
//  VProgressBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK:- V Progress Bar
public struct VProgressBar: View {
    // MARK: Properties
    private let model: VProgressBarModel
    
    private let range: ClosedRange<Double>
    private let value: Double
    
    public init<V>(
        model: VProgressBarModel = .init(),
        range: ClosedRange<V> = 0...1,
        value: V
    )
        where
            V: BinaryFloatingPoint,
            V.Stride: BinaryFloatingPoint
    {
        self.model = model
        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.value = {
            switch value {
            case ...range.lowerBound: return .init(range.lowerBound)
            case range.upperBound...: return .init(range.upperBound)
            default: return .init(value)
            }
        }()
    }
}

// MARK:- Body
extension VProgressBar {
    public var body: some View {
        VSlider(
            model: model.sliderModel,
            range: range,
            step: nil,
            state: .enabled,
            value: .constant(value),
            onChange: nil
        )
    }
}

// MARK:- Preview
struct VProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VProgressBar(value: 0.5)
            .padding()
    }
}
