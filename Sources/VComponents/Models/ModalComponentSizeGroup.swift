//
//  ModalComponentSizeGroup.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import Foundation
import VCore

// MARK: - Modal Component Size Group
/// Modal component sizes.
@MemberwiseInitializable(
    comment: "/// Initializes `ModalComponentSizeGroup` with sizes."
)
public struct ModalComponentSizeGroup<Size> {
    // MARK: Properties
    /// Portrait size .
    public var portrait: Size

    /// Landscape size.
    public var landscape: Size

    // MARK: Initializers
    /// Initializes `ModalComponentSizeGroup` with size.
    public init(
        _ size: Size
    ) {
        self.portrait = size
        self.landscape = size
    }

    // MARK: Current
    func current(
        orientation: PlatformInterfaceOrientation
    ) -> Size {
        switch orientation {
        case .portrait: portrait
        case .landscape: landscape
        }
    }
}

extension ModalComponentSizeGroup: Equatable where Size: Equatable {}

extension ModalComponentSizeGroup: Sendable where Size: Sendable {}

// MARK: - Modal Component Size
/// Modal component size.
@MemberwiseInitializable(
    comment: "/// Initializes `ModalComponentSize` with width and height."
)
public struct ModalComponentSize<Width, Height> {
    /// Width.
    public var width: Width

    /// Height.
    public var height: Height
}

extension ModalComponentSize: Equatable where Width: Equatable, Height: Equatable {}

extension ModalComponentSize: Sendable where Width: Sendable, Height: Sendable {}

// MARK: - Helpers
extension AbsoluteFractionMeasurement {
    static var zero: Self {
        .absolute(0)
    }
}
