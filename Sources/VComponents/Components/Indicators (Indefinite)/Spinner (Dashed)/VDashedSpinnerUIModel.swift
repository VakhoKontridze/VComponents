//
//  VDashedSpinnerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Dashed Spinner UI Model
/// Model that describes UI.
public struct VDashedSpinnerUIModel {
    // MARK: Properties
    /// Color.
    public var color: Color? = {
#if os(iOS)
        Color.blue
#elseif os(macOS)
        nil // TODO: Implement custom, as tint doesn't work on `macOS`
#elseif os(tvOS)
        nil
#elseif os(watchOS)
        nil
#elseif os(visionOS)
        nil
#endif
    }()

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}
