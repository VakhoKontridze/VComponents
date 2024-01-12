//
//  VSpinnerParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

// MARK: - V Spinner Parameters
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
    /// Indicates if interaction is enabled.
    public var isInteractionEnabled: Bool

    /// Attributes.
    public var attributes: [String: Any?]

    // MARK: Initializers
    /// Initializes `VSpinnerParameters`.
    public init(
        isInteractionEnabled: Bool = true,
        attributes: [String: Any?] = [:]
    ) {
        self.isInteractionEnabled = isInteractionEnabled
        self.attributes = attributes
    }
}
