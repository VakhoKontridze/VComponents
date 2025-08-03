//
//  APIBridges.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.08.25.
//

import SwiftUI

extension SubmitLabel: @retroactive Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        false
    }
}

extension TextInputAutocapitalization: @retroactive Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        false
    }
}
