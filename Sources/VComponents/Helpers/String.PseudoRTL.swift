//
//  String.PseudoRTL.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 02.04.23.
//

import SwiftUI

// MARK: - Pseudo RTL
extension String {
    func pseudoRTL(
        _ layoutDirection: LayoutDirection
    ) -> Self {
        if layoutDirection == .rightToLeft {
            return String(self.reversed())
        } else {
            return self
        }
    }
}
