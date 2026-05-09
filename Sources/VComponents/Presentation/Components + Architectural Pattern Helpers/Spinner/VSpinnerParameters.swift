//
//  VContinuousSpinnerParameters.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.10.22.
//

import SwiftUI

/// Parameters for presenting an `VContinuousSpinner`.
///
///     @State private var parameters: VContinuousSpinnerParameters = .init()
///
///     var body: some View {
///         content
///             .vContinuousSpinner(parameters: parameters)
///     }
///
public struct VContinuousSpinnerParameters {
    // MARK: Properties
    /// Appearance.
    public var appearance: VContinuousSpinnerAppearance
    
    /// Appearance delay.
    public var appearanceDelay: Duration?
    
    /// Indicates if interaction is enabled.
    public var isInteractionEnabled: Bool

    /// Attributes.
    public var attributes: [String: Any]

    // MARK: Initializers
    /// Initializes `VContinuousSpinnerParameters`.
    public init(
        appearance: VContinuousSpinnerAppearance = .init(),
        appearanceDelay: Duration? = nil,
        isInteractionEnabled: Bool = true,
        attributes: [String: Any] = [:]
    ) {
        self.appearance = appearance
        self.appearanceDelay = appearanceDelay
        self.isInteractionEnabled = isInteractionEnabled
        self.attributes = attributes
    }
}
