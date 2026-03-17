//
//  VSpinnerParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

/// Parameters for presenting an `VSpinner`.
///
///     @State private var parameters: VSpinnerParameters = .init()
///
///     var body: some View {
///         content
///             .vContinuousSpinner(parameters: parameters)
///     }
///
public struct VSpinnerParameters {
    // MARK: Properties
    /// Appearance.
    public var appearance: VContinuousSpinnerAppearance
    
    /// Indicates if interaction is enabled.
    public var isInteractionEnabled: Bool

    /// Attributes.
    public var attributes: [String: Any]

    // MARK: Initializers
    /// Initializes `VSpinnerParameters`.
    public init(
        appearance: VContinuousSpinnerAppearance = .init(),
        isInteractionEnabled: Bool = true,
        attributes: [String: Any] = [:]
    ) {
        self.appearance = appearance
        self.isInteractionEnabled = isInteractionEnabled
        self.attributes = attributes
    }
}
